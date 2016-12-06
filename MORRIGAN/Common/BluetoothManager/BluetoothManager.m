//
//  BluetoothManager.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BluetoothManager.h"
#import "ReconnectView.h"

static BluetoothManager *manager;
static NSString * const ServiceUUID = @"56FF";
static NSString * const SendCharacteristicUUID = @"000033F1-0000-1000-8000-00805F9B34FB";
static NSString * const ReceiveCharacteristicUUID = @"000033F2-0000-1000-8000-00805F9B34FB";

NSString * const ConnectPeripheralSuccess = @"ConnectPeripheralSuccess";
NSString * const ConnectPeripheralError = @"ConnectPeripheralError";
NSString * const ConnectPeripheralTimeOut = @"ConnectPeripheralTimeOut";
NSString * const DisconnectPeripheral = @"DisconnectPeripheral";
NSString * const PeripheralReadedCharacteristic = @"PeripheralReadedCharacteristic";

NSString * const ElectricQuantityChanged = @"ElectricQuantityChanged";


@interface BluetoothManager () {
    NSTimer *_timer;
}

@property (nonatomic,strong)CBPeripheral *curConnectPeripheral;      // 当前连接的设备
@property (nonatomic,strong)CBCharacteristic *sendCharacteristic;    // 写特征
@property (nonatomic,strong)CBCharacteristic *receiveCharacteristic; // 读特征

@property (nonatomic,strong)BluetoothOperation *currentOperation;    //正在操作的operation
@property (nonatomic,assign)BOOL manualDisconnect;                   //是否手动断开连接

@property (nonatomic,assign)BOOL reconnect;                          //是否要重新连接  YES:需要重新连接

@property (nonatomic,strong)ReconnectView *reconnectView;

@property (nonatomic,copy)NSString *lastConnectedAddress;                //已连接上设备的MAC地址


@end

@implementation BluetoothManager

+ (BOOL)isExsitBluetoothManager {
    return manager? YES : NO;
}

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
//        _operationQueue = [[NSMutableArray alloc] init];
        _scannedPeripherals = [[NSMutableArray alloc] init];
        _macAddresses = [[NSMutableArray alloc] init];
        
        _manualDisconnect = NO;
        _reconnect = YES;
        [self babyDelegate];
        
    }
    return self;
}

