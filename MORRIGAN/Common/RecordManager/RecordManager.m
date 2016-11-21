//
//  RecordUploadManager.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RecordManager.h"
#import "DBManager.h"


static RecordManager *manager;

@interface RecordManager()
{
    NSArray *_recordBufferArray;         // 等待上传的数据
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



- (void)addToDB:(MassageRecordModel *)model
{
    if([DBManager insertData:model.userID startTime:model.startTime endTime:model.endTime type:model.type]) {
        NSLog(@"insertRecord，添加护理记录到数据库成功！");
    } else {
        NSLog(@"insertRecord，添加护理记录到数据库失败！");
    }
    
    
//    NSArray *result = [DBManager selectUploadDatas:model.userID];
//    NSLog(@"\n\n--------------现在数据库中需要上传的数据-------------： \n%@ \n---------------------end-------------------------", result);
    
    
    // 上传护理记录数据(每次停止都传一次，如果有数据，确保数据上传到服务器)
    [[RecordManager share] uploadDBDatas:NO];
}

- (void)uploadDBDatas:(BOOL)isUserExist
{
    
    if(isUserExist) {
        // 包括今天的数据（退出账户时）
        
        
    } else {
        // 今天之前的数据
        _recordBufferArray = [DBManager selectUploadDatas:[UserInfo share].userId];
    }
    
    NSLog(@"当前数据库中需要上传的护理记录天数: %ld", _recordBufferArray.count);
   
    [self uploadRecord:isUserExist];
}


- (void)cleanUpDBDatas
{
//    [DBManager removeAllDatas];
}


// 上传数据的格式
//http://112.74.100.227:8083/rest/moli/upload-record-list?userId=b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7&hlInfo=[{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-12","timeLong":"30"},{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-13","timeLong":"30"},{"userId":"b1e81e1a-f3c8-4ccb-bb3c-7317ee6c41b7","date":"2016-09-14","timeLong":"30"}]
- (void)uploadRecord:(BOOL)isUserExist
{
    if(_isUploading == YES) {
        NSLog(@"护理记录正在上传中...");
        return;
    }
    if(_recordBufferArray == nil || _recordBufferArray.count == 0) {
        NSLog(@"没有护理记录需上传！");
        if(isUserExist) {
            // 退出账户上传数据结束时发送通知去执行退出操作
            [[NSNotificationCenter defaultCenter]postNotificationName:kRecordManagerUploadEndNotification object:nil];
        }
        return;
    }
    __weak RecordManager *weakSelf = self;
    _isUploading = YES;
    
    // 把需要上传的数据放到上传的数组中,并将待上传数组清空
    _uploadingRecordArray = [NSArray arrayWithArray:_recordBufferArray];
    _recordBufferArray = nil;
    
    
    NSDictionary *dictionary = [NSDictionary dictionary];
    NSMutableString *infoString = [NSMutableString string];
    [infoString appendString:[NSString stringWithFormat:@"?userId=%@&hlInfo=[", [UserInfo share].userId]];
    NSLog(@"正在上传的护理记录数： %ld", _uploadingRecordArray.count);
    for (NSDictionary *itemDict in _uploadingRecordArray) {
        NSLog(@"正在上传的护理记录信息: userId -> %@, date -> %@，timeLong -> %@",
              [itemDict objectForKey:@"userId"],
              [itemDict objectForKey:@"date"],
              [itemDict objectForKey:@"timeLong"]
              );
        
        [infoString appendString:[NSString stringWithFormat:@"{\"userId\":\"%@\",\"date\":\"%@\",\"timeLong\":\"%@\"}",
                                  [itemDict objectForKey:@"userId"],
                                  [itemDict objectForKey:@"date"],
                                  [itemDict objectForKey:@"timeLong"]
                                  ]];
        if(itemDict != [_uploadingRecordArray lastObject]) {
            [infoString appendString:@","];
        } else {
            [infoString appendString:@"]"];
            dictionary = @{@"userId": [UserInfo share].userId};
        }
        
    }
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    NSString *resultBodyString = [NSString stringWithFormat:@"%@%@",bodyString, infoString];
    NSLog(@"infoString: %@", infoString);
   
    [[NMOANetWorking share] taskWithTag:ID_UPLOAD_RECORD
                              urlString:URL_UPLOAD_RECORD
                               httpHead:nil
                             bodyString:infoString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"上传护理记录成功！");
//             for (MassageRecordModel *model in _uploadingRecordArray) {
//                 if([DBManager deleteRecord:model.uuid]) {
//                     NSLog(@"deleteRecord， 删除记录成功！");
//                 } else {
//                     NSLog(@"deleteRecord， 删除记录失败！");
//                 }
//             }
             
         } else {
             NSLog(@"上传护理记录失败！");

         }
         
         _uploadingRecordArray = nil;
         _isUploading = NO;
         
         if(isUserExist) {
             // 清空数据
//             [_recordBufferArray removeAllObjects];
//             if([DBManager deleteAllRecord]) {
//                 NSLog(@"deleteAllRecord， 删除所有记录成功！");
//             } else {
//                 NSLog(@"deleteAllRecord， 删除所有记录失败！");
//             }
             
             // 退出账户上传数据结束时发送通知去执行退出操作
             [[NSNotificationCenter defaultCenter]postNotificationName:kRecordManagerUploadEndNotification object:nil];

         } else {
             // 继续上传缓冲中的数据
             [weakSelf uploadRecord:isUserExist];
         }
         
         
         
         
     }];
}

- (NSString *)getStarRank
{
    __block NSString *starStr;
    NSDictionary *dictionary = @{@"userId":[UserInfo share].userId?[UserInfo share].userId:@""};
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    
    [[NMOANetWorking share] taskWithTag:ID_GET_RANK
                              urlString:URL_GET_RANK
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"获取星级评定成功！");
             NSString *tempStr = [obj objectForKey:@"rank"];
             if (tempStr) {
                 starStr = tempStr;
             }
         } else {
             NSLog(@"获取星级评定失败！");
             starStr = @"";
         }
         
         
     }];
    return starStr;
}


@end
