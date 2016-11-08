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


@end
