//
//  BtSettingInfo.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/1.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//


/**
 
 蓝牙设置信息
 
 **/

#import "BtSettingInfo.h"


static BtSettingInfo *info;

@implementation BtSettingInfo

+ (BtSettingInfo *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[BtSettingInfo alloc] init];
        [info initData];
    });
    
    return info;
}

/**
 *  初始化默认数据
 */
-(void)initData
{
    info.head1HexString      = @"AA";
    info.head2HexString      = @"55";
    info.cmdNumHexString     = @"01";
    info.switchHexString     = @"01";  // 默认开关开
    info.modeHexString       = @"01";  // 默认手动按摩
    info.gearHexString       = @"01";  // 默认一档位
    info.leftRightHexString  = @"00";  // 默认左右同时按摩
    info.group1HexString     = @"00";
    info.group2HexString     = @"00";
    info.group3HexString     = @"00";
    info.group4HexString     = @"00";
    info.group5HexString     = @"00";
    info.dbHexString         = @"00";  // 默认没声
    info.retain1HexString    = @"00";
    info.retain2HexString    = @"00";
    info.retain3HexString    = @"00";
    info.retain4HexString    = @"00";
    info.retain5HexString    = @"00";
    info.verifyHexString     = @"00";
}

/**
 *  获取最终发送的数据
 */
- (NSData *)getResultData
{
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:[Utils dataForHexString:info.head1HexString]];
    [resultData appendData:[Utils dataForHexString:info.head2HexString]];
    [resultData appendData:[Utils dataForHexString:info.cmdNumHexString]];
    [resultData appendData:[Utils dataForHexString:info.switchHexString]];
    [resultData appendData:[Utils dataForHexString:info.modeHexString]];
    [resultData appendData:[Utils dataForHexString:info.gearHexString]];
    [resultData appendData:[Utils dataForHexString:info.leftRightHexString]];
    [resultData appendData:[Utils dataForHexString:info.group1HexString]];
    [resultData appendData:[Utils dataForHexString:info.group2HexString]];
    [resultData appendData:[Utils dataForHexString:info.group3HexString]];
    [resultData appendData:[Utils dataForHexString:info.group4HexString]];
    [resultData appendData:[Utils dataForHexString:info.group5HexString]];
    [resultData appendData:[Utils dataForHexString:info.dbHexString]];
    [resultData appendData:[Utils dataForHexString:info.retain1HexString]];
    [resultData appendData:[Utils dataForHexString:info.retain2HexString]];
    [resultData appendData:[Utils dataForHexString:info.retain3HexString]];
    [resultData appendData:[Utils dataForHexString:info.retain4HexString]];
    [resultData appendData:[Utils dataForHexString:info.retain5HexString]];
    

   // 计算校验值
    NSInteger verifyIntValue = ([Utils hexToInt:info.head1HexString]
    + [Utils hexToInt:info.head2HexString]
    + [Utils hexToInt:info.cmdNumHexString]
    + [Utils hexToInt:info.switchHexString]
    + [Utils hexToInt:info.modeHexString]
    + [Utils hexToInt:info.gearHexString]
    + [Utils hexToInt:info.leftRightHexString]
    + [Utils hexToInt:info.group1HexString]
    + [Utils hexToInt:info.group2HexString]
    + [Utils hexToInt:info.group3HexString]
    + [Utils hexToInt:info.group4HexString]
    + [Utils hexToInt:info.group5HexString]
    + [Utils hexToInt:info.dbHexString]
    + [Utils hexToInt:info.retain1HexString]
    + [Utils hexToInt:info.retain2HexString]
    + [Utils hexToInt:info.retain3HexString]
    + [Utils hexToInt:info.retain4HexString]
    + [Utils hexToInt:info.retain5HexString]) % 256;
    info.verifyHexString = [Utils intToHex:verifyIntValue];
    [resultData appendData:[Utils dataForHexString: info.verifyHexString]];
    
    
    return resultData;
}


/**
 *  获取最终发送的获取电量数据
 */
