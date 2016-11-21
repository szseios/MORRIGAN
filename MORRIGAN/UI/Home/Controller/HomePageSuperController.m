//
//  HomePageSuperController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"

@interface HomePageSuperController ()



@end

@implementation HomePageSuperController


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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenConnectView) name:ConnectPeripheralSuccess object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConnectView) name:DisconnectPeripheral object:nil];
}

- (void)hiddenConnectView
{
    if (_connectBottomView) {
        _connectBottomView.hidden = YES;
    }
}

- (void)showConnectView
{
    if (_connectBottomView) {
        _connectBottomView.hidden = NO;
    }
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
