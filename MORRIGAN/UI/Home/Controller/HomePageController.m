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
    UIImageView *upBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    upBackImage.image =[UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:upBackImage];
    
    UIImageView *downBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - (kScreenHeight > 568 ? 180 : 170), self.view.width, (kScreenHeight > 568 ? 180 : 170))];
    downBackImage.image = [UIImage imageNamed:@"downBackgroud"];
    [self.view addSubview:downBackImage];
    
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
    NSString *starStr = [[RecordManager share] getStarRank];
    if (starStr && starStr.length > 0) {
        [_mainView setStarLabelAndImage:starStr];
    }
    
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeleftItemMove withTitle:@"M O R R I G A N"  isShowRightButton:YES];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpHomeMainView
{
    CGFloat mainViewW = kScreenWidth * 0.75 + (kScreenWidth > 320 ? 30 : 10); //kScreenWidth > 320 ? 300 : 220;
    CGFloat mainViewH = mainViewW / 623 * 860.0;
    CGFloat mainViewX = (kScreenWidth - mainViewW) /2 + (kScreenWidth > 320 ? 20 : 15); //kScreenWidth > 320 ? 50 : 20;
    
//    NSDictionary *temDic = @{@"startTime":@90,@"endTime":@180};
//    NSDictionary *temDic1 = @{@"startTime":@270,@"endTime":@310};
//    NSDictionary *temDic3 = @{@"startTime":@200,@"endTime":@260};
//    NSArray *array = @[temDic,temDic1,temDic3];
    MassageRecordModel *model = [[MassageRecordModel alloc] init];
    model.startTime = [NSDate date];
    model.endTime = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
//    model.startTime = [NSDate dateWithTimeIntervalSinceNow:60*60*8];
//    model.endTime = [NSDate dateWithTimeInterval:60*60*2 sinceDate:model.startTime];
    NSArray *arra = @[model];
    NSArray *array = [DBManager selectForenoonDatas:[UserInfo share].userId];
    _mainView = [[HomeMainView alloc] initWithMorriganArray:arra withFarme:CGRectMake(mainViewX, 74, mainViewW, mainViewH)];
    _mainView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_mainView];
    
}

- (void)setUpCircleView
{
//    [_mainView morriganStartTime:90 toEndTime:240];
}

- (void)setUpBottomView
{
    CGFloat bottomViewY = self.view.height - (kScreenHeight > 568 ? 150 : 140);
    CGFloat bottomViewW = self.view.width;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, bottomViewW, 150)];
    
    
    CGFloat buttonW = 100;
    CGFloat buttonY = 0;
    CGFloat labelY = 90;
    CGFloat bottonX = (bottomViewW - 300) / 4;
    CGFloat labelH = 20;
    
    _handButton = [[HomePageButton alloc] initWithFrame:CGRectMake(bottonX , buttonY, buttonW, buttonW) withImageName:@"handMorrigan"];
    [_handButton addTarget:self action:@selector(pushHandlePage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *handLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottonX, labelY, buttonW, labelH)];
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
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(rightClick)]) {
            [self.delegate rightClick];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self clickBingdingDevice];
    }
}

- (void)setIsLeft:(BOOL)isLeft
{
    _isLeft = isLeft;
    if (isLeft) {
        self.view.size = CGSizeMake(kScreenWidth * (kScreenHeight - 64) * kScreenHeight,  kScreenHeight-250);
    }else{
        self.view.size = CGSizeMake(kScreenWidth,  kScreenHeight);
    }
    [self.view setNeedsDisplay];
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
