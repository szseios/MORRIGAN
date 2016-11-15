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
        
        success = YES;
    }];
    return success;
    
}


+ (BOOL)createPeripheralsTable:(FMDatabase *)db {
    BOOL success = NO;
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'peripherals' ('uuid' TEXT PRIMARY KEY NOT NULL , 'name' TEXT NOT NULL)";
    success = [db executeUpdate:sql];
    return success;
}


+ (BOOL)createDatasTable:(FMDatabase *)db {
    BOOL success = NO;
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'datas' ('user_id' TEXT , 'start_time' DATE ,'end_time' DATE , 'type' INTEGER)";
    success = [db executeUpdate:sql];
    return success;
}


#pragma mark - 设备


+ (BOOL)insertPeripheral:(CBPeripheral *)peripheral {

    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'peripherals' ('uuid', 'name') VALUES ('%@', '%@')",
                         peripheral.identifier.UUIDString,
                         peripheral.name];
        success = [db executeUpdate:sql];
        
    }];
    return success;
}

+ (BOOL)updatePeripheralName:(PeripheralModel *)model {
    
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'peripherals' SET name = '%@' WHERE uuid = '%@'",
                         model.name,
                         model.uuid];
        success = [db executeUpdate:sql];
    }];
    return success;
}


+ (BOOL)deletePeripheral:(NSString *)uuid {
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'peripherals' WHERE uuid = '%@'",uuid];
        success = [db executeUpdate:sql];
    }];
    return success;
}

+ (NSArray *)selectPeripherals {
    __block NSMutableArray *array;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals'"];
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!array) {
                array = [[NSMutableArray alloc] init];
            }
            PeripheralModel *model = [[PeripheralModel alloc] init];
            model.uuid = [result stringForColumn:@"uuid"];
            model.name = [result stringForColumn:@"name"];
            [array addObject:model];
        }
    }];
    return array;
}

+ (NSDictionary *)selectLinkedPeripherals {
    __block NSMutableDictionary *dictionary;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals'"];
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            if (!dictionary) {
                dictionary = [[NSMutableDictionary alloc] init];
            }
            PeripheralModel *model = [[PeripheralModel alloc] init];
            model.uuid = [result stringForColumn:@"uuid"];
            model.name = [result stringForColumn:@"name"];
            [dictionary setObject:model forKey:model.uuid];
        }
    }];
    return dictionary;
}

#pragma mark - 数据

+ (NSArray *)selectForenoonDatas:(NSString *)userID {
    __block NSMutableArray *datas;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *startDate = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00 +0000",
                               @(todayComponents.year).stringValue,
                               @(todayComponents.month).stringValue,
                               @(todayComponents.day).stringValue];
        NSString *endDate = [NSString stringWithFormat:@"%@-%@-%@ 11:59:59 +0000",
                             @(todayComponents.year).stringValue,
                             @(todayComponents.month).stringValue,
                             @(todayComponents.day).stringValue];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where start_time >= '%@' and  end_time <= '%@' and user_id = '%@'",startDate,endDate,userID];
        
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
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        
        NSString *startDate = [NSString stringWithFormat:@"%@-%@-%@ 12:00:00 +0000",
                               @(todayComponents.year).stringValue,
                               @(todayComponents.month).stringValue,
                               @(todayComponents.day).stringValue];
        NSString *endDate = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59 +0000",
                             @(todayComponents.year).stringValue,
                             @(todayComponents.month).stringValue,
                             @(todayComponents.day).stringValue];
        
        NSString *sql = [NSString stringWithFormat:@"select * from datas where start_time >= '%@' and  end_time <= '%@' and user_id = '%@'",startDate,endDate,userID];
        
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
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        
        NSDate *tempstartDate = start;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        while (end.timeIntervalSince1970 - tempstartDate.timeIntervalSince1970 > (60 * 60)) {
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
                             tempstartDate,
                             tempEndDate,
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
        
        if (success) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'datas' ('user_id', 'start_time' , 'end_time' , 'type') VALUES ('%@', '%@', '%@', '%@')",
                             userID,
                             tempstartDate,
                             end,
                             @(type).stringValue];
            success = [db executeUpdate:sql];
            if (!success) {
                NSLog(@"按摩记录保存失败, error : %@",db.lastErrorMessage);
            }
        }
        
        
    }];
    return success;
}

+ (BOOL)deleteData {
    __block BOOL success = NO;
    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'datas'"];
        success = [db executeUpdate:sql];
    }];
    return success;
}




// --------------------------------------------护理记录------------------------------------


//+ (BOOL)createRecordShouldUploadTable:(FMDatabase *)db {
//    BOOL success = NO;
//    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'record_should_upload' ('uuid' TEXT PRIMARY KEY NOT NULL , 'userId' TEXT NOT NULL , 'date' TEXT NOT NULL, 'timeLong'  TEXT NOT NULL)";
//    success = [db executeUpdate:sql];
//    return success;
//}
//
//
//+ (BOOL)insertRecord:(RecordShouldUploadModel *)model {
//    
//    __block BOOL success = NO;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'record_should_upload' ('uuid', 'userId', 'date', 'timeLong') VALUES ('%@', '%@','%@', '%@')",
//                         model.uuid,
//                         model.userId,
//                         model.dateString,
//                         model.timeLongString];
//        success = [db executeUpdate:sql];
//        
//    }];
//    return success;
//}
//
//
//+ (BOOL)deleteRecord:(NSString *)uuid {
//    __block BOOL success = NO;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'record_should_upload' WHERE uuid = '%@'",uuid];
//        success = [db executeUpdate:sql];
//    }];
//    return success;
//}
//
//+ (BOOL)deleteAllRecord
//{
//    __block BOOL success = NO;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'record_should_upload'"];
//        success = [db executeUpdate:sql];
//    }];
//    return success;
//}
//
//+ (NSArray *)selectAllRecord
//{
//    __block NSMutableArray *array;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'record_should_upload'"];
//        FMResultSet *result = [db executeQuery:sql];
//        while (result.next) {
//            if (!array) {
//                array = [[NSMutableArray alloc] init];
//            }
//            RecordShouldUploadModel *model = [[RecordShouldUploadModel alloc] init];
//            model.uuid = [result stringForColumn:@"uuid"];
//            model.userId = [result stringForColumn:@"userId"];
//            model.dateString = [result stringForColumn:@"date"];
//            model.timeLongString = [result stringForColumn:@"timeLong"];
//            [array addObject:model];
//        }
//    }];
//    return array;
//}
//
//+ (NSArray *)selectRecordByUserId:(NSString *)userId
//{
//    __block NSMutableArray *array;
//        [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'record_should_upload' WHERE userId = '%@'",userId];
//            FMResultSet *result = [db executeQuery:sql];
//            while (result.next) {
//                if (!array) {
//                    array = [[NSMutableArray alloc] init];
//                }
//                RecordShouldUploadModel *model = [[RecordShouldUploadModel alloc] init];
//                model.uuid = [result stringForColumn:@"uuid"];
//                model.userId = [result stringForColumn:@"userId"];
//                model.dateString = [result stringForColumn:@"date"];
//                model.timeLongString = [result stringForColumn:@"timeLong"];
//                [array addObject:model];
//            }
//        }];
//    return array;
//}

@end
