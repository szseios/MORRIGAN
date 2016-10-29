//
//  SetTargetController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "SetTargetController.h"
#import "ZHRulerView.h"

@interface SetTargetController ()<BasicBarViewDelegate,ZHRulerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *achieveButton;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) ZHRulerView *rulerView;

@end

@implementation SetTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    // Do any additional setup after loading the view from its nib.
    _achieveButton.clipsToBounds = YES;
    _achieveButton.layer.cornerRadius = 5;
    [_achieveButton addTarget:self action:@selector(targetAchieve) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpBarView];
    
    [self setUpRulerView];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"设定目标"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)targetAchieve
{
    
}

- (void)setUpRulerView
{
    CGFloat rulerX = 0;
    CGFloat tempY = kScreenHeight > 480 ? 20 : 10;
    CGFloat rulerY = CGRectGetMaxY(_countLabel.frame) + tempY;
    CGFloat rulerWidth = kScreenWidth / 2 - 60;
    CGFloat rulerHeight = kScreenHeight > 480 ? 350 : 250;
    
    CGRect rulerFrame = CGRectMake(rulerX, rulerY, rulerWidth, rulerHeight);
    
    ZHRulerView *rulerView = [[ZHRulerView alloc] initWithMixNuber:2 maxNuber:85 showType:rulerViewshowVerticalType rulerMultiple:1];
    _rulerView = rulerView;
    rulerView.round = YES;
    rulerView.backgroundColor = [UIColor whiteColor];
//    rulerView.defaultVaule = [[CurrentUser.stepLong isEqualToString:@"(null)"] ? @"50" : @"60"];
    rulerView.delegate = self;
    rulerView.frame = rulerFrame;
    
    [self.view addSubview:rulerView];
    
    
}

#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBingdingDevice
{
    NSLog(@"绑定设备");
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
