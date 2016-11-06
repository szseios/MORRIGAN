//
//  登陆界面
//
//  LoginViewController.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBaseController.h"
#import "RootViewController.h"

#define kUserDefaultIdKey             @"kUserDefaultIdKey"        // 保存用户名key
#define kUserDefaultPasswordKey       @"kUserDefaultPasswordKey"  // 保存密码key


@interface LoginViewController : LoginBaseController

@property (nonatomic , strong) RootViewController *homePageController;

@end
