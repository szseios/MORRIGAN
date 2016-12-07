//
//  LoginManager.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "UserInfo.h"



static UserInfo *info;

@implementation UserInfo

+ (UserInfo *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[UserInfo alloc] init];
    });
    
    return info;

}

@end
