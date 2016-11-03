//
//  BluetoothManager.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BluetoothManager.h"
#import "BtSettingInfo.h"

static BluetoothManager *manager;
static NSString * const ServiceUUID = @"56FF";
static NSString * const SendCharacteristicUUID = @"000033F1-0000-1000-8000-00805F9B34FB";
static NSString * const ReceiveCharacteristicUUID = @"000033F2-0000-1000-8000-00805F9B34FB";



@interface BluetoothManager ()

@property (nonatomic,strong)CBPeripheral *willConnectPeripheral;     // 将要连接的设备
@property (nonatomic,strong)CBPeripheral *curConnectPeripheral;      // 当前连接的设备
@property (nonatomic,strong)CBCharacteristic *sendCharacteristic;    // 写特征
@property (nonatomic,strong)CBCharacteristic *receiveCharacteristic; // 读特征

@property (nonatomic,strong)NSMutableArray *operationQueue;          //operation队列
@property (nonatomic,strong)BluetoothOperation *currentOperation;    //正在操作的operation
@property (nonatomic,assign)BOOL writing;                            //是否正在写数据


@end

@implementation BluetoothManager

+ (BluetoothManager *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BluetoothManager alloc] init];
    });
    return  manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baby = [BabyBluetooth shareBabyBluetooth];
        _operationQueue = [[NSMutableArray alloc] init];
        _scannedPeripherals = [[NSMutableArray alloc] init];
        [self babyDelegate];
        
    }
    return self;
}

- (void)babyDelegate {
    
    __weak typeof(self) weakSelf = self;
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，开始扫描设备");
        }
    }];
    
    //扫描到设备的委托
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        if (![weakSelf.scannedPeripherals containsObject:peripheral]) {
            [weakSelf.scannedPeripherals addObject:peripheral];
        }
    }];
    
    //设备连接成功的委托
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@连接成功",peripheral.name);
        _curConnectPeripheral = peripheral;
        _isConnected = YES;
    }];
    
    
    //发现设备的Services的委托
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
//        for (int i=0;i<peripherals.count;i++) {
//            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            if ([cell.textLabel.text isEqualToString:peripheral.name]) {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)peripheral.services.count];
//            }
//        }
    }];
    
    __block BabyBluetooth *weakBaby = _baby;
    //发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"发现设service的Characteristics service name:%@",service.UUID);
        //判断服务的UUID是否正确
        if ([service.UUID.UUIDString isEqualToString:ServiceUUID]) {
            for (CBCharacteristic *c in service.characteristics) {
                if ([c.UUID.UUIDString isEqualToString:SendCharacteristicUUID]) {
                    NSLog(@"发现写特征 :%@",c.UUID);
                    weakSelf.sendCharacteristic = c;
                } else if ([c.UUID.UUIDString isEqualToString:ReceiveCharacteristicUUID]) {
                    NSLog(@"发现读特征 :%@",c.UUID);
                    weakSelf.receiveCharacteristic = c;
                }
            }
        }
        
        
        if (weakSelf.sendCharacteristic && weakSelf.receiveCharacteristic) {
            [weakBaby notify:weakSelf.curConnectPeripheral characteristic:weakSelf.receiveCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                NSLog(@"receive characteristics : %@",characteristics);
                weakSelf.writing = NO;
                // 本次接收的数据
                NSData *receiveData = [characteristics value];
                NSLog(@"完整接收：%@ [长度：%ld]", receiveData, receiveData.length);
                NSString *receiveDataHexString = [Utils hexStringForData:receiveData];
               
                // 判断接收的数据是否有效
                BOOL isValid = [weakSelf isValidOfReceiveData:receiveDataHexString];
                // 指令是否成功
                BOOL success = NO;
                NSError *responseError;
                
                if(isValid) {
                    NSLog(@"数据有效");
                    // 应答处理(不给模块应答，模块会重复发5次数据)
                    NSString *answerCode = [receiveDataHexString substringWithRange:NSMakeRange(4, 2)];

                    if([answerCode isEqualToString:@"ee"]) {
                        // @"ee"是模块给客户端的应答，不处理
                        success = YES;
                    } else {
                        [weakSelf writeValue:[[BtSettingInfo share] getResultDataOfAnswer:answerCode]];
                    }
                    // 有效数据获取返回给Controller处理
                } else {
                    NSLog(@"数据无效");
                    responseError = [[NSError alloc] initWithDomain:@"" code:-888 userInfo:@{@"message":@"蓝牙设备返回数据无效"}];
                }
                
                if (weakSelf.currentOperation.response) {
                    weakSelf.currentOperation.response(receiveDataHexString,weakSelf.currentOperation.tag,responseError,success);
                }
                
                [weakSelf.operationQueue removeObject:weakSelf.currentOperation];
                weakSelf.currentOperation = nil;
                if (weakSelf.operationQueue.count > 0) {
                    weakSelf.currentOperation = weakSelf.operationQueue[0];
                    [weakSelf writeValueByOperation:weakSelf.currentOperation];
                }

            }];
            
        }
        
    }];
    
    //写数据成功的block
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (!error) {
            NSLog(@"发送成功：%@", characteristic.value);
        } else {
            NSLog(@"发送失败：%@   error : %@", characteristic.value,error);
        }
    }];
    
    //读取characteristics的委托
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
    //发现characteristics的descriptors的委托
    [_baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    
    //查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:@"Morrigan"] ) {
            return YES;
        }
        return NO;
    }];
    
    //设备连接失败的委托
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@连接失败",peripheral.name);
        _isConnected = NO;
        
    }];
    
    //设备断开连接的委托
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@断开连接",peripheral.name);
        weakSelf.currentOperation = nil;
        weakSelf.curConnectPeripheral = nil;
        weakSelf.isConnected = NO;
        weakSelf.writing = NO;
    }];
    
    
    [_baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
        NSLog(@"成功取消所有外设连接");
        weakSelf.currentOperation = nil;
        weakSelf.curConnectPeripheral = nil;
        weakSelf.isConnected = NO;
        weakSelf.writing = NO;
    }];
    
    [_baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
        NSLog(@"成功取消扫描");
    }];

    
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    
    [_baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                              connectPeripheralWithOptions:connectOptions
                            scanForPeripheralsWithServices:nil
                                      discoverWithServices:nil
                               discoverWithCharacteristics:nil];
}

