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

#import "LDSCallViewController.h"

@interface LDSCallViewController ()
@end
@implementation LDSCallViewController

-(void)ldscalls
{
     [[RecordManager share] getStarRank];
//    DBLog(@"经度--> %f 纬度--> %f",_ldsPlacemarks.location.coordinate.longitude,
//          _ldsPlacemarks.location.coordinate.latitude);
//    DBLog(@"(国别) %@",      [_ldsDicAddress objectForKey:@"Country"]); // (国别) 中国
//    DBLog(@"(省份) %@",        [_ldsDicAddress objectForKey:@"State"]); //（省份）广东省
//    DBLog(@"(城市) %@",         [_ldsDicAddress objectForKey:@"City"]); //（城市）深圳市
//    DBLog(@"(区) %@",    [_ldsDicAddress objectForKey:@"SubLocality"]); //（区）罗湖区
//    DBLog(@"(路) %@",   [_ldsDicAddress objectForKey:@"Thoroughfare"]); //（路）
//    DBLog(@"(号) %@",[_ldsDicAddress objectForKey:@"SubThoroughfare"]); //（号）
//    DBLog(@"(地址) %@",          [_ldsDicAddress objectForKey:@"Name"]); //完整地址
//    
//    DBLog(@"👨👨当前位置: %@%@%@%@%@%@",[_ldsDicAddress objectForKey:@"Country"],[_ldsDicAddress objectForKey:@"State"],[_ldsDicAddress objectForKey:@"City"],[_ldsDicAddress objectForKey:@"SubLocality"],[_ldsDicAddress objectForKey:@"Thoroughfare"],[_ldsDicAddress objectForKey:@"SubThoroughfare"]);
//    
//    //播放系统声音（下面代码示例所用，可删除）
//    SystemSoundID myAlertSound;
//    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/alarm.caf"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
//    AudioServicesPlaySystemSound(myAlertSound);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
