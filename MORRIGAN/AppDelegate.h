//
//  AppDelegate.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "LDSLocation.h"

// 欢迎界面等待时间
#define kWelcomePageDelayTime   1.0

 

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) Reachability *reach;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;

@property (nonatomic , strong) LDSLocation *LDSLocation;
@property (nonatomic , strong) NSTimer *ldsbacktimes;

- (BOOL)checkReachable;

@end

