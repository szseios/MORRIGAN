//
//  SZSEConfigTool.h
//  SZSE
//
//  Created by Simon on 15-7-1.
//  Copyright (c) 2015年 szse. All rights reserved.
//

/*
 版本控制工具类
 */


/***************************当前程序版本状态********************************/
typedef NS_ENUM(NSInteger, VersionState) {
    lastest_version         =0,     //最新版本
    forceUpdata_version     =1,     //当前版本不在支持版本列表中，需要强制升级
    noTip_version           =2,     //当前版本在支持版本列表中，但不提示升级
    suggest_version         =3,     //当前版本在支持版本列表中，建议升级
    error_version           =4,     //未知错误【参数不对或数据格式不对】
};



/******************************************************
 公告状态
 ******************************************************/
typedef NS_ENUM(NSInteger, IapNoteState) {
    IapNoteExit = 0,       //提示公告,观看公告后退出应用
    IapNoteNotExit = 1,    //提示公告,观看公告后不退出应用
    IapNoteNormal = 2,     //不提示公告
    IapNoteError           //状态错误
};



#import <Foundation/Foundation.h>

#pragma mark ================  ==================

@interface SZSEConfigTool : NSObject
{
    NSDictionary *_appConfig;       // config字典
}

@property (nonatomic,strong)NSDictionary *appConfig;

@property (nonatomic,strong,readonly)NSMutableArray *upgradeDescribes;
@property (nonatomic,strong,readonly)NSString *packageSize;
@property (nonatomic,strong,readonly)NSString *updateTime;

+ (SZSEConfigTool*)shareVersionTool; //获取版本控制对象
/*
 获取当前版本号
 @ return 返回当前app版本号
 */
+(NSString*)getCurVersion;

/*
 用户点击开关设置
 flag: false表示不在提示 true：下次提醒
 */
+(void)setPopHintFlag:(BOOL)flag;

/*
 去App Store更新
 @return: 如果返回false，这appconfig中没IOS_appUpdataUrl字段
 */
-(BOOL)upDataVersion;

/*
 用户点击开关设置
 appconfigDictionary:appconfig字典
 @return: VersionState见定义
 */
- (VersionState)versionStateWith:(NSDictionary*)appconfigDictionary;


/*
 获取当前升级提示语
 @return: 如果是强制升级，则返回强制升级提示语【如果当前非提示状态，返回空字符串@“”】
 */
- (NSString*)getHintMsg;


@end
