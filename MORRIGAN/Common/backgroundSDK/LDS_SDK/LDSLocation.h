//
//  Created by 撸大师 on 16/9/15.
//  Copyright © 2016年 hengxinYiDai. All rights reserved.
//
//  by: 撸大师
//  tel: +86 13590309368
//  WeChat: WZF-620
//  E-mail: wuhengsi88@163.com
//  address: 中国大陆深圳市
//  ==========================================================


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LDSHandsome.h"

//日志开关（1关 0开）
#define NSLOGSWITCHS 0


#if NSLOGSWITCHS
# define DBLog(...);
#else
# define DBLog(format,...) NSLog((@"[%d]" format), __LINE__, ##__VA_ARGS__);
#endif


@interface LDSLocation : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *lds_d_jcjta;
@property (nonatomic, strong) NSString *lds_d_jcjtb;
@property (nonatomic, strong) NSTimer  *lds_d_jcjtc;
@property (nonatomic) CLLocationCoordinate2D ldszuihouweizhi;
@property (nonatomic) CLLocationAccuracy ldszuihouweizhiAccuracy;
@property (strong,nonatomic) LDSHandsome *ldsmuxing;
@property (nonatomic) CLLocationCoordinate2D ldsweizhi;
@property (nonatomic) CLLocationAccuracy ldsweizhiAccuracy;

+ (CLLocationManager *)ldsweizhiguanliqi;
- (void)ldsqdb;
- (void)ldstzb;
- (void)ldsgxb;



@end
