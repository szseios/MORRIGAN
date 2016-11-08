//
//  DBManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject

/*!
 *  获取数据库队列
 *
 *  @return
 */
+ (FMDatabaseQueue *)dbQueue;

/*!
 *  创建相关DB
 *
 *  @return 成功或失败
 */
+ (BOOL)initApplicationsDB;

/*!
 *  删除相关DB文件
 *
 *  @return 成功或失败
 */
+ (BOOL)deleteApplicationsDB;

@end
