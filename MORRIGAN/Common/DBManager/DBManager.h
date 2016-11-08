//
//  DBManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeripheralModel.h"
#import "FMDB.h"

@interface DBManager : NSObject

+ (FMDatabaseQueue *)dbQueue;

+ (BOOL)initApplicationsDB;

+ (BOOL)insertPeripheral:(CBPeripheral *)peripheral;

+ (BOOL)deletePeripheral:(NSString *)uuid;

+ (BOOL)updatePeripheralName:(PeripheralModel *)model ;

+ (NSArray *)selectPeripherals;

+ (NSDictionary *)selectLinkedPeripherals;

@end
