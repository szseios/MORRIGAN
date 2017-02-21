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
#import "LDSChashe.h"
#import <CoreLocation/CoreLocation.h>


@interface LDSHandsome : NSObject

@property (nonatomic, assign) int lds_d_backruna;
@property (nonatomic, assign) int lds_d_backrunb;
@property (nonatomic, strong) NSTimer  *lds_d_backrun;
@property (nonatomic) NSTimer *ldsshizhong;
@property (nonatomic) NSTimer * ldsyanchishimiao;
@property (nonatomic) LDSChashe * lasderenwu;
@property (nonatomic) NSMutableArray *ldsweizhiArray;
+ (id)lasdemuxing;


@end
