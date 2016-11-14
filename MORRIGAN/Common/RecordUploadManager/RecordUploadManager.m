//
//  RecordUploadManager.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RecordUploadManager.h"
#import "RecordShouldUploadModel.h"


static RecordUploadManager *manager;

@interface RecordUploadManager()
{
    NSMutableArray *_recordBufferArray;  // 等待上传的数据
    NSArray *_uploadingRecordArray;      // 正在上传的数据
    BOOL _isUploading;                   // 是否正在上传
}

@end



@implementation RecordUploadManager

+ (RecordUploadManager *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RecordUploadManager alloc] init];
        
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
    [self.recordBufferArray addObject:model];
    [self addDBDataAndUpload];
}

- (void)addDBDataAndUpload
{
    // 添加数据库中未上传的数据
    
    
    
    [self uploadRecord];
}




- (void)uploadRecord
{
    if(_isUploading == YES || self.recordBufferArray == nil || self.recordBufferArray.count == 0) {
        return;
    }
    __weak RecordUploadManager *weakSelf = self;
    _isUploading = YES;
    
    // 把需要上传的数据放到上传的数组中,并将待上传数组清空
    _uploadingRecordArray = [NSArray arrayWithArray:self.recordBufferArray];
    [self.recordBufferArray removeAllObjects];
    
    
    NSDictionary *dictionary = [NSDictionary dictionary];
    for (RecordShouldUploadModel *model  in _uploadingRecordArray) {
        NSLog(@"剩余需要上传的护理记录数量: %ld，开始上传: %@, %@, %@, %@", self.recordBufferArray.count, model.uuid, model.userId, model.dateString, model.timeLongString);
       
        NSDictionary *dict = @{@"userId": model.userId,
                               @"date": model.dateString,
                               @"timeLong": model.timeLongString };
    }
    

    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_UPLOAD_RECORD
                              urlString:URL_UPLOAD_RECORD
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"上传护理记录成功！");
             
            
             
         } else {
             NSLog(@"上传护理记录失败！");
             // 将失败的数据保存数据库，下次有数据需要上传时继续上传
             
             
             
         }
         _uploadingRecordArray = nil;
         _isUploading = NO;
         
         // 继续上传缓冲中的数据
         [weakSelf uploadRecord];
         
     }];
}


@end
