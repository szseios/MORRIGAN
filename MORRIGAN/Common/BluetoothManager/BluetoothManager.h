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

@interface BluetoothManager : NSObject {
    BabyBluetooth *_baby;
}

@property (nonatomic,assign)BOOL isConnected;


+ (BluetoothManager *)share;

- (void)scanTest;
- (void)connectTest;
- (void)unConnectTest;
- (void)writeValue:(NSData *)data;

@end
