//
//  HomePageController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageController.h"
#import "HomePageButton.h"
#import "HomePageController.h"
#import "HomeMainView.h"
#import "BasicBarView.h"
#import "MusicViewController.h"
#import "SearchPeripheralViewController.h"
#import "AutoKneadViewController.h"
#import "HandKneadViewController.h"
#import "RecordManager.h"
#import "MassageRecordModel.h"

@interface HomePageController () <BasicBarViewDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) HomePageButton *handButton;

@property (nonatomic , strong) HomePageButton *autoButton;

@property (nonatomic , strong) HomePageButton *musicButton;

@property (nonatomic , strong) UIView *bottomView;

@property (nonatomic , strong) UIImageView *rightImageView;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) HomeMainView *mainView;

//@property (nonatomic , assign) BOOL isLeft;



@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectricity:) name:ElectricQuantityChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstGetElectricity:) name:ConnectPeripheralSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DisconnectPeripheral:) name:DisconnectPeripheral object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStarRank:) name:GETSTARRANKNOTIFICATION object:nil];
    
    UIImageView *downBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - (kScreenHeight > 568 ? 280 : 270), self.view.width, (kScreenHeight > 568 ? 280 : 270))];
    downBackImage.image = [UIImage imageNamed:@"downBackgroud"];
    [self.view addSubview:downBackImage];
    UIImageView *upBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 80)];
    upBackImage.image =[UIImage imageNamed:@"upBackgroud"];
    [self.view addSubview:upBackImage];
    
    [self setUpBarView];
    
    
    [self setUpBottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveBack)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    if (![BluetoothManager share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还未连接设备" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"连接", nil];
        [alert show];
    }
   
    [self setUpHomeMainView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RecordManager share] getStarRank];
//    if (starStr && starStr.length > 0) {
//        [_mainView setStarLabelAndImage:starStr];
//    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date1 = [dateFormatter dateFromString:@"2016-12-02 17:15:01"];
//    NSDate *date2 = [dateFormatter dateFromString:@"2016-12-02 20:30:01"];
//    
//    MassageRecordModel *model = [[MassageRecordModel alloc] init];
//    model.userID = @"0bb15e9c-561c-4573-9726-11a1e4d82390";
//    model.type = 1;
//    model.startTime = date1;
//    model.endTime = date2;
//    
//    
//    NSDate *date3 = [dateFormatter dateFromString:@"2016-12-02 21:15:01"];
//    NSDate *date4 = [dateFormatter dateFromString:@"2016-12-02 23:30:01"];
//    
//    MassageRecordModel *model1 = [[MassageRecordModel alloc] init];
//    model1.userID = @"0bb15e9c-561c-4573-9726-11a1e4d82390";
//    model1.type = 1;
//    model1.startTime = date3;
//    model1.endTime = date4;  @[model,model1];
    
    NSArray *ForenoonArray = [DBManager selectForenoonDatas:[UserInfo share].userId];
    NSArray *AfternoonArray = [DBManager selectaAfternoonDatas:[UserInfo share].userId];
    [_mainView showRightTime];
    [_mainView refreshLatestDataForAMMorrigan:ForenoonArray PMMorrigan:AfternoonArray];
    [_mainView displayView];
    //如果没有连上蓝牙设备,开始执行动画
    if (![BluetoothManager share].isConnected) {
        [_barView startFlashing];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_barView stopFlashing];
    
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeleftItemMove withTitle:@"M O R R I G A N"  isShowRightButton:YES];
    [_barView showCenterView];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpHomeMainView
{
    CGFloat mainViewW = kScreenWidth * 0.75 + (kScreenWidth > 320 ? 30 : 10); //kScreenWidth > 320 ? 300 : 220;
    CGFloat mainViewH = mainViewW / 623 * 860.0;
    CGFloat mainViewX = (kScreenWidth - mainViewW) /2 + (kScreenWidth > 320 ? 20 : 15); //kScreenWidth > 320 ? 50 : 20;
    NSArray *ForenoonArray = [DBManager selectForenoonDatas:[UserInfo share].userId];
    NSArray *AfternoonArray = [DBManager selectaAfternoonDatas:[UserInfo share].userId];
    _mainView = [[HomeMainView alloc] initWithAMMorriganArray:ForenoonArray PMMorriganTime:AfternoonArray  withFarme:CGRectMake(mainViewX, 74, mainViewW, mainViewH)];
    _mainView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_mainView];
    
}

- (void)setUpCircleView
{
    
}