- (CBCentralManager *)getCentralManager {
    return _baby.centralManager;
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
        if (![weakSelf.scannedPeripherals containsObject:peripheral]) {
            [weakSelf.scannedPeripherals addObject:peripheral];
            NSArray *array = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
            NSMutableString *macAddress;
            if (array.count) {
                macAddress = [[NSMutableString alloc] init];
                for (NSInteger i = 0; i < array.count - 1; i++) {
                    NSUUID *uuid = [array objectAtIndex:i];
                    NSString *string = uuid.UUIDString;
                    if (i == 0) {
                        [macAddress appendFormat:@"%@:%@",
                         [string substringWithRange:NSMakeRange(0, 2)],
                         [string substringWithRange:NSMakeRange(2, 2)]];
                    }
                    else {
                        [macAddress appendFormat:@":%@:%@",
                         [string substringWithRange:NSMakeRange(0, 2)],
                         [string substringWithRange:NSMakeRange(2, 2)]];
                    }
                }
                [weakSelf.macAddresses addObject:macAddress];
            }
            NSLog(@"搜索到了设备:%@   MAC : %@",peripheral.name,macAddress);
            
            //如果不是手动断开连接,并且需要重连
            if (weakSelf.reconnect && [weakSelf.lastConnectedAddress isEqualToString:macAddress]) {
                weakSelf.reconnect = NO;
                [weakSelf connectingBlueTooth:peripheral];
            }
            
        }
    }];
    
    //设备连接成功的委托
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@连接成功",peripheral.name);
        weakSelf.curConnectPeripheral = peripheral;
        weakSelf.isConnected = YES;
        weakSelf.reconnect = YES;
        weakSelf.manualDisconnect = NO;
        
        [weakSelf hideConnectView];
        //连接成功后保存为已绑定设备信息
        if (![DBManager insertPeripheral:peripheral macAddress:weakSelf.willConnectMacAddress]) {
            NSLog(@"保存已绑定设备信息失败.  peripheral.name : %@",peripheral.name);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectPeripheralSuccess
                                                            object:nil];
        
    }];
    
    
    //发现设备的Services的委托
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
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
            //获取到读/写特征值通知
            [[NSNotificationCenter defaultCenter] postNotificationName:PeripheralReadedCharacteristic
                                                                object:nil];
            
            [weakBaby notify:weakSelf.curConnectPeripheral characteristic:weakSelf.receiveCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                NSLog(@"receive characteristics : %@",characteristics);
                // 本次接收的数据
                NSData *receiveData = [characteristics value];
//                NSLog(@"完整接收：%@ [长度：%ld]", receiveData, (unsigned long)receiveData.length);
                NSString *receiveDataHexString = [Utils hexStringForData:receiveData];
               
                // 判断接收的数据是否有效
                BOOL isValid = [weakSelf isValidOfReceiveData:receiveDataHexString];
                // 指令是否成功
                BOOL success = NO;
                NSError *responseError;
                
                if(isValid) {
//                    NSLog(@"数据有效");
                    // 应答处理(不给模块应答，模块会重复发5次数据)
                    NSString *answerCode = [receiveDataHexString substringWithRange:NSMakeRange(4, 2)];

                    if([answerCode isEqualToString:@"ee"]) {
                        // @"ee"是模块给客户端的应答，不处理
                        success = YES;
                    } else {
                        NSString *order = [receiveDataHexString substringWithRange:NSMakeRange(4, 2)];
                        NSString *code = [receiveDataHexString substringWithRange:NSMakeRange(36, 2)];
                        //蓝牙设备通知app电量变化
                        if ([order isEqualToString:@"02"] &&[code isEqualToString:@"01"]) {
                            success = YES;
                            NSString *electriQuantity = [receiveDataHexString substringWithRange:NSMakeRange(6, 2)];
                            [[NSNotificationCenter defaultCenter] postNotificationName:ElectricQuantityChanged
                                                                                object:electriQuantity];
                            //收到电量变化后,发送应答包(否则蓝牙设备会连续发5次数据给app)
                            BluetoothOperation *operation = [[BluetoothOperation alloc] init];
                            [operation setValue:@"EE" index:2];
                            [operation setValue:@"02" index:3];
                            [weakSelf writeValueByOperation:operation];
                            return;
                        }
                        //蓝牙设备返回无效数据
                        else {
                            NSLog(@"数据无效");
                            responseError = [[NSError alloc] initWithDomain:@"" code:-888 userInfo:@{@"message":@"蓝牙设备返回数据无效"}];
                        }
                    }
                    // 有效数据获取返回给Controller处理
                } else {
                    NSLog(@"数据无效");
                    responseError = [[NSError alloc] initWithDomain:@"" code:-888 userInfo:@{@"message":@"蓝牙设备返回数据无效"}];
                }
                
                if (weakSelf.currentOperation.response) {
                    weakSelf.currentOperation.response(receiveDataHexString,weakSelf.currentOperation.tag,responseError,success);
                }

            }];
            
        }
        
    }];
    
    //写数据成功的block
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (!error) {
//            NSLog(@"发送成功：%@", characteristic.value);
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
        //通知连接蓝牙设备失败
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectPeripheralError
                                                            object:nil];
        [weakSelf endTimer];
        [weakSelf hideConnectView];
    }];
    
    [_baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
        NSLog(@"成功取消所有外设连接");
        weakSelf.currentOperation = nil;
        weakSelf.curConnectPeripheral = nil;
        weakSelf.isConnected = NO;
    }];
    
    //设备断开连接的委托
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@断开连接",peripheral.name);
        
        weakSelf.currentOperation = nil;
        weakSelf.isConnected = NO;
        weakSelf.curConnectPeripheral = nil;
        //通知断开蓝牙设备
        [[NSNotificationCenter defaultCenter] postNotificationName:DisconnectPeripheral
                                                            object:@(weakSelf.manualDisconnect)];
        [weakSelf endTimer];
        
        //如果是手动断开连接
        if (weakSelf.manualDisconnect) {
            
            weakSelf.manualDisconnect = NO;
        }
        else {
            //如果不是手动断开连接,并且需要重连
            if (weakSelf.reconnect) {
                [weakSelf showConnectView];
                weakSelf.lastConnectedAddress = weakSelf.willConnectMacAddress;
                [weakSelf startReconnectPeripheralTimer];
                [weakSelf start];
            }
        }
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
    _manualDisconnect = YES;
    _lastConnectedAddress = nil;
    [_baby cancelAllPeripheralsConnection];
}




#pragma mark - 往连接的设备写数据

- (void)writeValueByOperation:(BluetoothOperation *)operation {
    
    _currentOperation = operation;
    //如果指令是停止播放音乐
    if (operation.tag == MUSIC_STOP_TAG) {
        [self writeValue:[operation getData]];
        return;
    }
    if (!_isConnected) {
        NSLog(@"未连接上蓝牙设备");
        return;
    }
    [self writeValue:[operation getData]];
}

- (void)writeValue:(NSData *)data {
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
//    NSLog(@"receiveDataHexString：%@ [长度：%ld]", receiveDataHexString, receiveDataHexString.length);
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
//    NSLog(@"verifyIntValue: %ld  ,  receiveVerifyIntValue: %ld", verifyIntValue, receiveVerifyIntValue);
    if(verifyIntValue != receiveVerifyIntValue) {
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (void)startConnectPeripheralTimer {
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:30
                                              target:self
                                            selector:@selector(connectPeripheralTimeOut)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)startReconnectPeripheralTimer {
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:30
                                              target:self
                                            selector:@selector(reconnectPeripheralTimeOut)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)startTimer {
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:30
                                              target:self
                                            selector:@selector(writeDataTimeOut)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)endTimer {
    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)connectPeripheralTimeOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectPeripheralTimeOut
                                                        object:nil];
}

- (void)reconnectPeripheralTimeOut {
    [self hideConnectView];
}

- (void)writeDataTimeOut {
    if (_currentOperation.response) {
        NSError *responseError = [[NSError alloc] initWithDomain:@"" code:-888 userInfo:@{@"message":@"蓝牙设备返回数据无效"}];
        _currentOperation.response(nil,_currentOperation.tag,responseError,NO);
    }
}

#pragma mark - 重连

- (void)showConnectView {
    [self hideConnectView];
    _reconnectView = [[ReconnectView alloc] initWithFrame:UI_Window.bounds];
    [UI_Window addSubview:_reconnectView];
}

- (void)hideConnectView {
    if (_reconnectView) {
        [_reconnectView removeFromSuperview];
        _reconnectView = nil;
    }
}

@end