- (NSData *)getResultDataOfBattery
{
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:[Utils dataForHexString:info.head1HexString]];
    [resultData appendData:[Utils dataForHexString:info.head2HexString]];
    [resultData appendData:[Utils dataForHexString:@"03"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    
    
    // 计算校验值
    NSInteger verifyIntValue = ([Utils hexToInt:info.head1HexString]
                                + [Utils hexToInt:info.head2HexString]
                                + [Utils hexToInt:info.cmdNumHexString]
                                + [Utils hexToInt:info.switchHexString]
                                + [Utils hexToInt:info.modeHexString]
                                + [Utils hexToInt:info.gearHexString]
                                + [Utils hexToInt:info.leftRightHexString]
                                + [Utils hexToInt:info.group1HexString]
                                + [Utils hexToInt:info.group2HexString]
                                + [Utils hexToInt:info.group3HexString]
                                + [Utils hexToInt:info.group4HexString]
                                + [Utils hexToInt:info.group5HexString]
                                + [Utils hexToInt:info.dbHexString]
                                + [Utils hexToInt:info.retain1HexString]
                                + [Utils hexToInt:info.retain2HexString]
                                + [Utils hexToInt:info.retain3HexString]
                                + [Utils hexToInt:info.retain4HexString]
                                + [Utils hexToInt:info.retain5HexString]) % 256;
    info.verifyHexString = [Utils intToHex:verifyIntValue];
    [resultData appendData:[Utils dataForHexString: info.verifyHexString]];
    
    
    return resultData;
}

/**
 *  获取最终发送的蓝牙是否可通讯数据
 */
- (NSData *)getResultDataOfBtEnable
{
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:[Utils dataForHexString:info.head1HexString]];
    [resultData appendData:[Utils dataForHexString:info.head2HexString]];
    [resultData appendData:[Utils dataForHexString:@"04"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    
    
    // 计算校验值
    NSInteger verifyIntValue = ([Utils hexToInt:info.head1HexString]
                                + [Utils hexToInt:info.head2HexString]
                                + [Utils hexToInt:info.cmdNumHexString]
                                + [Utils hexToInt:info.switchHexString]
                                + [Utils hexToInt:info.modeHexString]
                                + [Utils hexToInt:info.gearHexString]
                                + [Utils hexToInt:info.leftRightHexString]
                                + [Utils hexToInt:info.group1HexString]
                                + [Utils hexToInt:info.group2HexString]
                                + [Utils hexToInt:info.group3HexString]
                                + [Utils hexToInt:info.group4HexString]
                                + [Utils hexToInt:info.group5HexString]
                                + [Utils hexToInt:info.dbHexString]
                                + [Utils hexToInt:info.retain1HexString]
                                + [Utils hexToInt:info.retain2HexString]
                                + [Utils hexToInt:info.retain3HexString]
                                + [Utils hexToInt:info.retain4HexString]
                                + [Utils hexToInt:info.retain5HexString]) % 256;
    info.verifyHexString = [Utils intToHex:verifyIntValue];
    [resultData appendData:[Utils dataForHexString: info.verifyHexString]];
    
    
    return resultData;
}


/**
 *  获取最终发送的应答数据(answerCode:需要应答的对应数据，从接收到的数据中获取这个值，然后作为参数传进来)
 */
- (NSData *)getResultDataOfAnswer:(NSString *)answerCode
{
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:[Utils dataForHexString:info.head1HexString]];
    [resultData appendData:[Utils dataForHexString:info.head2HexString]];
    [resultData appendData:[Utils dataForHexString:@"EE"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    [resultData appendData:[Utils dataForHexString:@"00"]];
    
    
    // 计算校验值
    NSInteger verifyIntValue = ([Utils hexToInt:info.head1HexString]
                                + [Utils hexToInt:info.head2HexString]
                                + [Utils hexToInt:info.cmdNumHexString]
                                + [Utils hexToInt:info.switchHexString]
                                + [Utils hexToInt:info.modeHexString]
                                + [Utils hexToInt:info.gearHexString]
                                + [Utils hexToInt:info.leftRightHexString]
                                + [Utils hexToInt:info.group1HexString]
                                + [Utils hexToInt:info.group2HexString]
                                + [Utils hexToInt:info.group3HexString]
                                + [Utils hexToInt:info.group4HexString]
                                + [Utils hexToInt:info.group5HexString]
                                + [Utils hexToInt:info.dbHexString]
                                + [Utils hexToInt:info.retain1HexString]
                                + [Utils hexToInt:info.retain2HexString]
                                + [Utils hexToInt:info.retain3HexString]
                                + [Utils hexToInt:info.retain4HexString]
                                + [Utils hexToInt:info.retain5HexString]) % 256;
    info.verifyHexString = [Utils intToHex:verifyIntValue];
    [resultData appendData:[Utils dataForHexString: info.verifyHexString]];
    
    
    return resultData;
}




@end
