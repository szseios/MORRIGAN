//
//  NetController.h
//  SZSE
//
//  Created by Simon on 15-7-1.
//  Copyright (c) 2015年 szse. All rights reserved.
//

/*网络框架调用实例
 
SZSERequestInfo *info = [[SZSERequestInfo alloc] init];
info.dataType = 2;      //如果和默认数据类型一致，则不需要设置
info.headInfo = [NSDictionary dictionaryWithObject:@"head value" forKey:@"head key"];
info.cacheTag = 100;
info.cacheString = @"YES";
info.needParser = NO;   //如果和默认数据类型一致（默认值为YES），则不需要设置
info.requestTimeout = 1;

[[SZSENetWorking shareNetController] sendRequestWithID:0
                                             URLString:@"http://localhost:8080/3.json"
                                                  Body:nil
                                 RemovePreviousRequest:YES
                                             OtherInfo:info
                                      CallBackDelegate:self
                                              Finished:^(NetState state, id callbackData) {
                                                  
                                              }];
*/


#import <Foundation/Foundation.h>

#pragma mark 回调的网络状态
/*!
 *  回调的网络状态
 */
typedef NS_ENUM(NSInteger, NetState){
    /*!
     *  成功返回
     */
    net_Parser_SUCCES					=0,
    /*!
     *  网络连接错误
     */
    net_ConnectFailed					=1,
    /*!
     *  网络连接超时
     */
    net_ConnectTimeOut					=2,
    /*!
     *  返回html错误
     */
    net_HTML							=3,
    /*!
     *  解析错误
     */
    net_parser_error					=4,
    /*!
     *  请求对象被杀掉
     */
    net_killed							=5,
    /*!
     *  返回其他数据，plist设置或接口传参为不解析则返回此数据类型
     */
    net_unknowData                      =6,
    /*!
     *  返回xml数据，有些接口的值存在key的属性里，此时直接回调
     */
    net_xml                             =7,
};

/*!
 *  网络请求数据类型
 */
typedef NS_ENUM(NSInteger, SZSENetWokingDataType){
    /*!
     *  未知类型
     */
    SZSENetWokingUnknow = 0,
    /*!
     *  XML
     */
    SZSENetWokingXML,
    /*!
     *  Json
     */
    SZSENetWokingJson
};



#pragma mark 回调的方法协议
/******************************************************
        请求的回调函数，在callBackDelegate类中实现
*******************************************************/
@protocol SZSEConnectionParserDelegate <NSObject>
@optional
/****************************/
//回调数据，包括connectID、数据、状态
- (void)callBackWithConnectID:(NSInteger)connectID
                     WithData:(id)callBackDictionary
                 WithNetState:(NSInteger)netState;
//根据connectID回调请求相应的头信息
- (void)getRequestHeaderWithConnectID:(NSInteger)connectID
                           StatusCode:(NSInteger)statusCode
                               Header:(NSDictionary*)dic;
//根据connect回调请求接收的数据，用于展示下载进度
- (void)receiveData:(NSData*)data WithConnectID:(NSInteger)connectID;
@end


#pragma mark 请求的参数信息对象
/******************************************************
                    请求的参数信息对象
 *******************************************************/
@interface SZSERequestInfo : NSObject
@property (nonatomic, retain) NSDictionary *headInfo;          //请求需要添加的头信息
@property (nonatomic, assign) SZSENetWokingDataType dataType;  //返回数据的数据类型，1:xml   2:json，其他不解析，如果不设置从plist读取默认值
@property (nonatomic, assign) NSInteger cacheTag;              //请求缓存的标志，必须>=1，请求发出时如果内存中有这个标志，则直接从内存中回调数据
@property (nonatomic, retain) NSString *cacheString;           //请求缓存的字段，比如接口返回“data/errorCode=100”时则数据保存在内容中。如为"YES"，则数据下载就保存在内存中
@property (nonatomic, assign) BOOL needParser;                 //是否需要解析，默认值为需要解析YES
@property (nonatomic, assign) NSInteger requestTimeout;        //请求超时时间
@property (nonatomic, assign) BOOL isSynchro;                  //是否同步请求，默认值为NO(异步)
@end






#pragma mark 网络控制器对象
@interface SZSENetWorking : NSObject {
    
}
@property (nonatomic, retain) NSMutableDictionary *cacheData;
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, assign) BOOL verifyCertificate;

- (void)startNewConnectAndRemoveOld:(id)connect_parser;

