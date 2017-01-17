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

+ (void)resetUserInfo
{
    [UserInfo share].emotion = @"";
    [UserInfo share].emotionStr = @"";
    [UserInfo share].nickName = @"";
    [UserInfo share].userId = @"";
    [UserInfo share].imgUrl = @"";
    [UserInfo share].high = @"";
    [UserInfo share].weight = @"";
    [UserInfo share].age = @"";
    [UserInfo share].sex = @"";
    [UserInfo share].authCode = @"";
    [UserInfo share].target = @"";
    [UserInfo share].mobile = @"";
    [UserInfo share].password = @"";
}

@end
