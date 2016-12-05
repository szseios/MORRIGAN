//
//  RecordUploadManager.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRecordManagerUploadEndNotification  @"kRecordManagerUploadEndNotification"

#define GETSTARRANKNOTIFICATION  @"GETSTARRANKNOTIFICATION"

@interface RecordManager : NSObject

+ (RecordManager *)share;

- (void)getStarRank;




// 添加到待上传数组
- (void)addToDB:(MassageRecordModel *)model;

// 上传数据库中的数据(isUserExist == YES : 用户退出需要上传包括今天的数据并清除数据库， isUserExist == NO : 上传今天之前的数据)
- (void)uploadDBDatas:(BOOL)isUserExist;

// 清除数据库（用户注销时）
- (void)cleanUpDBDatas;

@end
