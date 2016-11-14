//
//  RecordUploadManager.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RecordManager.h"
#import "RecordShouldUploadModel.h"
#import "DBManager.h"


static RecordManager *manager;

@interface RecordManager()
{
    NSMutableArray *_recordBufferArray;  // 等待上传的数据
    NSArray *_uploadingRecordArray;      // 正在上传的数据
    BOOL _isUploading;                   // 是否正在上传
}

@end



@implementation RecordManager

+ (RecordManager *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RecordManager alloc] init];
        
    });
    return manager;
}

- (NSMutableArray *)recordBufferArray {
    if(_recordBufferArray == nil) {
        _recordBufferArray = [NSMutableArray array];
    }
    return _recordBufferArray;
}




- (void)addToUploadArray:(RecordShouldUploadModel *)model
{
    if([DBManager insertRecord:model]) {
        NSLog(@"insertRecord，添加到数据库成功！");
    } else {
        NSLog(@"insertRecord，添加到数据库失败！");
    }
    [self uploadDBDatas:NO];
}

- (void)uploadDBDatas:(BOOL)shouldCleanUp
{
    // 添加数据库中未上传的数据
    [self.recordBufferArray addObjectsFromArray:[DBManager selectAllRecord]];
//    for (NSInteger i = 0; i < 3; i++) {
//        RecordShouldUploadModel *model = [[RecordShouldUploadModel alloc] init];
//        model.uuid = @"sdddddd";
//        model.userId = @"1";
//        model.dateString = @"2016-10-20";
//        model.timeLongString = @"1:10";
//        [self.recordBufferArray addObject:model];
//    }
    
    NSLog(@"当前数据库中的记录数: %ld", self.recordBufferArray.count);
    [self uploadRecord:shouldCleanUp];
}



//http://112.74.100.227:8083/rest/moli/upload-record-list?userId=b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7&hlInfo=[{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-12","timeLong":"30"},{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-13","timeLong":"30"},{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-14","timeLong":"30"}]

- (void)uploadRecord:(BOOL)shouldCleanUp
{
    if(_isUploading == YES || self.recordBufferArray == nil || self.recordBufferArray.count == 0) {
        return;
    }
    __weak RecordManager *weakSelf = self;
    _isUploading = YES;
    
    // 把需要上传的数据放到上传的数组中,并将待上传数组清空
    _uploadingRecordArray = [NSArray arrayWithArray:self.recordBufferArray];
    [self.recordBufferArray removeAllObjects];
    
    
    NSDictionary *dictionary = [NSDictionary dictionary];
    NSMutableString *infoString = [NSMutableString string];
    [infoString appendString:@"&hlInfo=["];
    for (RecordShouldUploadModel *model  in _uploadingRecordArray) {
        NSLog(@"剩余需要上传的护理记录数量: %ld，开始上传: %@, %@, %@, %@", _uploadingRecordArray.count, model.uuid, model.userId, model.dateString, model.timeLongString);
        [infoString appendString:[NSString stringWithFormat:@"{\"userId\":\"%@\",\"date\":\"%@\",\"timeLong\":\"%@\"}",model.userId, model.dateString, model.timeLongString]];
        if(model != [_uploadingRecordArray lastObject]) {
            [infoString appendString:@","];
        } else {
            [infoString appendString:@"]"];
            dictionary = @{@"userId": model.userId};
        }
        
    }
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    NSString *resultBodyString = [NSString stringWithFormat:@"%@%@",bodyString, infoString];
    NSLog(@"resultBodyString: %@", resultBodyString);
   
    [[NMOANetWorking share] taskWithTag:ID_UPLOAD_RECORD
                              urlString:URL_UPLOAD_RECORD
                               httpHead:nil
                             bodyString:resultBodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"上传护理记录成功！");
             for (RecordShouldUploadModel *model in _uploadingRecordArray) {
                 if([DBManager deleteRecord:model.uuid]) {
                     NSLog(@"deleteRecord， 删除记录成功！");
                 } else {
                     NSLog(@"deleteRecord， 删除记录失败！");
                 }
             }
             
         } else {
             NSLog(@"上传护理记录失败！");

         }
         _uploadingRecordArray = nil;
         _isUploading = NO;
         
         if(shouldCleanUp) {
             // 清空数据
             [_recordBufferArray removeAllObjects];
             if([DBManager deleteAllRecord]) {
                 NSLog(@"deleteAllRecord， 删除所有记录成功！");
             } else {
                 NSLog(@"deleteAllRecord， 删除所有记录失败！");
             }

         } else {
             // 继续上传缓冲中的数据
             [weakSelf uploadRecord:shouldCleanUp];
         }
         
         
         
         
     }];
}


@end
