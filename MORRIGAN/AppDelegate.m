//
//  AppDelegate.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MusicViewController.h"
#import "HandKneadViewController.h"
#import "AutoKneadViewController.h"
#import "MusicManager.h"
#import "BluetoothManager.h"
#import <AVFoundation/AVFoundation.h>
#import "RootViewController.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化网络状态
    [self initReachability];
    [DBManager initApplicationsDB];
    [MusicManager share];
    [BluetoothManager share];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];//设置窗口
    //BTTestViewController *loginViewController = [[BTTestViewController alloc] init];
    //AutoKneadViewController *loginViewController = [[AutoKneadViewController alloc] init];
    //HandKneadViewController *loginViewController = [[HandKneadViewController alloc] init];
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    //MusicViewController *loginViewController = [[MusicViewController alloc] init];
    //loginViewController.musics = [MusicManager share].musics;
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    //nav.navigationBarHidden = YES;
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    // 启动页面
    UIImageView *wellcomeView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
    [wellcomeView setImage:[UIImage imageNamed:@"640-1136"]];
    [self.window addSubview:wellcomeView];
    [self.window bringSubviewToFront:wellcomeView];
    __block UIImageView *wellcomeViewBlock = wellcomeView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kWelcomePageDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wellcomeViewBlock removeFromSuperview];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
//        [self.window makeKeyAndVisible];

    });
  
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date1 = [dateFormatter dateFromString:@"2016-12-01 20:15:01"];
//    NSDate *date2 = [dateFormatter dateFromString:@"2016-12-01 20:16:01"];
//
//    MassageRecordModel *model = [[MassageRecordModel alloc] init];
//    model.userID = @"1";
//    model.type = 1;
//    model.startTime = date1;
//    model.endTime = date2;
//    [DBManager insertData:model.userID startTime:model.startTime endTime:model.endTime type:model.type];
//    NSArray *array = [DBManager selectUploadDatas:@"1"];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block  UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Reachability

- (void)initReachability {
    __block AppDelegate *appDelegate = self;
    
    _reach = [Reachability reachabilityWithHostname:@"e.szse.cn"];
    _reach.reachableBlock = ^(Reachability * reachability) {
        NSString * temp = [NSString stringWithFormat:@"网络状态改变  :  %@", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [appDelegate reachabilityChanged];
        });
    };
    
    _reach.unreachableBlock = ^(Reachability * reachability) {
        //if ([appDelegate.window.rootViewController isKindOfClass:[NMOARootViewController class]]) {
            NSLog(@"网络状态改变  :  没有网络");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [appDelegate unreachable];
            });
       // }
    };
    [_reach startNotifier];
}

- (BOOL)checkReachable {
    if ([_reach currentReachabilityStatus] == NotReachable) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前网络不可用，请检查你的网络设置。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)unreachable {
    NetworkStatus status = [_reach currentReachabilityStatus];
    if (status == NotReachable) {
//        [MBProgressHUD showHUDByContent:@"当前网络不可用，请检查您的网络设置。"
//                                   view:UI_Window
//                             afterDelay:3];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前网络不可用，请检查你的网络设置。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
    NSLog(@"当前网络状态 : %@",[_reach currentReachabilityString]);
}




@end
