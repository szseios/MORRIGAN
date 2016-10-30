//
//  BluetoothManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

@interface BluetoothManager : NSObject {
    BabyBluetooth *_baby;
}

+ (BluetoothManager *)share;

@end
