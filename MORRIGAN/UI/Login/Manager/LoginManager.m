//
//  LoginManager.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "LoginManager.h"



static LoginManager *manager;

@implementation LoginManager

+ (LoginManager *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoginManager alloc] init];
    });
    
    return manager;

}

@end
