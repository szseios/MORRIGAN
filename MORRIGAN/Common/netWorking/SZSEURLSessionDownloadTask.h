//
//  SZSEURLSessionDownloadTask.h
//  SZSENetWroking
//
//  Created by snhuang on 15/11/12.
//  Copyright © 2015年 Simon. All rights reserved.
//

#import "SZSEURLSessionTask.h"

@interface SZSEURLSessionDownloadTask : SZSEURLSessionTask

typedef void(^SZSEURLSessionDownloadProgress)(CGFloat progress);

@property (nonatomic,assign)CGFloat progress; //0.0....1.0

- (instancetype)initWithURL:(NSString *)urlString
                       body:(NSString *)bodyString
                   httpHead:(NSDictionary *)httpHead
                        Tag:(NSInteger)tag
               taskProgress:(SZSEURLSessionDownloadProgress)taskProgress
               taskFinished:(SZSEURLSesstionTaskFinished)taskFinished;

- (instancetype)initWithURL:(NSString *)urlString
                       body:(NSString *)bodyString
                   httpHead:(NSDictionary *)httpHead
                 httpMethod:(NSString *)httpMethod
                        Tag:(NSInteger)tag
               taskProgress:(SZSEURLSessionDownloadProgress)taskProgress
               taskFinished:(SZSEURLSesstionTaskFinished)taskFinished;

- (void)resume;

@end
