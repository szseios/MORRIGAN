//
//  HomePageSuperController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface HomePageSuperController () <UIAlertViewDelegate> {
    UIButton *_searchButton;
}



@end

@implementation HomePageSuperController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //如果没有连上蓝牙设备,开始执行动画
    if (![UserInfo share].isConnected) {
        [self startFlashing];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopFlashing];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    if (![BluetoothManager share].isConnected) {
//        _connectBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH eight - 25, kScreenWidth, 25)];
//        _connectBottomView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
//        [self.view addSubview:_connectBottomView];
//        
//        UILabel *remindLabel = [[UILabel alloc] initWithFrame:_connectBottomView.bounds];
//        remindLabel.text = @"蓝牙未连接!";
//        remindLabel.textAlignment = NSTextAlignmentCenter;
//        remindLabel.textColor = [UIColor whiteColor];
//        remindLabel.font = [UIFont systemFontOfSize:15];
//        [_connectBottomView addSubview:remindLabel];
//        
//        [self.view bringSubviewToFront:_connectBottomView];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopFlashing)
                                                 name:ConnectPeripheralSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFlashing)
                                                 name:DisconnectPeripheral
                                               object:nil];
    
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 32,
                                                               26,
                                                               32,
                                                               32)];
    [_searchButton setBackgroundImage:[UIImage imageNamed:@"icon_rightItem_link"]
                             forState:UIControlStateNormal];
    [_searchButton addTarget:self
                      action:@selector(clickSearchButton)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchButton];
    
    //如果没有连上蓝牙设备,开始执行动画
    if (![UserInfo share].isConnected) {
        [self startFlashing];
    }
}

- (void)stopFlashing
{
    [_searchButton.layer removeAllAnimations];
}

- (void)startFlashing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.repeatCount = NSIntegerMax;
    animation.fromValue = @(1);
    animation.toValue = @(0.3);
    animation.autoreverses = YES;
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    
    [_searchButton.layer addAnimation:animation forKey:nil];
}

- (void)clickSearchButton {
    if ([UserInfo share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"确定切换设备？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 9999;
        [alert show];
    }else{
        //如果用户打开了蓝牙
//        if ([[BluetoothManager share] getCentralManager].state == CBCentralManagerStatePoweredOn) {
        SearchPeripheralViewController *ctl = [[SearchPeripheralViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
//        }
//        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"打开蓝牙来允许＂MORRIGAN＂连接到配件"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"好"
//                                                  otherButtonTitles:@"设置", nil];
//            alert.tag = 8888;
//            [alert show];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 8888) {
        if (buttonIndex == 1) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            else {
                NSURL *url = [NSURL URLWithString:@"Prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
            //         NSData *urlData = [NSData dataWithBytes:(unsigned char []){0x50,0x72,0x65,0x66,0x73,0x3a,0x72,0x6f,0x6f,0x74,0x3d,0x42,0x6c,0x75,0x65,0x74,0x6f,0x6f,0x74,0x68} length:20];
            //        NSString *urlKey = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
            //        NSURL*url=[NSURL URLWithString:urlKey];
            //
            //        NSData *lsData = [NSData dataWithBytes:(unsigned char []){0x4c,0x53,0x41,0x70,0x70,0x6c,0x69,0x63,0x61,0x74,0x69,0x6f,0x6e,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:22];
            //
            //        NSString *lsKey = [[NSString alloc] initWithData:lsData encoding:NSASCIIStringEncoding];
            //        Class ls = NSClassFromString(lsKey);
            //
            //        NSData *dfData = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
            //        NSString *dfKey = [[NSString alloc] initWithData:dfData encoding:NSASCIIStringEncoding];
            //
            //        NSData *opData = [NSData dataWithBytes:(unsigned char []){0x6f,0x70,0x65,0x6e,0x53,0x65,0x6e,0x73,0x69,0x74,0x69,0x76,0x65,0x55,0x52,0x4c,0x3a,0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73,0x3a} length:29];
            //        NSString *opKey = [[NSString alloc] initWithData:opData encoding:NSASCIIStringEncoding];
            //
            //        [[ls performSelector:NSSelectorFromString(dfKey)] performSelector:NSSelectorFromString(opKey)
            //                                                               withObject:url
            //                                                               withObject:nil];
            
            
        }
    }
    else if (alertView.tag == 9999) {
        if (buttonIndex == 1) {
            SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
            [self.navigationController pushViewController:search animated:YES];
            
        }
    }
    
}


@end
