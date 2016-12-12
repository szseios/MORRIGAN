//
//  DBManager.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

#define DefaultDBName @"Morrigan.sqlite"

static FMDatabaseQueue *dbQueue = nil;
static NSString *dbPath = nil;

+ (FMDatabaseQueue *)dbQueue {
    return dbQueue;
}


+ (BOOL)initApplicationsDB {
    
    if (dbPath) {
        dbPath = nil;
    }
    dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dbPath = [dbPath stringByAppendingString:[NSString stringWithFormat:@"/%@",DefaultDBName]];
    NSLog(@"dbPath: %@", dbPath);
    
    if (dbQueue) {
        [dbQueue close];
        dbQueue = nil;
    }
    dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    
    __block BOOL success = NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![DBManager createPeripheralsTable:db]) {
            NSLog(@"createPeripheralsTable error");
            return;
        }
        
        if (![DBManager createDatasTable:db]) {
            NSLog(@"createDatasTable error");
            return;
        }
        
        if (![DBManager createTargetsTable:db]) {
            NSLog(@"createTargetsTable error");
            return;
        }
        success = YES;
    }];
    return success;
    
}


+ (BOOL)createPeripheralsTable:(FMDatabase *)db {
    BOOL success = NO;
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'peripherals' ('mac' TEXT PRIMARY KEY NOT NULL , 'name' TEXT NOT NULL , 'user_id' TEXT NOT NULL)";
    success = [db executeUpdate:sql];
    return success;
}


+ (BOOL)createDatasTable:(FMDatabase *)db {
    BOOL success = NO;
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'datas' ('user_id' TEXT , 'start_time' DATE ,'end_time' DATE , 'type' INTEGER)";
    success = [db executeUpdate:sql];
    return success;
}

+ (BOOL)createTargetsTable:(FMDatabase *)db {
    BOOL success = NO;
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'targets' ('user_id' TEXT PRIMARY KEY , 'target' TEXT ,'isUpload' INTEGER)";
    success = [db executeUpdate:sql];
    return success;
}

#pragma mark - 设备

+ (BOOL)insertPeripherals:(NSArray *)peripherals {
    __block BOOL success = NO;
    [[DBManager dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (PeripheralModel *model in peripherals) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'peripherals' ('mac','name' ,'user_id') VALUES ('%@','%@', '%@')",
                             model.macAddress,
                             model.name,
                             model.userID];
            success = [db executeUpdate:sql];
            if (!success) {
                *rollback = YES;
                break;
            }
        }
    }];
    return success;
}

+ (BOOL)insertPeripheral:(CBPeripheral *)peripheral macAddress:(NSString *)macAddress {
    
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'peripherals' ('mac','name' ,'user_id') VALUES ('%@', '%@', '%@')",
                         macAddress,
                         peripheral.name,
                         [UserInfo share].userId?[UserInfo share].userId:@""];
        success = [db executeUpdate:sql];
        
    }];
    return success;
}

+ (BOOL)updatePeripheralName:(PeripheralModel *)model {
    
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'peripherals' SET name = '%@' WHERE mac = '%@'",
                         model.name,
                         model.macAddress];
        success = [db executeUpdate:sql];
    }];
    return success;
}


+ (BOOL)deletePeripheral:(NSString *)macAddress {
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'peripherals' WHERE mac = '%@'",macAddress];
        success = [db executeUpdate:sql];
    }];
    return success;
}

+ (NSArray *)selectPeripherals {
    __block NSMutableArray *array;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals' WHERE user_id = '%@'",[UserInfo share].userId];
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!array) {
                array = [[NSMutableArray alloc] init];
            }
            PeripheralModel *model = [[PeripheralModel alloc] init];
            model.macAddress = [result stringForColumn:@"mac"];
            model.name = [result stringForColumn:@"name"];
            [array addObject:model];
        }
    }];
    return array;
}

+ (NSDictionary *)selectLinkedPeripherals {
    __block NSMutableDictionary *dictionary;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals' WHERE user_id = '%@'",[UserInfo share].userId];
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!dictionary) {
                dictionary = [[NSMutableDictionary alloc] init];
            }
            PeripheralModel *model = [[PeripheralModel alloc] init];
            model.macAddress = [result stringForColumn:@"mac"];
            model.name = [result stringForColumn:@"name"];
            [dictionary setObject:model forKey:model.macAddress];
        }
    }];
    return dictionary;
}

#pragma mark - 数据

