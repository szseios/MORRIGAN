//
//  AutoKneadViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "AutoKneadViewController.h"
#import "FuntionButton.h"
#import "Utils.h"

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
    
    // 向上拖动 任意模式按钮
    CGFloat label1H = 18;
    CGFloat label1Y = startBtn.frame.origin.y + startBtn.frame.size.height + 20;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1Y, kScreenWidth, label1H)];
    label1.text = @"向上拖动 任意模式按钮";
    label1.textColor = [Utils stringTOColor:kColor_6911a5];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:label1];
    
    // 进行自由组合按摩 点击START开始按摩
    CGFloat label2H = 16;
    CGFloat label2Y = label1.frame.origin.y + label1.frame.size.height + 5;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2Y, kScreenWidth, label2H)];
    label2.text = @"进行自由组合按摩 点击START开始按摩";
    label2.textColor = [Utils stringTOColor:kColor_6911a5];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:12.0];
    [self.view addSubview:label2];
    
    CGFloat margingLeftRight = kScreenWidth/2/2 - 50;
    buttonY = label2.frame.origin.y + label2.frame.size.height + 60;
    buttonX = margingLeftRight;
    // 轻柔（底部：1行－左）
    FuntionButton *funButton1 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [funButton1 setImage:[UIImage imageNamed:@"soft"] forState:UIControlStateNormal];
    [self.view addSubview:funButton1];
   
    buttonX = (kScreenWidth-buttonW)/2;
    // 水波（底部：1行－中）
    FuntionButton *funButton2 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [funButton2 setImage:[UIImage imageNamed:@"warter"] forState:UIControlStateNormal];
    [self.view addSubview:funButton2];
    
    buttonX = kScreenWidth - margingLeftRight - buttonW;
    // 微按（底部：1行－右）
    FuntionButton *funButton3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [funButton3 setImage:[UIImage imageNamed:@"lightPress"] forState:UIControlStateNormal];
    [self.view addSubview:funButton3];
    
    buttonY = funButton3.frame.origin.y + funButton3.frame.size.height + 20;
    buttonX = funButton1.frame.origin.x + funButton1.frame.size.width + ((funButton2.frame.origin.x - (funButton1.frame.origin.x + funButton1.frame.size.width))/2 - buttonW/2);
    // 强振（底部：2行－左）
    FuntionButton *funButton4 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [funButton4 setImage:[UIImage imageNamed:@"strongShake"] forState:UIControlStateNormal];
    [self.view addSubview:funButton4];
    
    buttonX = funButton2.frame.origin.x + funButton2.frame.size.width + ((funButton3.frame.origin.x - (funButton2.frame.origin.x + funButton2.frame.size.width))/2 - buttonW/2);
    // 动感（底部：2行－右）
    FuntionButton *funButton5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [funButton5 setImage:[UIImage imageNamed:@"movingFeel"] forState:UIControlStateNormal];
    [self.view addSubview:funButton5];
    
    
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
