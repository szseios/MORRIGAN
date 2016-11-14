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


// 添加到待上传数组
- (void)addToUploadArray:(RecordShouldUploadModel *)model;

// 添加数据库中未上传的数据，并进行上传
- (void)addDBDataAndUpload;


@end
