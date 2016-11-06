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

extern NSString * const ConnectPeripheralSuccess;
extern NSString * const ConnectPeripheralError;
extern NSString * const DisconnectPeripheral;

@interface BluetoothManager : NSObject {
    BabyBluetooth *_baby;
}

@property (nonatomic,assign)BOOL isConnected;

@property (nonatomic,strong)NSMutableArray *scannedPeripherals;


+ (BluetoothManager *)share;

- (void)start;

- (void)stop;

- (void)connectingBlueTooth:(CBPeripheral *)peripheral;

- (void)writeValueByOperation:(BluetoothOperation *)operation;

- (void)scanTest;
- (void)connectTest;
- (void)unConnectTest;
- (void)writeValue:(NSData *)data;

@end
