//
//  BluetoothManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "BluetoothOperation.h"
#import "PeripheralModel.h"

#define MUSIC_STOP_TAG 1            //停止播放音乐
#define MUSIC_PEAKPOWER_TAG 2       //音乐分贝大小

extern NSString * const ConnectPeripheralSuccess;
extern NSString * const ConnectPeripheralError;
extern NSString * const ConnectPeripheralTimeOut;
extern NSString * const DisconnectPeripheral;
extern NSString * const PeripheralReadedCharacteristic;     //获取到了读/写的特征值

extern NSString * const ElectricQuantityChanged;        //设备电池电量变化通知

@interface BluetoothManager : NSObject {
    BabyBluetooth *_baby;
}

@property (nonatomic,assign)BOOL isConnected;

@property (nonatomic,strong)NSMutableArray *scannedPeripherals;              // 扫描到的所有设备
@property (nonatomic,strong)NSMutableArray *macAddresses;                    // 设备的MAC地址
@property (nonatomic,strong)NSString *willConnectMacAddress;                        // 将要连接的设备的MAC地址

+ (BluetoothManager *)share;

- (void)start;

- (void)stop;

-(void)connectingBlueTooth:(CBPeripheral *)peripheral;

- (void)writeValueByOperation:(BluetoothOperation *)operation;

//断开所有已连接设备
-(void)unConnectingBlueTooth;

@end
