//
//  SZSEURLSessionDownloadTask.m
//  SZSENetWroking
//
//  Created by snhuang on 15/11/12.
//  Copyright © 2015年 Simon. All rights reserved.
//

#import "SZSEURLSessionDownloadTask.h"

@interface SZSEURLSessionDownloadTask () <NSURLSessionDownloadDelegate> {
    NSMutableURLRequest *_request;
    NSURLSessionDownloadTask *_downloadTask;
    SZSEURLSesstionTaskFinished _taskFinished;
    SZSEURLSessionDownloadProgress _taskProgress;
    NSData *_data;
}

@end

@implementation SZSEURLSessionDownloadTask

- (instancetype)initWithURL:(NSString *)urlString
                       body:(NSString *)bodyString
                   httpHead:(NSDictionary *)httpHead
                        Tag:(NSInteger)tag
               taskProgress:(SZSEURLSessionDownloadProgress)taskProgress
               taskFinished:(SZSEURLSesstionTaskFinished)taskFinished {
    
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.timeout = URLSessionTaskTimeout;
        self.tag = tag;
        self.httpHead = httpHead;
        self.bodyString = bodyString;
        self.state = SZSEURLSessionTaskNormal;
        _taskProgress = taskProgress;
        _taskFinished = taskFinished;
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        _request.HTTPMethod = SZSEHttpPostMethod;
        if (bodyString) {
            _request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return self;
}

- (void)resume {
    self.state = SZSEURLSessionTaskConnecting;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    _downloadTask = [session downloadTaskWithRequest:_request];
    [_downloadTask resume];
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 计算当前下载进度并更新视图
    _progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    _taskProgress(_progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (downloadTask.error) {
        self.state = SZSEURLSessionTaskFailed;
        if (downloadTask.error.code == -999) {
            self.state = SZSEURLSessionTaskNormal;
        }
    }else {
        self.state = SZSEURLSessionTaskSuccess;
    }
    _data = [[NSData alloc] initWithContentsOfURL:location];
    _taskFinished(self,downloadTask.error,_data);
}

- (void)cancel {
    [_downloadTask cancel];
}

@end










