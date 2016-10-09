//
//  手动按摩界面
//
//  HandKneadViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HandKneadViewController.h"

@interface HandKneadViewController ()

@end

@implementation HandKneadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self viewInit];
    
}

// 视图初始化
- (void)viewInit
{
    
    self.view.backgroundColor = [UIColor blueColor];
    
    // 大圆圈根视图
    CGFloat bigCircleRootViewMarging = 60;
    CGFloat bigCircleRootViewX = bigCircleRootViewMarging;
    CGFloat bigCircleRootViewY = 64 + bigCircleRootViewMarging;
    CGFloat bigCircleRootViewW = kScreenWidth - 2*bigCircleRootViewMarging;
    CGFloat bigCircleRootViewH = bigCircleRootViewW;
    UIImageView *bigCircleRootView = [[UIImageView alloc] initWithFrame:CGRectMake(bigCircleRootViewX, bigCircleRootViewY, bigCircleRootViewW, bigCircleRootViewH)];
    bigCircleRootView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bigCircleRootView];
    // gear大数字
    CGFloat gearNumLabelW = 70;
    CGFloat gearNumLabelH = 90;
    CGFloat gearNumLabelX = bigCircleRootViewW/2 - gearNumLabelW;
    CGFloat gearNumLabelY = bigCircleRootViewW/2 - gearNumLabelH;
    UILabel *gearNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(gearNumLabelX, gearNumLabelY, gearNumLabelW, gearNumLabelH)];
    gearNumLabel.text = @"3";
    gearNumLabel.textColor = [UIColor whiteColor];
    gearNumLabel.font = [UIFont italicSystemFontOfSize:100.0];
    [bigCircleRootView addSubview:gearNumLabel];
    // gear
    CGFloat gearLabelW = 80;
    CGFloat gearLabelH = 40;
    CGFloat gearLabelX = gearNumLabelX + gearNumLabelW + 20;
    CGFloat gearLabelY = gearNumLabelY + gearNumLabelH - gearLabelH - 10;
    UILabel *gearLabel = [[UILabel alloc] initWithFrame:CGRectMake(gearLabelX, gearLabelY, gearLabelW, gearLabelH)];
    gearLabel.text = @"gear";
    gearLabel.textColor = [UIColor whiteColor];
    gearLabel.font = [UIFont italicSystemFontOfSize:25.0];
    [bigCircleRootView addSubview:gearLabel];
    // 时间（55:55）
    CGFloat timeLabelW = 100;
    CGFloat timeLabelH = 40;
    CGFloat timeLabelX = bigCircleRootViewW/2 - timeLabelW/2;
    CGFloat timeLabelY = bigCircleRootViewH - 50 - timeLabelH;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.text = @"55:55";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:25.0];
    [bigCircleRootView addSubview:timeLabel];
    
    
    // ＋／START/－ 根视图
    CGFloat addStartSubtractRootViewMargingLeftRight = 40;
    CGFloat addStartSubtractRootViewX = addStartSubtractRootViewMargingLeftRight;
    CGFloat addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 50;
    CGFloat addStartSubtractRootViewW = kScreenWidth - 2*addStartSubtractRootViewMargingLeftRight;
    CGFloat addStartSubtractRootViewH = 100;
    UIView *addStartSubtractRootView = [[UIView alloc] initWithFrame:CGRectMake(addStartSubtractRootViewX, addStartSubtractRootViewY, addStartSubtractRootViewW, addStartSubtractRootViewH)];
    addStartSubtractRootView.backgroundColor = [UIColor redColor];
    [self.view addSubview:addStartSubtractRootView];
    // ＋
    CGFloat addButtonW = 50;
    CGFloat addButtonH = addButtonW;
    CGFloat addButtonX = 0;
    CGFloat addButtonY = 10;
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(addButtonX, addButtonY, addButtonW, addButtonH)];
    addButton.backgroundColor = [UIColor orangeColor];
    [addButton  addTarget:self action:@selector(addButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:addButton];
    // -
    CGFloat subtractButtonW = addButtonW;
    CGFloat subtractButtonH = addButtonH;
    CGFloat subtractButtonX = addStartSubtractRootViewW - subtractButtonW;
    CGFloat subtractButtonY = addButtonY;
    UIButton *subtractButton = [[UIButton alloc]initWithFrame:CGRectMake(subtractButtonX, subtractButtonY, subtractButtonW, subtractButtonH)];
    subtractButton.backgroundColor = [UIColor orangeColor];
    [subtractButton  addTarget:self action:@selector(subtractButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:subtractButton];
    // START
    CGFloat startButtonW = addStartSubtractRootViewH;
    CGFloat startButtonH = startButtonW;
    CGFloat startButtonX = addStartSubtractRootViewW/2 - startButtonW/2;
    CGFloat startButtonY = 0;
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH)];
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton  addTarget:self action:@selector(startButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:startButton];
    
    
    // 左胸
    CGFloat chestButtonMargingLeftRight = 30;
    CGFloat chestButtonW = 80;
    CGFloat chestButtonH = chestButtonW;
    CGFloat chestLabelW = chestButtonW;
    CGFloat chestLabelH = 30;
    CGFloat chestButtonY = kScreenHeight - chestLabelH - chestButtonH;
    UIButton *leftChestButton = [[UIButton alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, chestButtonY, chestButtonW, chestButtonH)];
    leftChestButton.backgroundColor = [UIColor orangeColor];
    [leftChestButton  addTarget:self action:@selector(leftChestButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: leftChestButton];
    UILabel *leftChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, kScreenHeight - chestLabelH, chestLabelW, chestLabelH)];
    leftChestLabel.textAlignment = NSTextAlignmentCenter;
    leftChestLabel.text = @"左胸";
    leftChestLabel.textColor = [UIColor redColor];
    [self.view addSubview:leftChestLabel];
    
    // 右胸
    UIButton *rightChestButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, chestButtonY, chestButtonW, chestButtonH)];
    rightChestButton.backgroundColor = [UIColor orangeColor];
    [rightChestButton  addTarget:self action:@selector(rightChestButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: rightChestButton];
    UILabel *rightChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, kScreenHeight - chestLabelH, chestLabelW, chestLabelH)];
    rightChestLabel.textAlignment = NSTextAlignmentCenter;
    rightChestLabel.text = @"右胸";
    rightChestLabel.textColor = [UIColor redColor];
    [self.view addSubview:rightChestLabel];
    
    
    
    
    
}


#pragma mark - 按钮点击事件

// +按钮点击
- (void)addButtonClick
{
    NSLog(@"addButtonClick");
}


// －按钮点击
- (void)subtractButtonClick
{
    NSLog(@"subtractButtonClick");
}

// START 按钮点击
- (void)startButtonClick
{
    NSLog(@"startButtonClick");
}

// 左胸按钮点击
- (void)leftChestButtonClick
{
    NSLog(@"leftChestButtonClick");
}

// 左胸按钮点击
- (void)rightChestButtonClick
{
    NSLog(@"rightChestButtonClick");
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