- (void)setUpBottomView
{
    CGFloat bottomViewY = self.view.height - (kScreenHeight > 568 ? 140 : 130);
    CGFloat bottomViewW = self.view.width - 60;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(30, bottomViewY, bottomViewW, 150)];
    
    
    CGFloat buttonW = kScreenHeight > 568 ? 100 : 80;
    CGFloat buttonY = 10;
    CGFloat labelY = kScreenHeight > 568 ? 100 : 90;
    CGFloat bottonX = (bottomViewW - buttonW * 3) / 2;
    CGFloat labelH = 20;
    
    _handButton = [[HomePageButton alloc] initWithFrame:CGRectMake(0 , buttonY, buttonW, buttonW) withImageName:@"handMorrigan"];
    [_handButton addTarget:self action:@selector(pushHandlePage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *handLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, buttonW, labelH)];
    handLabel.textAlignment = NSTextAlignmentCenter;
    handLabel.text = @"手动按摩";
    handLabel.textColor = [UIColor purpleColor];
    handLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:handLabel];
    
    CGFloat autoButtonX = CGRectGetMaxX(_handButton.frame) + bottonX;
    _autoButton = [[HomePageButton alloc] initWithFrame:CGRectMake(autoButtonX, buttonY, buttonW, buttonW) withImageName:@"autoMorrigan"];
    [_autoButton addTarget:self action:@selector(pushAutoPage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *autoLabel = [[UILabel alloc] initWithFrame:CGRectMake(autoButtonX, labelY, buttonW, labelH)];
    autoLabel.textAlignment = NSTextAlignmentCenter;
    autoLabel.text = @"自动按摩";
    autoLabel.textColor = [UIColor purpleColor];
    autoLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:autoLabel];
    
    CGFloat musicButtonX = CGRectGetMaxX(_autoButton.frame) + bottonX ;
    _musicButton = [[HomePageButton alloc] initWithFrame:CGRectMake(musicButtonX, buttonY, buttonW, buttonW) withImageName:@"music"];
    [_musicButton addTarget:self action:@selector(pushMusicPage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(musicButtonX, labelY, buttonW, labelH)];
    musicLabel.textAlignment = NSTextAlignmentCenter;
    musicLabel.text = @"音乐随动";
    musicLabel.textColor = [UIColor purpleColor];
    musicLabel.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:musicLabel];
    
    [_bottomView addSubview:_handButton];
    [_bottomView addSubview:_autoButton];
    [_bottomView addSubview:_musicButton];
    
    [self.view addSubview:_bottomView];
    
    
    
}
//手动按摩
- (void)pushHandlePage{
    if (!_isLeft) {
        _handButton.enabled = YES;
        HandKneadViewController *handKneadViewController = [[HandKneadViewController alloc] init];
        [self.navigationController pushViewController:handKneadViewController animated:YES];
    }
}

//自动按摩
- (void)pushAutoPage{
    AutoKneadViewController *autoKneadViewController = [[AutoKneadViewController alloc] init];
    [self.navigationController pushViewController:autoKneadViewController animated:YES];
}

//音乐随动
- (void)pushMusicPage{
    MusicViewController *music = [[MusicViewController alloc] init];
    [self.navigationController pushViewController:music animated:YES];
}

#pragma mark - BasicBarViewDelegate

- (void)clickBingdingDevice
{
    if ([BluetoothManager share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"需要切换设备？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 9999;
        [alert show];
    }else{
    //如果用户打开了蓝牙
    if ([[BluetoothManager share] getCentralManager].state == CBCentralManagerStatePoweredOn) {
        SearchPeripheralViewController *ctl = [[SearchPeripheralViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"打开蓝牙来允许＂MORRIGAN＂连接到配件"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:@"设置", nil];
        alert.tag = 111;
        [alert show];
    }
    }
}


- (void)clickMoveToLeft
{
    if (!_isLeft) {
        _isLeft = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(leftClick)]) {
            [self.delegate leftClick];
        }
        _handButton.enabled = NO;
    }else{
        _isLeft = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(rightClick)]) {
            [self.delegate rightClick];
        }
        _handButton.enabled = YES;
    }
    
}

- (void)moveBack
{
    if (_isLeft) {
        _isLeft = NO;
        _handButton.enabled = YES;
        [_mainView showRightTime];
        [_mainView displayView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(rightClick)]) {
            [self.delegate rightClick];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            else {
                NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    }
    else if (alertView.tag == 9999) {
        if (buttonIndex == 1) {
            SearchPeripheralViewController *ctl = [[SearchPeripheralViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
        }
    }
    else {
        if (buttonIndex == 1) {
            [self clickBingdingDevice];
        }
    }
    
}

//电量变化
- (void)getElectricity:(NSNotification *)notice
{
    if (notice.object) {
        NSInteger persentInt = [Utils hexToInt:notice.object];
        CGFloat persent = persentInt * 0.01;
        [_mainView setElectricityPersent:persent];
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",persentInt]];
        [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, attributeString.length - 1)];
        _mainView.electricityLabel.attributedText = attributeString;
    }
}

- (void)DisconnectPeripheral:(NSNotification *)notice
{
    [_mainView setElectricityPersent:0];
}

//第一次主动获取电量
- (void)firstGetElectricity:(NSNotification *)notice
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BluetoothOperation *operation = [[BluetoothOperation alloc] init];
        [operation setValue:@"03" index:2];
        [[BluetoothManager share] writeValueByOperation:operation];
        operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
            if (success) {
                NSString *electriQuantity = [response substringWithRange:NSMakeRange(4, 2)];
                [_mainView setElectricityPersent:[electriQuantity floatValue]];
            }
            
        };
    });
    
}

- (void)setStarRank:(NSNotification *)notice
{
    NSString *starStr = notice.object;
    if (starStr && starStr.length > 0) {
//        [_mainView setStarLabelAndImage:starStr];
        NSString *imageName;
        NSString *starLabelStr;
        switch (starStr.integerValue) {
            case -1:
            {
                imageName = @"icon_star_0";
                starLabelStr = @"0";
            }
                break;
            case 0:
            {
                imageName = @"icon_star_5";
                starLabelStr = @"0.5";
            }
                break;
            case 1:
            {
                imageName = @"icon_star_10";
                starLabelStr = @"1";
            }
                break;
                
            case 2:
            {
                imageName = @"icon_star_15";
                starLabelStr = @"1.5";
            }
                break;
                
            case 3:
            {
                imageName = @"icon_star_20";
                starLabelStr = @"2";
            }
                break;
                
            case 4:
            {
                imageName = @"icon_star_25";
                starLabelStr = @"2.5";
            }
                break;
                
            case 5:
            {
                imageName = @"icon_star_30";
                starLabelStr = @"3";
            }
                break;
                
                
            default:
                break;
        }
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@star",starLabelStr]];
        [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, starStr.length)];
        _mainView.starLabel.attributedText = attributeString;
        [_mainView.starImage setImage:[UIImage imageNamed:imageName]];
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
