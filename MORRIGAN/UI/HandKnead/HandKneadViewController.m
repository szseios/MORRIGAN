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
#import "Utils.h"

#define kButtonUnselectedTag     1000
#define kButtonSelectedTag       2000


#define kButtonStartTag         1000
#define kButtonStopTag          2000

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
    // 下面部分背景
    UIImageView *downBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight/3*2, kScreenWidth, kScreenHeight/3)];
    downBgView.image = [UIImage imageNamed:@"hand_backgroud"];
    [self.view addSubview:downBgView];
   
    // 上面部分背景
    UIImageView *upBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 20)];
    upBgView.image = [UIImage imageNamed:@"hand_upBackground"];
    [self.view addSubview:upBgView];

    
    // 返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 26, 42, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonHandleInHandkneed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 25, kScreenWidth - 200, 40)];
    titleLabel.text = @"手动按摩";
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 7.0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // 连接蓝牙按钮
    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 40, 26, 45, 45)];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateHighlighted];
    [self.view addSubview:linkButton];
    
    
    
    // 圆环1
    UIImageView *circle1 = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 70, kScreenWidth+20, kScreenWidth+20)];
    circle1.image = [UIImage imageNamed:@"line_circle_4"];
    [self.view addSubview:circle1];
    // 圆环2
    UIImageView *circle2 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20, 70 + 20, kScreenWidth-20, kScreenWidth-20)];
    circle2.image = [UIImage imageNamed:@"line_circle_3"];
    [self.view addSubview:circle2];
    // 圆环3
    UIImageView *circle3 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20 + 20, 70 + 20 + 20, kScreenWidth-20 - 20*2, kScreenWidth-20-20*2)];
    circle3.image = [UIImage imageNamed:@"line_circle_2"];
    [self.view addSubview:circle3];
    // 圆环4
    UIImageView *circle4 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20 + 20 + 20, 70 + 20 + 20 + 20, kScreenWidth-20 - 20*2 - 20*2, kScreenWidth-20-20*2 - 20*2)];
    circle4.image = [UIImage imageNamed:@"line_circle_1"];
    [self.view addSubview:circle4];

    
    // 波纹动画
