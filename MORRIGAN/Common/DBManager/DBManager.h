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
#import "RecordShouldUploadModel.h"

@interface DBManager : NSObject

+ (FMDatabaseQueue *)dbQueue;

+ (BOOL)initApplicationsDB;

+ (BOOL)insertPeripheral:(CBPeripheral *)peripheral;

+ (BOOL)deletePeripheral:(NSString *)uuid;

+ (BOOL)updatePeripheralName:(PeripheralModel *)model ;

+ (NSArray *)selectPeripherals;

+ (NSDictionary *)selectLinkedPeripherals;

+ (BOOL)insertData:(NSString *)userID startTime:(NSDate *)start endTime:(NSDate *)end type:(MassageType)type;

+ (NSArray *)selectForenoonDatas:(NSString *)userID;

+ (NSArray *)selectaAfternoonDatas:(NSString *)userID;


//// --------------------------------------------护理记录------------------------------------
//+ (BOOL)insertRecord:(RecordShouldUploadModel *)model;
//
//+ (BOOL)deleteRecord:(NSString *)uuid;
//
//+ (BOOL)deleteAllRecord;
//
//+ (NSArray *)selectAllRecord;
//
//+ (NSArray *)selectRecordByUserId:(NSString *)userId;

@end