+ (NSArray *)selectAllUploadDatas:(NSString *)userID {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where user_id = '%@' order by end_time asc",userID];
        
        FMResultSet *result = [db executeQuery:sql];
        
        NSDate *date;
        NSTimeInterval timeLong = 0.0;
        
        while (result.next) {
            if (!datas) {
                datas = [[NSMutableArray alloc] init];
            }
            NSDate *startTime = [result dateForColumn:@"start_time"];
            NSDate *endTime = [result dateForColumn:@"end_time"];
            NSTimeInterval interval = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970;
            
            if (![Utils isSameDay:date date2:endTime]) {
                //如果不是第一条记录
                if (date) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    NSDictionary *dictionary = @{@"userId":userID,
                                                 @"date":dateString,
                                                 @"timeLong":@((NSInteger)(timeLong / 60))};
                    [datas addObject:dictionary];
                }
                date = endTime;
                timeLong = 0.0;
            }
            
            timeLong += interval;
        }
        //如果有记录,添加最后一条记录
        if (date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date];
            NSDictionary *dictionary = @{@"userId":userID,
                                         @"date":dateString,
                                         @"timeLong":@((NSInteger)(timeLong / 60))};
            [datas addObject:dictionary];
        }
        
    }];
    return datas;
}

+ (NSArray *)selectUploadDatas:(NSString *)userID {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *endDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00 +0800",
                             todayComponents.year,
                             todayComponents.month,
                             todayComponents.day];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where end_time < '%@' and user_id = '%@' order by end_time asc",endDate,userID];
        
        FMResultSet *result = [db executeQuery:sql];
        
        NSDate *date;
        NSTimeInterval timeLong = 0.0;
        
        while (result.next) {
            if (!datas) {
                datas = [[NSMutableArray alloc] init];
            }
            NSDate *startTime = [result dateForColumn:@"start_time"];
            NSDate *endTime = [result dateForColumn:@"end_time"];
            NSTimeInterval interval = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970;
            
            if (![Utils isSameDay:date date2:endTime]) {
                //如果不是第一条记录
                if (date) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString = [formatter stringFromDate:date];
                    NSDictionary *dictionary = @{@"userId":userID,
                                                 @"date":dateString,
                                                 @"timeLong":@((NSInteger)(timeLong / 60))};
                    [datas addObject:dictionary];
                }
                date = endTime;
                timeLong = 0.0;
            }
            
            timeLong += interval;
        }
        //如果有记录,添加最后一条记录
        if (date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date];
            NSDictionary *dictionary = @{@"userId":userID,
                                         @"date":dateString,
                                         @"timeLong":@((NSInteger)(timeLong / 60))};
            [datas addObject:dictionary];
        }
        
    }];
    return datas;
}

+ (NSArray *)selectTodayDatas:(NSString *)userID {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *startDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00 +0800",
                               todayComponents.year,
                               todayComponents.month,
                               todayComponents.day];
        NSString *endDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 23:59:59 +0800",
                             todayComponents.year,
                             todayComponents.month,
                             todayComponents.day];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where (end_time >= '%@' or  end_time <= '%@') and user_id = '%@'",startDate,endDate,userID];
        
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!datas) {
                datas = [[NSMutableArray alloc] init];
            }
            MassageRecordModel *model = [[MassageRecordModel alloc] init];
            model.userID = [result stringForColumn:@"user_id"];
            model.startTime = [result dateForColumn:@"start_time"];
            model.endTime = [result dateForColumn:@"end_time"];
            model.type = [result intForColumn:@"type"];
            [datas addObject:model];
        }
        
    }];
    return datas;
}

+ (NSArray *)selectForenoonDatas:(NSString *)userID {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *startDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00 +0800",
                               todayComponents.year,
                               todayComponents.month,
                               todayComponents.day];
        NSString *endDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 11:59:59 +0800",
                             todayComponents.year,
                             todayComponents.month,
                             todayComponents.day];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where start_time >= '%@' and  end_time <= '%@' and user_id = '%@' order by end_time asc",startDate,endDate,userID];
        
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!datas) {
                datas = [[NSMutableArray alloc] init];
            }
            MassageRecordModel *model = [[MassageRecordModel alloc] init];
            model.userID = [result stringForColumn:@"user_id"];
            model.startTime = [result dateForColumn:@"start_time"];
            model.endTime = [result dateForColumn:@"end_time"];
            model.type = [result intForColumn:@"type"];
            [datas addObject:model];
        }
        
    }];
    return datas;
}

