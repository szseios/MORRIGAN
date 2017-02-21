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

#import <UIKit/UIKit.h>
#import "LDSLocation.h"
#import <CoreLocation/CoreLocation.h>

#import <AVFoundation/AVFoundation.h>

@interface LDSCallViewController : UIViewController

/**
 返回地理位置字典
 {
 City = "\U6df1\U5733\U5~ ~ ~";
 Country = "\U4e2d\U5~ ~ ~";
 CountryCode = CN;
 FormattedAddressLines =     (
 "\U4e2d\U56fd\U5e7f\U4e1c\U7701\U6df1\U5733\U5e02\U7f57\U6e56\U533a\U5357~ ~ ~"
 );
 Name = "\U4e2d\U56fd\U5e7f\U4e1c\U7701\U6df1\U5733\U5e02\U7f57~ ~ ~";
 State = "\U5e7f\U4e1~ ~ ~";
 Street = "\U5efa\U8bbe\U8def20~ ~ ~";
 SubLocality = "\U7f57\U6e~ ~ ~";
 SubThoroughfare = "2002\U5~ ~ ~";
 Thoroughfare = "\U5efa\U8bbe\U8~ ~ ~";
 }
 */
@property (nonatomic, strong) NSDictionary *ldsDicAddress;


/**
 返回经纬度
 CLPlacemark里面包含经纬度、地理位置信息
 */
@property (nonatomic, strong) CLPlacemark *ldsPlacemarks;


/**
 app按home键进入后台或锁屏之后依然会定时调下面的方法
 您可以在里面添加要处理的事务；除非app进程被用户杀死
 或系统回收否则会永久调用此方法
 */
-(void)ldscalls;



@end
