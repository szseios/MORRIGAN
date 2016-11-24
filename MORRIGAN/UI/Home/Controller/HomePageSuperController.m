//
//  HomePageSuperController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"

@interface HomePageSuperController () {
    UIButton *_searchButton;
}



@end

@implementation HomePageSuperController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //如果没有连上蓝牙设备,开始执行动画
    if (![BluetoothManager share].isConnected) {
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
//        _connectBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 25, kScreenWidth, 25)];
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
    
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 26 - 32,
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
    if (![BluetoothManager share].isConnected) {
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
    
    [_searchButton.layer addAnimation:animation forKey:nil];
}

- (void)clickSearchButton {
    SearchPeripheralViewController *ctl = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
