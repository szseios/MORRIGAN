//
//  DBManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralModel.h"
#import "MassageRecordModel.h"
#import "FMDB.h"

@interface DBManager : NSObject

+ (FMDatabaseQueue *)dbQueue;

+ (BOOL)initApplicationsDB;

+ (BOOL)insertPeripherals:(NSArray *)peripherals;

+ (BOOL)insertPeripheral:(CBPeripheral *)peripheral
              macAddress:(NSString *)macAddress;

+ (BOOL)deletePeripheral:(NSString *)uuid;

+ (BOOL)updatePeripheralName:(PeripheralModel *)model ;

+ (NSArray *)selectPeripherals;

+ (NSDictionary *)selectLinkedPeripherals;

+ (BOOL)insertData:(NSString *)userID startTime:(NSDate *)start endTime:(NSDate *)end type:(MassageType)type;

+ (NSArray *)selectTodayDatas:(NSString *)userID;

+ (NSArray *)selectForenoonDatas:(NSString *)userID;

+ (NSArray *)selectaAfternoonDatas:(NSString *)userID;

//获取当前用户所有历史记录
+ (NSArray *)selectAllUploadDatas:(NSString *)userID;

//获取当前用户今天之前的所有历史记录
+ (NSArray *)selectUploadDatas:(NSString *)userID;

//删除所有数据
+ (BOOL)deleteAllDatas;

//删除今天之前的历史数据
+ (BOOL)deleteHistoryDatas;


@end
