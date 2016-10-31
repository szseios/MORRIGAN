//
//  BluetoothManager.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BluetoothManager.h"

static BluetoothManager *manager;
static NSString *SendCharacteristicUUID = @"000033F1-0000-1000-8000-00805F9B34FB";
static NSString *ReceiveCharacteristicUUID = @"000033F2-0000-1000-8000-00805F9B34FB";



@interface BluetoothManager ()

@property (nonatomic,strong)CBPeripheral *willConnectPeripheral;     // 将要连接的设备
@property (nonatomic,strong)CBPeripheral *curConnectPeripheral;      // 当前连接的设备
@property (nonatomic,strong)CBCharacteristic *sendCharacteristic;    // 写特征
@property (nonatomic,strong)CBCharacteristic *receiveCharacteristic; // 读特征



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
        [self babyDelegate];
        //[self start];
        
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
    
    //设置扫描到设备的委托
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        // 测试连接设备
        if([peripheral.name isEqualToString:@"Morrigan"] && weakSelf.willConnectPeripheral  == nil) {
            weakSelf.willConnectPeripheral = peripheral;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已搜索到设备" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [weakSelf stop];
        }
        
        
    }];
    
    //设置设备连接成功的委托
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@连接成功",peripheral.name);
        _curConnectPeripheral = peripheral;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    
    //设置设备连接失败的委托
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@连接失败",peripheral.name);
        
    }];
    
    //设置设备断开连接的委托
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@断开连接",peripheral.name);
        weakSelf.curConnectPeripheral = nil;
        weakSelf.willConnectPeripheral = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已断开连接" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    //设置发现设备的Services的委托
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
    //设置发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
            if ([c.UUID.UUIDString isEqualToString:SendCharacteristicUUID]) {
                NSLog(@"发现写特征 :%@",c.UUID);
                weakSelf.sendCharacteristic = c;
            } else if ([c.UUID.UUIDString isEqualToString:ReceiveCharacteristicUUID]) {
                NSLog(@"发现读特征 :%@",c.UUID);
                weakSelf.receiveCharacteristic = c;
            }
        }
        
        if (weakSelf.sendCharacteristic && weakSelf.receiveCharacteristic) {
            [weakBaby notify:weakSelf.curConnectPeripheral characteristic:weakSelf.receiveCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
               
                NSLog(@"receive characteristics : %@",characteristics);
                // 本次接收的数据
                NSData *receiveData = [characteristics value];
                NSLog(@"完整接收：%@ [长度：%ld]", receiveData, receiveData.length);
                
                
                
                
            }];
            
        }
        
    }];
    
    //设置写数据成功的block
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (!error) {
            NSLog(@"发送成功：%@", characteristic.value);
        } else {
            NSLog(@"发送失败：%@", characteristic.value);
        }
    }];
    
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    //设置读取characteristics的委托
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
    //设置发现characteristics的descriptors的委托
    [_baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [_baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:@"Morrigan"] ) {
            return YES;
        }
        return NO;
    }];
    
    
    [_baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
        NSLog(@"成功取消所有外设连接");
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
}

- (void)stop {
    [_baby cancelScan];
}

-(void)connectingBlueTooth:(CBPeripheral *)peripheral {
    _baby.having(peripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
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
- (void)writeValue:(NSData *)data {
    
    if(self.curConnectPeripheral == nil || self.sendCharacteristic == nil){
        NSLog(@"curConnectPeripheral 或 sendCharacteristic 为空，取消发送！");
        return;
    }
    
    // 如果大于20子节，分次发送
    for (int i = 0; i < data.length; i+=20) {
        
        NSData *sendData = [data subdataWithRange:NSMakeRange(i, data.length - i > 20 ? 20: data.length - i)];
        
        NSLog(@"准备发送：%@", sendData);
        [self.curConnectPeripheral writeValue:sendData
                        forCharacteristic:self.sendCharacteristic
                                     type:CBCharacteristicWriteWithResponse];
        
    }
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

@end