- (void)start {
    _baby.scanForPeripherals().begin();
    [_scannedPeripherals removeAllObjects];
}

- (void)stop {
    [_baby cancelScan];
}

-(void)connectingBlueTooth:(CBPeripheral *)peripheral {
    _baby.having(peripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
}

-(void)unConnectingBlueTooth {
    [_baby cancelAllPeripheralsConnection];
}



#pragma mark - 连接／断开设备（测试）

- (void)scanTest
{
    [self start];
}

- (void)connectTest
{
    if(self.willConnectPeripheral) {
        [self connectingBlueTooth:self.willConnectPeripheral];
    }
   
}

- (void)unConnectTest
{
    [self unConnectingBlueTooth];

}


#pragma mark - 往连接的设备写数据

- (void)writeValueByOperation:(BluetoothOperation *)operation {
    _currentOperation = operation;
    [_operationQueue addObject:operation];
    if (!_writing) {
        [self writeValue:[operation getData]];
    }
}

- (void)writeValue:(NSData *)data {
    _writing = YES;
    if(self.curConnectPeripheral == nil || self.sendCharacteristic == nil || !data){
        NSLog(@"curConnectPeripheral 或 sendCharacteristic 为空，取消发送！");
        return;
    }
    NSLog(@"准备发送：%@", data);
    [self.curConnectPeripheral writeValue:data
                        forCharacteristic:self.sendCharacteristic
                                     type:CBCharacteristicWriteWithResponse];
}



// 获取接收数据的长度
- (NSInteger)getLength:(NSData *)data
{
    NSData *lengthData = [data subdataWithRange:NSMakeRange(1, 2)];
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:[Utils hexStringForData:lengthData]];
    [scanner scanHexLongLong:&result];
    return result;
}

// 判断接收的数据是否有效
- (BOOL)isValidOfReceiveData:(NSString *)receiveDataHexString
{
    NSLog(@"receiveDataHexString：%@ [长度：%ld]", receiveDataHexString, receiveDataHexString.length);
    // 检查是否是20字节
    if(receiveDataHexString.length != 20*2) {
        return NO;
    }
    // 检查前2字节是否是@“aa55”
    if(![[receiveDataHexString substringToIndex:4] isEqualToString:@"aa55"]) {
        return NO;
    }
    // 检查校验值（0x00~0xff，前面19个无符号数字相加的和，其和对256取余数）
    NSInteger verifyIntValue = 0;
    for (NSInteger i = 0; i < 40-2; i += 2) {
        NSString *str = [receiveDataHexString substringWithRange:NSMakeRange(i, 2)];
        //NSLog(@"%ld , %@", i, str);
        verifyIntValue += [Utils hexToInt:str];
    }
    verifyIntValue = verifyIntValue % 256;
    NSInteger receiveVerifyIntValue = [Utils hexToInt:[receiveDataHexString substringWithRange:NSMakeRange(38, 2)]];
    NSLog(@"verifyIntValue: %ld  ,  receiveVerifyIntValue: %ld", verifyIntValue, receiveVerifyIntValue);
    if(verifyIntValue != receiveVerifyIntValue) {
        return NO;
    }
    
    return YES;
}

@end