+ (NSArray *)selectaAfternoonDatas:(NSString *)userID  {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *startDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 12:00:00 +0800",
                               todayComponents.year,
                               todayComponents.month,
                               todayComponents.day];
        NSString *endDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld 23:59:59 +0800",
                             todayComponents.year,
                             todayComponents.month,
                             todayComponents.day];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where start_time >= '%@' and  end_time <= '%@' and user_id = '%@' order by end_time asc",startDate,endDate,userID];
        
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!datas) {
                datas = [[NSMutableArray alloc] init];
            }
            MassageRecordModel *model = [[MassageRecordModel alloc] init];
            model.userID = [result stringForColumn:@"user_id"];
            model.startTime = [result dateForColumn:@"start_time"];
            model.endTime = [result dateForColumn:@"end_time"];
            model.type = [result intForColumn:@"type"];
            [datas addObject:model];
        }
        
    }];
    return datas;
}


+ (BOOL)insertData:(NSString *)userID startTime:(NSDate *)start endTime:(NSDate *)end type:(MassageType)type {
    
    NSLog(@"按摩时间:%f", end.timeIntervalSince1970 - start.timeIntervalSince1970);
    if (end.timeIntervalSince1970 - start.timeIntervalSince1970 < 60) {
        NSLog(@"按摩时间不超过1分钟,不保存数据");
        return NO;
    }
    
    __block BOOL success = NO;
    [[DBManager dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSDate *tempstartDate = start;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        [db setDateFormat:formatter];
        
        while (![Utils isSameHour:end date2:tempstartDate]) {
            NSDateComponents *tempComponents = [cal components:NSYearCalendarUnit|
                                                NSMonthCalendarUnit|
                                                NSDayCalendarUnit|
                                                NSHourCalendarUnit
                                                      fromDate:tempstartDate];
            tempComponents.minute = 59;
            tempComponents.second = 59;
            NSDate *tempEndDate = [cal dateFromComponents:tempComponents];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'datas' ('user_id', 'start_time' , 'end_time' , 'type') VALUES ('%@', '%@', '%@', '%@')",
                             userID,
                             [formatter stringFromDate:tempstartDate],
                             [formatter stringFromDate:tempEndDate],
                             @(type).stringValue];
            success = [db executeUpdate:sql];
            
            if (success) {
                tempComponents.hour += 1;
                tempComponents.minute = 0;
                tempComponents.second = 0;
                tempstartDate = [cal dateFromComponents:tempComponents];
            }
            else {
                NSLog(@"按摩记录保存失败, error : %@",db.lastErrorMessage);
                break;
            }
        }
        
        //        if (success) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'datas' ('user_id', 'start_time' , 'end_time' , 'type') VALUES ('%@', '%@', '%@', '%@')",
                         userID,
                         [formatter stringFromDate:tempstartDate],
                         [formatter stringFromDate:end],
                         @(type).stringValue];
        success = [db executeUpdate:sql];
        if (!success) {
            NSLog(@"按摩记录保存失败, error : %@",db.lastErrorMessage);
        }
        //        }
        
        
    }];
    if (success) {
        //保存成功发通知给界面刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MORRIGANTIMECHANGENOTIFICATION object:nil];
        });
    }
    return success;
}

+ (BOOL)deleteAllDatas {
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'datas'"];
        success = [db executeUpdate:sql];
    }];
    return success;
}

+ (BOOL)deleteHistoryDatas {
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *date = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00 +0800",
                          todayComponents.year,
                          todayComponents.month,
                          todayComponents.day];
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'datas' where end_time < '%@'",date];
        success = [db executeUpdate:sql];
    }];
    return success;
}

#pragma mark - 保存目标相关

+ (BOOL)insertTarget:(TargetModel *)model
{
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'targets' ('user_id','target' ,'isUpload') VALUES ('%@', '%@', '%@')",
                         [UserInfo share].userId?[UserInfo share].userId:@"",
                         model.target,
                         @(model.isUpload).stringValue
                         ];
        success = [db executeUpdate:sql];
        
    }];
    return success;
}

+ (TargetModel *)selectTargetWithUserID:(NSString *)userID
{
    __block TargetModel *model;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'targets' WHERE user_id = '%@'",[UserInfo share].userId];
    FMResultSet *result = [db executeQuery:sql];
    while (result.next) {
        model = [[TargetModel alloc] init];
        model.target = [result stringForColumn:@"target"];
        model.isUpload = [result intForColumn:@"name"];
    }
}];
    return model;
    
}

+ (BOOL)updateTarget:(TargetModel *)model
{
    
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'targets' SET target = '%@' , isUpload = '%@' WHERE user_id = '%@'",
                         model.target,
                         @(model.isUpload).stringValue,
                         [UserInfo share].userId?[UserInfo share].userId:@""];
        success = [db executeUpdate:sql];
    }];
    return success;
}



@end
