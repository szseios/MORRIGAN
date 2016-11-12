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
        
        if (![DBManager createRecordShouldUploadTable:db]) {
            NSLog(@"createRecordShouldUploadTable error");
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

// --------------------------------------------护理记录------------------------------------
+ (BOOL)createRecordShouldUploadTable:(FMDatabase *)db {
    BOOL success = NO;
//    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'record_should_upload' ('uuid' TEXT PRIMARY KEY NOT NULL , 'userId' TEXT NOT NULL , 'date' TEXT NOT NULL, 'timeLong'  TEXT NOT NULL)";
//    success = [db executeUpdate:sql];
    return success;
}


+ (BOOL)insertRecord:(RecordShouldUploadModel *)model {
    
    __block BOOL success = NO;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'peripherals' ('uuid', 'name') VALUES ('%@', '%@')",
//                         peripheral.identifier.UUIDString,
//                         peripheral.name];
//        success = [db executeUpdate:sql];
//        
//    }];
    return success;
}


+ (BOOL)deleteRecord:(NSString *)uuid {
    __block BOOL success = NO;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"DELETE FROM 'peripherals' WHERE uuid = '%@'",uuid];
//        success = [db executeUpdate:sql];
//    }];
    return success;
}

+ (NSArray *)selectAllRecord
{
    __block NSMutableArray *array;
//    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals'"];
//        FMResultSet *result = [db executeQuery:sql];
//        while (result.next) {
//            if (!array) {
//                array = [[NSMutableArray alloc] init];
//            }
//            PeripheralModel *model = [[PeripheralModel alloc] init];
//            model.uuid = [result stringForColumn:@"uuid"];
//            model.name = [result stringForColumn:@"name"];
//            [array addObject:model];
//        }
//    }];
    return array;
}

+ (NSArray *)selectRecordByUserId:(NSString *)userId
{
    __block NSMutableArray *array;
    //    [[DBManager dbQueue] inDatabase:^(FMDatabase *db) {
    //        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'peripherals'"];
    //        FMResultSet *result = [db executeQuery:sql];
    //        while (result.next) {
    //            if (!array) {
    //                array = [[NSMutableArray alloc] init];
    //            }
    //            PeripheralModel *model = [[PeripheralModel alloc] init];
    //            model.uuid = [result stringForColumn:@"uuid"];
    //            model.name = [result stringForColumn:@"name"];
    //            [array addObject:model];
    //        }
    //    }];
    return array;
}

@end