+ (SZSENetWorking *)share;                       //获取网络框架对象

- (void)netLog:(NSString*)text;                             //控制台输出
- (void)showNetworkActivityIndicatorVisible:(BOOL)show;     //是否显示网络状态

#pragma mark 网络框架基本调用方法

/*!
 *  发送网络请求(自定义设置解析类型,默认的请求头),回调使用SZSEConnectionParserDelegate的回调方法
 *  dataType 的值为 SZSENetWokingUnknow 不解析数据
 *
 *  @param connectionId     网络请求ID
 *  @param urlString        URL
 *  @param bodyString       请求的body
 *  @param callBackDelegate 请求的回调对象
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                URLString:(NSString *)urlString
                     Body:(NSString *)bodyString
                 DataType:(SZSENetWokingDataType)dataType
         CallBackDelegate:(id)callBackDelegate;

/*!
 *  发送网络请求(自定义设置解析类型,默认的请求头)
 *  dataType 的值为 SZSENetWokingUnknow 不解析数据
 *
 *  @param connectionId     网络请求ID
 *  @param urlString        URL
 *  @param bodyString       请求的body
 *  @param callBackDelegate 请求的回调对象
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                URLString:(NSString *)urlString
                     Body:(NSString *)bodyString
                 DataType:(SZSENetWokingDataType)dataType
         Finished:(void (^)(NetState state, NSDictionary *responseHead, id callbackData))finishBlcok;


/*!
 *  发送网络请求(自动解析Json数据,默认的请求头),回调使用SZSEConnectionParserDelegate的回调方法
 *
 *  @param connectionId     网络请求ID
 *  @param urlString        URL
 *  @param bodyString       请求的body
 *  @param callBackDelegate 请求的回调对象
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                URLString:(NSString *)urlString
                     Body:(NSString *)bodyString
         CallBackDelegate:(id)callBackDelegate;

/*!
 *  发送网络请求(自动解析Json数据,默认的请求头)
 *
 *  @param connectionId 网络请求ID
 *  @param urlString    URL
 *  @param bodyString   请求的body
 *  @param finishBlcok  请求的回调的block
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                URLString:(NSString *)urlString
                     Body:(NSString *)bodyString
                 Finished:(void (^)(NetState state, NSDictionary *responseHead, id callbackData))finishBlcok;

/*!
 *  发送网络请求,自定义配置请求头,是否解析返回的数据
 *
 *  @param connectionId     网络请求ID
 *  @param urlString        请求的url地址
 *  @param bodyString       请求的body
 *  @param remove           是否移除之前的请求
 *  @param infoDic          请求的其他信息，比如body，http头信息，是否移除之前的请求，dataType，cache标志，cache字段
 *  @param callBackDelegate 请求的回调对象
 *  @param finishBlcok      请求的回调的block
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                URLString:(NSString*)urlString
                     Body:(NSString*)bodyString
    RemovePreviousRequest:(BOOL)remove
                OtherInfo:(SZSERequestInfo*)infoDic
         CallBackDelegate:(id)callBackDelegate
                 Finished:(void (^)(NetState state, NSDictionary *responseHead, id callbackData))finishBlcok;

/*!
 *  解析本地文件
 *
 *  @param connectionId     网络请求ID
 *  @param path             文件路径
 *  @param dType            数据类型 0:xml    1:json  其他不解析
 *  @param callBackDelegate 请求的回调对象
 *  @param remove           是否移除之前的请求
 *  @param finishBlcok      请求的回调的block
 */
- (void)sendRequestWithID:(NSInteger)connectionId
                 FilePath:(NSString*)path
                 DataType:(NSInteger)dType
         CallBackDelegate:(id)callBackDelegate
    RemovePreviousRequest:(BOOL)remove
                 Finished:(void (^)(NetState state, NSDictionary *responseHead, id callbackData))finishBlcok;

#pragma mark 其他功能性接口

//根据urlType从配置文件中获取url地址
- (NSString *)getUrlStringWithUrlType:(NSString*)urlType IsCustom:(BOOL)isCustom;

//根据connectID和delegate移除对应的请求
- (void)removeRequestWithConnect:(NSInteger)connectID Delegate:(id)delegate;

//移除所有请求
- (void)removeAllRequest;

//根据url类型清空数据
- (void)removeCacheWithCacheTag:(NSInteger)cacheTag;

//移除所有的存储数据,用于重新登录
- (void)removeAllData;
@end
