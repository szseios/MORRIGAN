//
//  NMOANetWorking.h
//  NMOA
//
//  Created by snhuang on 15/9/29.
//  Copyright © 2015年 snhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URLSessionTaskTimeout 30    //网络请求超时时间

typedef void(^NMOANetWorkingDataTaskFinished)(NSError *error,NSData *data);
typedef void(^NMOANetWorkingObjectTaskFinished)(NSError *error,id obj);



@interface NMOAJson : NSObject

+ (id)jsonWithData:(NSData *)data;

+ (id)jsonWithNSString:(NSString *)string;

+ (NSData *)dataWithJson:(id)obj;

@end





@interface NMOANetWorking : NSObject

+ (NMOANetWorking *)share;


+ (NSString *)handleHTTPBodyParams:(NSDictionary *)params;

/*!
 *  开始一个http请求(post请求,返回data数据)
 *
 *  @param tag
 *  @param urlString
 *  @param httpHead
 *  @param bodyString
 *  @param taskFinished
 */
- (void)taskWithTag:(NSInteger)tag
          urlString:(NSString *)urlString
           httpHead:(NSDictionary *)httpHead
         bodyString:(NSString *)bodyString
   dataTaskFinished:(NMOANetWorkingDataTaskFinished)taskFinished;


/*!
 *  开始一个http请求(post请求,返回json数据)
 *
 *  @param tag
 *  @param urlString
 *  @param httpHead
 *  @param bodyString
 *  @param taskFinished
 */
- (void)taskWithTag:(NSInteger)tag
          urlString:(NSString *)urlString
           httpHead:(NSDictionary *)httpHead
         bodyString:(NSString *)bodyString
 objectTaskFinished:(NMOANetWorkingObjectTaskFinished)taskFinished;

/*!
 *  开始一个http请求(返回data数据)
 *
 *  @param tag
 *  @param urlString
 *  @param httpMethod
 *  @param httpHead
 *  @param bodyString
 *  @param taskFinished
 */
- (void)taskWithTag:(NSInteger)tag
          urlString:(NSString *)urlString
         httpMethod:(NSString *)httpMethod
           httpHead:(NSDictionary *)httpHead
         bodyString:(NSString *)bodyString
   dataTaskFinished:(NMOANetWorkingDataTaskFinished)taskFinished;

/**
 *  重新开始所有的网络请求
 */
- (void)resumeAllTask;

/**
 *  根据tag取消网络请求 (网络请求保留在队列中)
 *
 *  @param tag
 */
- (void)cancelTaskByTag:(NSInteger)tag;

/**
 *  取消所有的网络请求 (网络请求保留在队列中)
 */
- (void)cancelAllTask;

/**
 *  根据tag移除网络请求
 *
 *  @param tag
 */
- (void)removeTaskByTag:(NSInteger)tag;

/**
 *  根据tag判断是否存在此请求
 *
 *  @param tag
 */
- (BOOL)isTaskExistByTag:(NSInteger)tag;

/**
 *  根据tag移除网络请求
 *
 *  @param tag
 */
- (void)removeTaskByTag:(NSInteger)tag;


/**
 *  移除所有的网络请求
 */
- (void)removeAllTask;


+ (void)taskErrorHandle:(id)obj view:(UIView *)view;

@end