//    CABasicAnimation *theAnimation;
//    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    theAnimation.duration=2.0;
//    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
//    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
//    [circle4.layer addAnimation:theAnimation forKey:@"animateOpacity"];
//     [circle3.layer addAnimation:theAnimation forKey:@"animateOpacity"];
//     [circle2.layer addAnimation:theAnimation forKey:@"animateOpacity"];
//     [circle1.layer addAnimation:theAnimation forKey:@"animateOpacity"];
//    [NSTimer scheduledTimerWithTimeInterval:theAnimation.duration
//                                     target:self
//                                   selector:@selector(targetMethod)
//                                   userInfo:nil
//                                    repeats:NO];
    
    
    
    
    // 大圆圈根视图
    CGFloat bigCircleRootViewX = circle4.frame.origin.x + 15;
    CGFloat bigCircleRootViewY = circle4.frame.origin.y + 15;
    CGFloat bigCircleRootViewW = circle4.frame.size.width - 30;
    CGFloat bigCircleRootViewH = bigCircleRootViewW;
    UIImageView *bigCircleRootView = [[UIImageView alloc] initWithFrame:CGRectMake(bigCircleRootViewX, bigCircleRootViewY, bigCircleRootViewW, bigCircleRootViewH)];
    //bigCircleRootView.backgroundColor = [UIColor redColor];
    bigCircleRootView.image = [UIImage imageNamed:@"roundCircleBackgroud"];
    [self.view addSubview:bigCircleRootView];
    // gear大数字
    CGFloat gearNumLabelW = 70;
    CGFloat gearNumLabelH = 90;
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabelH = 70;
        gearNumLabelW = 60;
    }
    CGFloat gearNumLabelX = bigCircleRootViewW/2 - gearNumLabelW;
    CGFloat gearNumLabelY = bigCircleRootViewW/2 - gearNumLabelH;
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabelX = bigCircleRootViewW/2 - gearNumLabelW + 10;
        gearNumLabelY = bigCircleRootViewW/2 - gearNumLabelH + 15;
    }
    UILabel *gearNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(gearNumLabelX, gearNumLabelY, gearNumLabelW, gearNumLabelH)];
    gearNumLabel.text = @"3";
    gearNumLabel.textColor = [UIColor whiteColor];
    gearNumLabel.font = [UIFont italicSystemFontOfSize:100.0];
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabel.font = [UIFont italicSystemFontOfSize:70.0];
    }
    [bigCircleRootView addSubview:gearNumLabel];
    // gear
    CGFloat gearLabelW = 80;
    CGFloat gearLabelH = 40;
    CGFloat gearLabelX = gearNumLabelX + gearNumLabelW + 20;
    if(kScreenHeight < 570) {
        // 5s
        gearLabelX = gearNumLabelX + gearNumLabelW;
    }
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
    if(kScreenHeight < 570) {
        // 5s
        timeLabelY = bigCircleRootViewH - 15 - timeLabelH;
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.text = @"55:55";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:25.0];
    [bigCircleRootView addSubview:timeLabel];
    
    
    // ＋／START/－ 根视图
    CGFloat addStartSubtractRootViewMargingLeftRight = 40;
    CGFloat addStartSubtractRootViewX = addStartSubtractRootViewMargingLeftRight;
    CGFloat addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 80;
    if(kScreenHeight < 570) {
        // 5s
       addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 72;
    }
    CGFloat addStartSubtractRootViewW = kScreenWidth - 2*addStartSubtractRootViewMargingLeftRight;
    CGFloat addStartSubtractRootViewH = 120;
    if(kScreenHeight > 700) {
        //6p
        addStartSubtractRootViewH = 140;
    } else if(kScreenHeight < 570) {
        // 5s
        addStartSubtractRootViewH = 80;
    }
    UIView *addStartSubtractRootView = [[UIView alloc] initWithFrame:CGRectMake(addStartSubtractRootViewX, addStartSubtractRootViewY, addStartSubtractRootViewW, addStartSubtractRootViewH)];
    //addStartSubtractRootView.backgroundColor = [UIColor redColor];
    [self.view addSubview:addStartSubtractRootView];
    // ＋
    CGFloat addButtonW = 80;
    if(kScreenHeight < 570) {
        // 5s
        addButtonW = 60;
    }
    CGFloat addButtonH = addButtonW;
    CGFloat addButtonX = 0;
    CGFloat addButtonY = 0;
    if(kScreenHeight > 700) {
        //6p
        addButtonY = 10;
    }
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(addButtonX, addButtonY, addButtonW, addButtonH)];
    //addButton.backgroundColor = [UIColor orangeColor];
    [addButton setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"add_click"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:addButton];
    // -
    CGFloat subtractButtonW = addButtonW;
    CGFloat subtractButtonH = addButtonH;
    CGFloat subtractButtonX = addStartSubtractRootViewW - subtractButtonW;
    CGFloat subtractButtonY = addButtonY;
    UIButton *subtractButton = [[UIButton alloc]initWithFrame:CGRectMake(subtractButtonX, subtractButtonY, subtractButtonW, subtractButtonH)];
    //subtractButton.backgroundColor = [UIColor orangeColor];
    [subtractButton setImage:[UIImage imageNamed:@"remove_normal"] forState:UIControlStateNormal];
    [subtractButton setImage:[UIImage imageNamed:@"remove_click"] forState:UIControlStateHighlighted];
    [subtractButton  addTarget:self action:@selector(subtractButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:subtractButton];
    // START
    CGFloat startButtonW = addStartSubtractRootViewH;
    if(kScreenHeight < 570) {
        // 5s
        startButtonW = addStartSubtractRootViewH - 20;
    }
    CGFloat startButtonH = startButtonW;
    CGFloat startButtonX = addStartSubtractRootViewW/2 - startButtonW/2;
    CGFloat startButtonY = (addStartSubtractRootViewH - startButtonH) / 2;
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH)];
    //startButton.backgroundColor = [UIColor orangeColor];
    startButton.tag = kButtonStartTag;
    [startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [startButton  addTarget:self action:@selector(startButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [addStartSubtractRootView addSubview:startButton];
    
    
    // 左胸
    CGFloat chestButtonMargingLeftRight = 30;
    if(kScreenHeight < 570) {
        // 5s
        chestButtonMargingLeftRight = 50;
    }

    CGFloat chestButtonW = 80;
    if(kScreenHeight < 570) {
        // 5s
        chestButtonW = 50;
    }
    CGFloat chestButtonH = chestButtonW;
    CGFloat chestLabelW = chestButtonW;
    CGFloat chestLabelH = 30;
    CGFloat chestButtonY = kScreenHeight - chestLabelH - chestButtonH - 10;
    UIButton *leftChestButton = [[UIButton alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, chestButtonY, chestButtonW, chestButtonH)];
    //leftChestButton.backgroundColor = [UIColor orangeColor];
    leftChestButton.tag = kButtonUnselectedTag;
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateNormal];
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateHighlighted];
    [leftChestButton  addTarget:self action:@selector(leftChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: leftChestButton];
    UILabel *leftChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, kScreenHeight - chestLabelH - 10, chestLabelW, chestLabelH)];
    leftChestLabel.textAlignment = NSTextAlignmentCenter;
    leftChestLabel.text = @"左胸";
    leftChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:leftChestLabel];
    
    // 右胸
    UIButton *rightChestButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, chestButtonY, chestButtonW, chestButtonH)];
    //rightChestButton.backgroundColor = [UIColor orangeColor];
    rightChestButton.tag = kButtonUnselectedTag;
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateNormal];
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast_highlight"] forState:UIControlStateHighlighted];
    [rightChestButton  addTarget:self action:@selector(rightChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: rightChestButton];
    UILabel *rightChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, kScreenHeight - chestLabelH - 10, chestLabelW, chestLabelH)];
    rightChestLabel.textAlignment = NSTextAlignmentCenter;
    rightChestLabel.text = @"右胸";
    rightChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
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
- (void)startButtonClick:(id)sender
{
    NSLog(@"startButtonClick");
    
    UIButton *button = (UIButton *)sender;
    if(button.tag == kButtonStartTag) {
        button.tag = kButtonStopTag;
        [button setImage:[UIImage imageNamed:@"STOP"] forState:UIControlStateNormal];
        
    } else if(button.tag == kButtonStopTag) {
        button.tag = kButtonStartTag;
        [button setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    }
}

// 左胸按钮点击
- (void)leftChestButtonClick:(id)sender
{
    NSLog(@"leftChestButtonClick");
    
    UIButton *button = (UIButton *)sender;
    if(button.tag == kButtonUnselectedTag) {
        button.tag = kButtonSelectedTag;
        [button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateHighlighted];
        
    } else if(button.tag == kButtonSelectedTag) {
        button.tag = kButtonUnselectedTag;
        [button setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateHighlighted];
    }
}

// 左胸按钮点击
- (void)rightChestButtonClick:(id)sender
{
    NSLog(@"rightChestButtonClick");
    
    UIButton *button = (UIButton *)sender;
    if(button.tag == kButtonUnselectedTag) {
        button.tag = kButtonSelectedTag;
        [button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateHighlighted];

    } else if(button.tag == kButtonSelectedTag) {
        button.tag = kButtonUnselectedTag;
        [button setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateHighlighted];
    }
    
}


- (void)backButtonHandleInHandkneed
{
    [self.navigationController popViewControllerAnimated:YES];
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