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


/**
 *
 * nsdata转nsstring
 *
 **/
+ (NSString*)hexStringForData:(NSData *)data;

/**
 *
 *  nsstring转nsdata
 *
 **/
+ (NSData*)dataForHexString:(NSString*)hexString;


/**
 *
 *  十六进制字符串转十进制（如：@"AA" -> 170）
 *
 **/
+ (NSInteger)hexToInt:(NSString *)hexString;


/**
 *
 *  十进制转十六进制字符串（如：170 -> @"AA"）
 *
 **/
+ (NSString *)intToHex:(uint16_t)number;


/**
 *
 *  判断两个日期是否为同一天
 *
 **/
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;


/**
 *
 *  判断两个日期是否为同一小时
 *
 **/
+ (BOOL)isSameHour:(NSDate*)date1 date2:(NSDate*)date2;


@end
