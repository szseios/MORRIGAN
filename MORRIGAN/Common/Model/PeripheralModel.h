//
//  PeripheralModel.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/8.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralModel : NSObject

@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) CBPeripheral *peripheral;

@end
