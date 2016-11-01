//
//  BtSettingInfo.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/1.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

/**
 
 蓝牙设置信息
 
 **/

#import <Foundation/Foundation.h>

@interface BtSettingInfo : NSObject

@property(nonatomic, strong)NSData *head1Data;  // 帧头
@property(nonatomic, strong)NSData *head2Data;  // 帧头
@property(nonatomic, strong)NSData *cmdNumData; // 数据命令号
@property(nonatomic, strong)NSData *switchData; // 开关（01：开  00:关）
@property(nonatomic, strong)NSData *modeData;   // 模式（0x01~0x03，0x01:手动模式  0x02:自动模式  0x03:音乐模式）
@property(nonatomic, strong)NSData *gearData;   // 档位（0x01~0x03，手动模式有效）
@property(nonatomic, strong)NSData *leftRightData; // 左右（0x00:左右同时  0x01:左  0x02:右， 手动模式有效）
@property(nonatomic, strong)NSData *group1Data;    // 组合单位1（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
@property(nonatomic, strong)NSData *group2Data;    // 组合单位2（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
@property(nonatomic, strong)NSData *group3Data;    // 组合单位3（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
@property(nonatomic, strong)NSData *group4Data;    // 组合单位4（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
@property(nonatomic, strong)NSData *group5Data;    // 组合单位5（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
@property(nonatomic, strong)NSData *dbData;        // 音频分贝值（0x00~0xA0，0：没声  160：音最高）
@property(nonatomic, strong)NSData *retain1Data;   // 保留
@property(nonatomic, strong)NSData *retain2Data;   // 保留
@property(nonatomic, strong)NSData *retain3Data;   // 保留
@property(nonatomic, strong)NSData *retain4Data;   // 保留
@property(nonatomic, strong)NSData *retain5Data;   // 保留
@property(nonatomic, strong)NSData *verifyData;    // 校验和（0x00~0xff，前面19个无符号数字相加的和，其和对256取余数）


+ (BtSettingInfo *)share;

/**
 *  获取最终发送的数据
 */
- (NSData *)getResultData;


@end
