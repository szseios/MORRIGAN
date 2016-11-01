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
    info.head1Data      = [Utils dataForHexString:@"AA"];
    info.head2Data      = [Utils dataForHexString:@"55"];
    info.cmdNumData     = [Utils dataForHexString:@"01"];
    info.switchData     = [Utils dataForHexString:@"01"];  // 默认开关开
    info.modeData       = [Utils dataForHexString:@"01"];  // 默认手动按摩
    info.gearData       = [Utils dataForHexString:@"01"];  // 默认一档位
    info.leftRightData  = [Utils dataForHexString:@"00"];  // 默认左右同时按摩
    info.group1Data     = [Utils dataForHexString:@"00"];
    info.group2Data     = [Utils dataForHexString:@"00"];
    info.group3Data     = [Utils dataForHexString:@"00"];
    info.group4Data     = [Utils dataForHexString:@"00"];
    info.group5Data     = [Utils dataForHexString:@"00"];
    info.dbData         = [Utils dataForHexString:@"00"];  // 默认没声
    info.retain1Data    = [Utils dataForHexString:@"00"];
    info.retain2Data    = [Utils dataForHexString:@"00"];
    info.retain3Data    = [Utils dataForHexString:@"00"];
    info.retain4Data    = [Utils dataForHexString:@"00"];
    info.retain5Data    = [Utils dataForHexString:@"00"];
    info.verifyData     = [Utils dataForHexString:@"00"];
}

/**
 *  获取最终发送的数据
 */
- (NSData *)getResultData
{
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:info.head1Data];
    [resultData appendData:info.head2Data];
    [resultData appendData:info.cmdNumData];
    [resultData appendData:info.switchData];
    [resultData appendData:info.modeData];
    [resultData appendData:info.gearData];
    [resultData appendData:info.leftRightData];
    [resultData appendData:info.group1Data];
    [resultData appendData:info.group2Data];
    [resultData appendData:info.group3Data];
    [resultData appendData:info.group4Data];
    [resultData appendData:info.group5Data];
    [resultData appendData:info.dbData];
    [resultData appendData:info.retain1Data];
    [resultData appendData:info.retain2Data];
    [resultData appendData:info.retain3Data];
    [resultData appendData:info.retain4Data];
    [resultData appendData:info.retain5Data];
    

// 计算校验值(暂时没计算)
    info.verifyData = [Utils dataForHexString:@"00"];
    
    
    
    
    
    
    [resultData appendData:info.verifyData];
    
    return resultData;
}



@end
