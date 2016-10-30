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
#import "AutoKneadViewController.h"
#import "HandKneadViewController.h"

@interface UIImageView (backImageMove)

- (void)setViewCopiedImage:(UIView *)view;

@end

@implementation UIImageView (backImageMove)

- (void)setViewCopiedImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 4);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end

@interface HomePageController () <BasicBarViewDelegate>

@property (nonatomic , strong) HomePageButton *handButton;

@property (nonatomic , strong) HomePageButton *autoButton;

@property (nonatomic , strong) HomePageButton *musicButton;

@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIImageView *rightImageView;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) HomeMainView *mainView;

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
    UIImageView *upBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    upBackImage.image = [UIImage imageNamed:@"upBackgroud"];
    [self.view addSubview:upBackImage];
    
    UIImageView *downBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 180, self.view.width, 180)];
    downBackImage.image = [UIImage imageNamed:@"downBackgroud"];
    [self.view addSubview:downBackImage];
    
    [self setUpBarView];
    
    [self setUpHomeMainView];
    [self setUpBottomView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_mainView morriganStartTime:90 toEndTime:180];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeleftItemMove withTitle:@"M O R R I G A N"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpHomeMainView
{
    CGFloat mainViewW = kScreenWidth * 0.75 + (kScreenWidth > 320 ? 30 : 10); //kScreenWidth > 320 ? 300 : 220;
    CGFloat mainViewH = mainViewW / 624 * 860.0;
    CGFloat mainViewX = (kScreenWidth - mainViewW) /2 + (kScreenWidth > 320 ? 20 : 15); //kScreenWidth > 320 ? 50 : 20;
    
    NSDictionary *temDic = @{@"startTime":@0,@"endTime":@180};
    NSDictionary *temDic1 = @{@"startTime":@290,@"endTime":@380};
    NSArray *array = @[temDic,temDic1];
    _mainView = [[HomeMainView alloc] initWithMorriganArray:array withFarme:CGRectMake(mainViewX, 74, mainViewW, mainViewH)];
    _mainView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_mainView];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setUpCircleView)];
    [_mainView addGestureRecognizer:tap];
}

- (void)setUpCircleView
{
    [_mainView morriganStartTime:90 toEndTime:440];
}

- (void)setUpBottomView
{
    CGFloat bottomViewY = self.view.height - 150;
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
    HandKneadViewController *handKneadViewController = [[HandKneadViewController alloc] init];
    [self.navigationController pushViewController:handKneadViewController animated:YES];
}

//自动按摩
- (void)pushAutoPage{
    AutoKneadViewController *autoKneadViewController = [[AutoKneadViewController alloc] init];
    [self.navigationController pushViewController:autoKneadViewController animated:YES];
}

//音乐随动
- (void)pushMusicPage{
    
}

#pragma mark - BasicBarViewDelegate

- (void)clickBingdingDevice
{
    NSLog(@"绑定设备");
    
}

- (void)clickMoveToLeft
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftClick)]) {
        [self.delegate leftClick];
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
