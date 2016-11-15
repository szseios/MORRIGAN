//
//  EditDeviceNameController.h
//  MORRIGAN
//
//  Created by azz on 2016/11/15.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PeripheralModel;

#define CHANGEDEVICENAMENOTIFICATION @"CHANGEDEVICENAMENOTIFICATION" //修改设备名称

@interface EditDeviceNameController : UIViewController

- (instancetype)initWithDeviceName:(PeripheralModel*)model;

@end
