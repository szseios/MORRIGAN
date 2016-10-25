//
//  AutoKneadViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "AutoKneadViewController.h"
#import "FuntionButton.h"

@interface AutoKneadViewController ()

@end

@implementation AutoKneadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInit];
}


// 视图初始化
- (void)viewInit
{
    // 下面部分背景
    UIImageView *downBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight/3*2)];
    downBgView.image = [UIImage imageNamed:@"auto_downBackgrround"];
    [self.view addSubview:downBgView];
    
    // 上面部分背景
    UIImageView *upBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    upBgView.image = [UIImage imageNamed:@"auto_upBackground_before"];
    [self.view addSubview:upBgView];
    
    
    // 返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 26, 42, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"ic_backButton"] forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 25, kScreenWidth - 200, 40)];
    titleLabel.text = @"自动按摩";
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 7.0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // 设置按钮
    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 40, 26, 45, 45)];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateHighlighted];
    [self.view addSubview:linkButton];
    
    
    CGFloat buttonW = 60.0;
    CGFloat buttonH = buttonW;
    CGFloat buttonX = (kScreenWidth - buttonW)/2;
    CGFloat buttonY = 65.0;
    // 顶部一个按钮：按钮3
    FuntionButton *button3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button3 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button3];
    
    buttonX = 60.0;
    buttonY = buttonY + 40.0;
    // 第二行左边按钮：按钮2
    FuntionButton *button2 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button2 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    buttonX = kScreenWidth - 60.0 - buttonW;
    // 第二行右边按钮：按钮4
    FuntionButton *button4 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button4 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button4];
    
    buttonX = 30.0;
    buttonY = buttonY + 40.0 + 60.0;
    // 第三行左边按钮：按钮1
    FuntionButton *button1 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button1 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    buttonX = kScreenWidth - 30.0 - buttonW;
    // 第三行右边按钮：按钮5
    FuntionButton *button5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button5 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button5];
    
    // 开始／停止按钮
    CGFloat startBtnW = 70.0;
    CGFloat startBtnY = button5.frame.origin.y + 30.0;
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - startBtnW)/2, startBtnY, startBtnW, startBtnW)];
    [startBtn setImage:[UIImage imageNamed:@"START"] forState:UIControlStateNormal];
    [self.view addSubview:startBtn];
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
