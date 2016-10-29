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

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
    UIImageView *upBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 100)];
    upBackImage.image = [UIImage imageNamed:@"upBackgroud"];
    [self.view addSubview:upBackImage];
    
    UIImageView *downBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height - 220, self.view.width, 220)];
    downBackImage.image = [UIImage imageNamed:@"downBackgroud"];
    [self.view addSubview:downBackImage];
    
    [self setUpBarView];
    
    [self setUpHomeMainView];
    [self setUpBottomView];
    
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeleftItemMove withTitle:@"M O R R I G A N"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpHomeMainView
{
    CGFloat mainViewX = kScreenWidth > 320 ? 50 : 20;
    CGFloat mainViewW = kScreenWidth > 320 ? 300 : 260;
    CGFloat mainViewH = mainViewW / 624 * 860.0;
    HomeMainView *mainView = [[HomeMainView alloc] initWithFrame:CGRectMake(mainViewX, 64, mainViewW, mainViewH)];
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    
}

- (void)setUpBottomView
{
    CGFloat bottomViewY = self.view.height - 180;
    CGFloat bottomViewW = self.view.width;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, bottomViewW, 200)];
    
    
    CGFloat buttonW = 100;
    CGFloat buttonY = 25;
    CGFloat labelY = 125;
    CGFloat bottonX = (bottomViewW - 270) / 3;
    
    _handButton = [[HomePageButton alloc] initWithFrame:CGRectMake(bottonX -10, buttonY, buttonW, buttonW) withImageName:@"handMorrigan"];
    [_handButton addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    UILabel *handLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottonX-10, labelY, buttonW, 30)];
    handLabel.textAlignment = NSTextAlignmentCenter;
    handLabel.text = @"手动按摩";
    [_bottomView addSubview:handLabel];
    
    CGFloat autoButtonX = CGRectGetMaxX(_handButton.frame);
    _autoButton = [[HomePageButton alloc] initWithFrame:CGRectMake(autoButtonX + 10, buttonY, buttonW, buttonW) withImageName:@"autoMorrigan"];
    UILabel *autoLabel = [[UILabel alloc] initWithFrame:CGRectMake(autoButtonX +10, labelY, buttonW, 30)];
    autoLabel.textAlignment = NSTextAlignmentCenter;
    autoLabel.text = @"自动按摩";
    [_bottomView addSubview:autoLabel];
    
    CGFloat musicButtonX = CGRectGetMaxX(_autoButton.frame);
    _musicButton = [[HomePageButton alloc] initWithFrame:CGRectMake(musicButtonX + 10, buttonY, buttonW, buttonW) withImageName:@"music"];
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(musicButtonX +10, labelY, buttonW, 30)];
    musicLabel.textAlignment = NSTextAlignmentCenter;
    musicLabel.text = @"音乐随动";
    [_bottomView addSubview:musicLabel];
    
    [_bottomView addSubview:_handButton];
    [_bottomView addSubview:_autoButton];
    [_bottomView addSubview:_musicButton];
    
    [self.view addSubview:_bottomView];
    
    
    
}

- (void)push{
    
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
