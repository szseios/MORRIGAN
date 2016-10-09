//
//  SZSEURLSessionTask.h
//  SZSENetWroking
//
//  Created by snhuang on 15/9/29.
//  Copyright © 2015年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SZSEHttpGetMethod;
extern NSString * const SZSEHttpPostMethod;

#define URLSessionTaskTimeout 30

typedef NS_ENUM(NSInteger,SZSEURLSesstionTaskState) {
    SZSEURLSessionTaskNormal = 0,   //默认状态
    SZSEURLSessionTaskConnecting,   //网络请求连接中
    SZSEURLSessionTaskSuccess,      //网络请求成功
    SZSEURLSessionTaskFailed,       //网络请求失败
    SZSEURLSessionTaskTimeout       //网络请求超时
};

@interface SZSEURLSessionTask : NSObject


typedef void(^SZSEURLSesstionTaskFinished)(SZSEURLSessionTask *task,NSError *error,NSData *data);


@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) NSDictionary *httpHead;          //请求的http头信息
@property (nonatomic,strong) NSString *bodyString;            //发送的参数

@property (nonatomic,assign) NSInteger timeout;               //请求超时时间
@property (nonatomic,assign) SZSEURLSesstionTaskState state;  //网络请求状态


/**
 *  初始化 SessionTask (默认使用post请求)
 *
 *  @param urlString
 *  @param bodyString http body
 *  @param httpHead   http请求头
 *  @param tag
 *  @param timeout    网络请求超时时间
 *
 *  @return
 */
- (instancetype)initWithURL:(NSString *)urlString
                       body:(NSString *)bodyString
                   httpHead:(NSDictionary *)httpHead
                        Tag:(NSInteger)tag
                    timeout:(NSInteger)timeout
               taskFinished:(SZSEURLSesstionTaskFinished)taskFinished;

/**
 *  初始化 SessionTask
 *
 *  @param urlString
 *  @param httpMethod
 *  @param bodyString
 *  @param httpHead
 *  @param tag
 *  @param timeout      网络请求超时时间
 *
 *  @return
 */
- (instancetype)initWithURL:(NSString *)urlString
                 httpMethod:(NSString *)httpMethod
                       body:(NSString *)bodyString
                   httpHead:(NSDictionary *)httpHead
                        Tag:(NSInteger)tag
                    timeout:(NSInteger)timeout
               taskFinished:(SZSEURLSesstionTaskFinished)taskFinished;

- (void)resume;

- (void)cancel;

@end
