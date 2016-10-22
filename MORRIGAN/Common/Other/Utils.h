//
//  Utils.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//判断手机号码格式是否正确
+ (BOOL)checkMobile:(NSString *)mobile;


//判断验证码是否有效
+ (BOOL)checkAuthCode:(NSString *)authCode;

//判断密码是否有效
+ (BOOL)checkPassWord:(NSString *)password;

// 十六进制转UIColor（如@“＃ff0000”）
+ (UIColor *) stringTOColor:(NSString *)str;


@end
