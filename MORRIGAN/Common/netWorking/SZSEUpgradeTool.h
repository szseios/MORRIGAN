//
//  SZSEUpgradeTool.h
//  SZSENetWroking
//
//  Created by snhuang on 15/11/16.
//  Copyright © 2015年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************************当前程序版本状态********************************/
typedef NS_ENUM(NSInteger, SZSEVersionState) {
    SZSELatestVersion           =0,     //最新版本
    SZSEForceUpdata             =1,     //当前版本不在支持版本列表中，需要强制升级
    SZSENoTip                   =2,     //当前版本在支持版本列表中，但不提示升级
    SZSESuggest                 =3,     //当前版本在支持版本列表中，建议升级
    SZSEVersionError            =4,     //未知错误【参数不对或数据格式不对】
};


/******************************************************
 公告状态
 ******************************************************/
typedef NS_ENUM(NSInteger, SZSENoteState) {
    SZSENoteExit = 0,       //提示公告,观看公告后退出应用
    SZSENoteNotExit = 1,    //提示公告,观看公告后不退出应用
    SZSENoteNormal = 2,     //不提示公告
    SZSENoteError           //状态错误
};

@interface SZSEUpgradeTool : NSObject


@property (nonatomic,copy)NSString *currentVersion;         //当前版本
@property (nonatomic,copy)NSString *latestVersion;          //最新版本
@property (nonatomic,copy)NSString *publishTime;            //发布时间
@property (nonatomic,copy)NSString *updateAddress;          //更新地址
@property (nonatomic,copy)NSString *applicationSize;        //应用大小

@property (nonatomic,strong)NSArray *updateDetails;         //升级描述

@property (nonatomic,assign)BOOL isHint;                    //建议升级时,是否提示用户

@property (nonatomic,assign)BOOL isDeleteDB;                //是否删除数据库



@property (nonatomic,assign)SZSENoteState noteState;        //通知的状态
@property (nonatomic,copy)NSString *noteMessage;            //通知提示

@property (nonatomic,assign)SZSEVersionState versionState;  //版本更新状态
@property (nonatomic,copy)NSString *updateTip;              //版本更新提示

@property (nonatomic,assign)BOOL  emailEnable;       //邮件是否可用（只要为NO，emailUser不管是否为空都不能进入邮件）
@property (nonatomic,copy)NSArray *emailUser;        //有邮件权限用户（emailEnable为YES时，emailUser为空面向所有用户，emailUser不为空则面向里面的用户开放）




+ (SZSEUpgradeTool *)share;

/*!
 *  配置版本更新属性 (SZSEUpgradeTool所有的属性)
 *
 *  @param versionDetails
 */
- (void)setupVersionDetails:(NSDictionary *)versionDetails;

- (void)setPopHintFlag:(BOOL)flag;


@end
