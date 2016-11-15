//
//  RecordUploadManager.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordManager : NSObject

+ (RecordManager *)share;

- (NSString *)getStarRank;

// 添加到待上传数组
- (void)addToUploadArray:(RecordShouldUploadModel *)model;

// 上传数据库中的数据(shouldCleanUp == YES : 用户退出或注销需要上传完成红清除数据)
- (void)uploadDBDatas:(BOOL)shouldCleanUp;


@end
