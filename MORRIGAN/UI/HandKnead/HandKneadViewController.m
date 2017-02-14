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
#import "RecordManager.h"

#define kButtonUnselectedTag     1000
#define kButtonSelectedTag       2000


#define kButtonStartTag         1000
#define kButtonStopTag          2000

#define kDelayTime              4.0
#define kDelayTimeEnd           1.5

@interface HandKneadViewController ()
{
    UIImageView *_circle1;
    UIImageView *_circle2;
    UIImageView *_circle3;
    UIImageView *_circle4;
    UIImageView *_bigCircleRootView;
    UILabel *_gearNumLabel;            // 档位显示label
    UILabel *_timeLabel;               // 计时显示label
    UIButton *_startButton;            // 开始／停止按钮
    UIButton *_leftChestButton;        // 左胸按钮
    UIButton *_rightChestButton;       // 右胸按钮
    
    NSInteger _currentStartStop;       // 当前开关（01：开  00:关）
    NSInteger _currentGear;            // 当前档位（0x01~0x03，手动模式有效）
    NSInteger _currentLeftRightChest;  // 当前左右（0x00:左右同时  0x01:左  0x02:右， 手动模式有效）
    
    NSTimer *_timer;                    // 计时器
    NSInteger _currentTime;             // 当前计时时间
    
    NSDate *_startDate;
    
    NSTimer *animation1Timer;
    NSTimer *animation2Timer;
    NSTimer *animation3Timer;
    NSTimer *animation4Timer;
    
}

@end



@implementation HandKneadViewController

- (void)viewDidLoad {
    
    // 设置默认值
    _currentStartStop = 0;
    _currentGear = 1;
    _currentLeftRightChest = 0;
    
    
    [self viewInit];
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDisConnectHandlerInHandkneed) name:DisconnectPeripheral object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundHandler:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundHandler:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if(_currentStartStop == 1) {
        [self startAnimation];
        
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(_currentStartStop == 1) {
        [self stopAnimation];
    }
}

// 进入后台
- (void)enterBackgroundHandler:(UIApplication *)application {
    if(_currentStartStop == 1) {
        [self stopAnimation];
    }
}

// 进入前台
- (void)enterForegroundHandler:(UIApplication *)application {
    if(_currentStartStop == 1) {
        [self startAnimation];

    }
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
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 26, 32, 32)];
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
    
//    // 连接蓝牙按钮
//    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 40, 26, 45, 45)];
//    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
//    [linkButton addTarget:self action:@selector(bindingDeviceInHandkneed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:linkButton];
    
    
    CGFloat circle1X = -10;
    CGFloat circle1Y = 70;
    CGFloat circleSpace = 20;
    if(kScreenHeight < 500) {
        // 4/pad
        circle1X = 30;
        circle1Y = 70;
        circleSpace = 10;
    }
    
    // 圆环1
    UIImageView *circle1 = [[UIImageView alloc] initWithFrame:CGRectMake(circle1X, circle1Y, kScreenWidth-circle1X*2, kScreenWidth-circle1X*2)];

    circle1.alpha = 0;
    circle1.image = [UIImage imageNamed:@"line_circle_3"];
    [self.view addSubview:circle1];
    _circle1 = circle1;
    // 圆环2
    UIImageView *circle2 = [[UIImageView alloc] initWithFrame:CGRectMake(circle1X + circleSpace, circle1Y + circleSpace, kScreenWidth-(circle1X + circleSpace)*2, kScreenWidth-(circle1X + circleSpace)*2)];
    circle2.image = [UIImage imageNamed:@"line_circle_3"];
    circle2.alpha = 0;
    [self.view addSubview:circle2];
    _circle2 = circle2;
    // 圆环3
    UIImageView *circle3 = [[UIImageView alloc] initWithFrame:CGRectMake(circle1X + circleSpace + circleSpace, circle1Y + circleSpace + circleSpace, kScreenWidth-(circle1X + circleSpace + circleSpace)*2, kScreenWidth-(circle1X + circleSpace + circleSpace)*2)];
    circle3.image = [UIImage imageNamed:@"line_circle_3"];
    circle3.alpha = 0;
    [self.view addSubview:circle3];
    _circle3 = circle3;
    // 圆环4
    UIImageView *circle4 = [[UIImageView alloc] initWithFrame:CGRectMake(circle1X + circleSpace + circleSpace + circleSpace, circle1Y + circleSpace + circleSpace + circleSpace, kScreenWidth-(circle1X + circleSpace + circleSpace + circleSpace)*2, kScreenWidth-(circle1X + circleSpace + circleSpace + circleSpace)*2)];
    circle4.image = [UIImage imageNamed:@"line_circle_3"];
    circle4.alpha = 0;
    [self.view addSubview:circle4];
    _circle4 = circle4;
    

    
    
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
    _bigCircleRootView = bigCircleRootView;
    // gear大数字
    CGFloat gearNumLabelW = 70;
    CGFloat gearNumLabelH = 120;
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabelH = 90;
        gearNumLabelW = 60;
    }
    CGFloat gearNumLabelX = bigCircleRootViewW/2 - gearNumLabelW + 10;
    CGFloat gearNumLabelY = bigCircleRootViewW/2 - gearNumLabelH + 30;
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabelX = bigCircleRootViewW/2 - gearNumLabelW + 10;
        gearNumLabelY = bigCircleRootViewW/2 - gearNumLabelH + 25;
    }
    UILabel *gearNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(gearNumLabelX, gearNumLabelY, gearNumLabelW, gearNumLabelH)];
    gearNumLabel.text = @"1";
    gearNumLabel.textColor = [UIColor whiteColor];
    gearNumLabel.font = [UIFont italicSystemFontOfSize:110.0];
    if(kScreenHeight < 570) {
        // 5s
        gearNumLabel.font = [UIFont italicSystemFontOfSize:90.0];
    }
    [bigCircleRootView addSubview:gearNumLabel];
    _gearNumLabel = gearNumLabel;
    // gear
    CGFloat gearLabelW = 80;
    CGFloat gearLabelH = 40;
    CGFloat gearLabelX = gearNumLabelX + gearNumLabelW ;
    CGFloat gearLabelY = gearNumLabelY + gearNumLabelH - gearLabelH - 10;
    if(kScreenHeight < 570) {
        // 5s
        gearLabelX = gearNumLabelX + gearNumLabelW;
        gearLabelY = gearNumLabelY + gearNumLabelH - gearLabelH - 5;
    }
    
    UILabel *gearLabel = [[UILabel alloc] initWithFrame:CGRectMake(gearLabelX, gearLabelY, gearLabelW, gearLabelH)];
    gearLabel.text = @"gear";
    gearLabel.textColor = [UIColor whiteColor];
    gearLabel.font = [UIFont italicSystemFontOfSize:25.0];
    [bigCircleRootView addSubview:gearLabel];
    
    // 时间（55:55）
    CGFloat timeLabelW = 120;
    CGFloat timeLabelH = 40;
    CGFloat timeLabelX = bigCircleRootViewW/2 - timeLabelW/2;
    CGFloat timeLabelY = bigCircleRootViewH - 30 - timeLabelH;
    if(kScreenHeight < 570) {
        // 5s
        timeLabelY = bigCircleRootViewH - 15 - timeLabelH;
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    timeLabel.text = @"00:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:30.0];
    [bigCircleRootView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    
    // ＋／START/－ 根视图
    CGFloat addStartSubtractRootViewMargingLeftRight = 40;
    CGFloat addStartSubtractRootViewX = addStartSubtractRootViewMargingLeftRight;
    CGFloat addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 75;
    if(kScreenHeight < 570) {
        // 5s
       addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 67;
    }
    
    if(kScreenHeight < 500) {
        // 4/ipa
        addStartSubtractRootViewY = bigCircleRootViewY + bigCircleRootViewH + 60;
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
    CGFloat startButtonW = 120;
    if(kScreenHeight < 570) {
        // 5s
        startButtonW = 120 - 20;
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
    _startButton = startButton;
    
    
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
    CGFloat chestLabelH = 20;
    CGFloat chestButtonY = kScreenHeight - chestLabelH - chestButtonH - 30;
    if(kScreenHeight < 500) {
        // 4/ipa
        chestButtonY = kScreenHeight - chestLabelH - chestButtonH - 5;
    }
    UIButton *leftChestButton = [[UIButton alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, chestButtonY, chestButtonW, chestButtonH)];
    //leftChestButton.backgroundColor = [UIColor orangeColor];
    leftChestButton.tag = kButtonSelectedTag;
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateNormal];
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast_click"] forState:UIControlStateHighlighted];
    [leftChestButton  addTarget:self action:@selector(leftChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: leftChestButton];
    _leftChestButton = leftChestButton;
    CGFloat labelY = kScreenHeight - chestLabelH - 30;
    if(kScreenHeight < 500) {
        // 4/ipa
        labelY = kScreenHeight - chestLabelH - 5;
    }
    UILabel *leftChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, labelY, chestLabelW, chestLabelH)];
    leftChestLabel.textAlignment = NSTextAlignmentCenter;
    leftChestLabel.text = @"左胸";
    leftChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:leftChestLabel];
    
    // 右胸
    UIButton *rightChestButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, chestButtonY, chestButtonW, chestButtonH)];
    //rightChestButton.backgroundColor = [UIColor orangeColor];
    rightChestButton.tag = kButtonSelectedTag;
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateNormal];
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast_click"] forState:UIControlStateHighlighted];
    [rightChestButton  addTarget:self action:@selector(rightChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: rightChestButton];
    _rightChestButton = rightChestButton;
    UILabel *rightChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, labelY, chestLabelW, chestLabelH)];
    rightChestLabel.textAlignment = NSTextAlignmentCenter;
    rightChestLabel.text = @"右胸";
    rightChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:rightChestLabel];

    [self startAnimation];
    
}


- (void)startAnimation
{
    CGFloat tempTime = kDelayTime / 4;
//    animation1Timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self startAnimation1];
//    }];
    
    
    CGFloat time1 = 0.1;
    if(_currentGear == 1) {
        time1 = time1/1;
    } else if(_currentGear == 2) {
        time1 = time1/3;
    } else if(_currentGear == 3) {
        time1 = time1/6;
    }
    animation1Timer = [NSTimer scheduledTimerWithTimeInterval:time1
                                                       target:self
                                                     selector:@selector(startAnimation1)
                                                     userInfo:nil
                                                      repeats:NO];
    
//    animation2Timer = [NSTimer scheduledTimerWithTimeInterval:tempTime * 1 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self startAnimation2];
//    }];
    CGFloat time2 = 1;
    if(_currentGear == 1) {
        time2 = time2/1;
    } else if(_currentGear == 2) {
        time2 = time2/3;
    } else if(_currentGear == 3) {
        time2 = time2/6;
    }
    animation2Timer = [NSTimer scheduledTimerWithTimeInterval:time2
                                                       target:self
                                                     selector:@selector(startAnimation2)
                                                     userInfo:nil
                                                      repeats:NO];
    
//    animation3Timer = [NSTimer scheduledTimerWithTimeInterval:tempTime * 2 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self startAnimation3];
//    }];
    
    
    CGFloat time3 = 2;
    if(_currentGear == 1) {
        time3 = time2/1;
    } else if(_currentGear == 2) {
        time3 = time2/3;
    } else if(_currentGear == 3) {
        time3 = time2/6;
    }
    animation3Timer = [NSTimer scheduledTimerWithTimeInterval:time3
                                                       target:self
                                                     selector:@selector(startAnimation3)
                                                     userInfo:nil
                                                      repeats:NO];
    
//    animation4Timer = [NSTimer scheduledTimerWithTimeInterval:tempTime * 3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self startAnimation4];
//    }];
    
    CGFloat time4 = 3;
    if(_currentGear == 1) {
        time4 = time4/1;
    } else if(_currentGear == 2) {
        time4 = time4/3;
    } else if(_currentGear == 3) {
        time4 = time4/6;
    }
    animation4Timer = [NSTimer scheduledTimerWithTimeInterval:time4
                                                       target:self
                                                     selector:@selector(startAnimation4)
                                                     userInfo:nil
                                                      repeats:NO];


}

- (void)stopAnimation {

    [_circle1.layer removeAllAnimations];
    [_circle2.layer removeAllAnimations];
    [_circle3.layer removeAllAnimations];
    [_circle4.layer removeAllAnimations];
    
    if(animation1Timer) {
        [animation1Timer invalidate];
        animation1Timer = nil;
    }
    
    if(animation2Timer) {
        [animation2Timer invalidate];
        animation2Timer = nil;
    }
    
    if(animation3Timer) {
        [animation3Timer invalidate];
        animation3Timer = nil;
    }
    
    if(animation4Timer) {
        [animation4Timer invalidate];
        animation4Timer = nil;
    }
}


- (void)startAnimation1 {
    
    [self createAnimation:_circle1 time:kDelayTime];
}

- (void)startAnimation2 {
    
     [self createAnimation:_circle2 time:kDelayTime];
}

- (void)startAnimation3 {
    
     [self createAnimation:_circle3 time:kDelayTime];
}


- (void)startAnimation4 {
    
    [self createAnimation:_circle4 time:kDelayTime];
}


- (void)createAnimation:(UIImageView *)view time:(CGFloat)time
{
    view.alpha = 1.0;
    view.frame = _bigCircleRootView.frame;
    
    // 缩放动画
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.values = @[@(1.0), @(1.2), @(1.4), @(1.6)];
    scaleAnimation.keyTimes = @[@(0), @(0.33), @(0.66), @(1)];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = YES;
    // 渐变动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.1];
    // 动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];

    if(_currentGear == 1) {
        time = time/1;
    } else if(_currentGear == 2) {
        time = time/3;
    } else if(_currentGear == 3) {
        time = time/6;
    }
    
    animationGroup.duration = time;
    animationGroup.autoreverses = NO;        //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound; //HUGE_VALF
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, opacityAnimation, nil]];
    //将上述两个动画编组，同时执行
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
}


#pragma mark - 按钮点击事件

// +按钮点击
- (void)addButtonClick
{
    NSLog(@"addButtonClick");

    _currentGear ++;
    if(_currentGear > 3) {
        [MBProgressHUD showHUDByContent:@"当前已经是最高档位" view: self.view];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前已经是最高档位" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        _currentGear = 3;
    }
    _gearNumLabel.text = [NSString stringWithFormat:@"%ld", _currentGear];
    

    [self sendData];
    
    if(_currentStartStop == 1) {
        [self stopAnimation];
        [self startAnimation];
    }

}


// －按钮点击
- (void)subtractButtonClick
{
    NSLog(@"subtractButtonClick");

    _currentGear --;
    if(_currentGear <= 0) {
        _currentGear = 1;
        [MBProgressHUD showHUDByContent:@"当前已经是最低档位" view: self.view];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前已经是最低档位" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
    _gearNumLabel.text = [NSString stringWithFormat:@"%ld", _currentGear];
    
    [self sendData];
    
    if(_currentStartStop == 1) {
        [self stopAnimation];
        [self startAnimation];
    }

}

// START 按钮点击
- (void)startButtonClick:(id)sender
{
    NSLog(@"startButtonClick");
    
    
//    // 测试上传护理记录
//    MassageRecordModel *model1 = [[MassageRecordModel alloc] init];
//    model1.userID = [UserInfo share].userId;
//    model1.startTime = [NSDate dateWithTimeIntervalSince1970:1479347400]; // 9:50
//    model1.endTime = [NSDate dateWithTimeIntervalSince1970:1479348600];   // 10:10
//    model1.type = MassageTypeAuto;
//    [[RecordManager share] addToDB:model1];
//
////    MassageRecordModel *model2 = [[MassageRecordModel alloc] init];
////    model2.userID = [UserInfo share].userId;
////    model2.startTime = [NSDate dateWithTimeIntervalSince1970:1479261000]; // 9:50
////    model2.endTime = [NSDate dateWithTimeIntervalSince1970:1479262200];   // 10:10
////    model2.type = MassageTypeManual;
////    [[RecordManager share] addToDB:model2];
//    return;
    
//    
//    MassageRecordModel *model1 = [[MassageRecordModel alloc] init];
//    model1.userID = [UserInfo share].userId;
//    model1.startTime = [NSDate dateWithTimeIntervalSince1970:1479946200]; // 8:10
//    model1.endTime = [NSDate dateWithTimeIntervalSince1970:1479957000];   // 11:10
//    model1.type = MassageTypeAuto;
//    [[RecordManager share] addToDB:model1];
//    return;
    
    
    if (![UserInfo share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先连接设备再来开始按摩吧" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [self updateStartStopState:_startButton];
   
    [self sendData];
    
}

// 左胸按钮点击
- (void)leftChestButtonClick:(id)sender
{
    NSLog(@"leftChestButtonClick");

    
    [self updateLeftRightChestState:YES button:(UIButton *)sender];
    
    [self sendData];

}

// 左胸按钮点击
- (void)rightChestButtonClick:(id)sender
{
    NSLog(@"rightChestButtonClick");

    [self updateLeftRightChestState:NO button:(UIButton *)sender];
    
    if(_currentGear == 0) {
        _currentGear = 1;
    }
    
    NSString *startStopStr = [NSString stringWithFormat:@"0%ld", _currentStartStop];
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currentGear];
    NSString *leftRightChestStr = [NSString stringWithFormat:@"0%ld", _currentLeftRightChest];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:startStopStr index:3];
    [operation setValue:@"01" index:4];
    [operation setValue:gearStr index:5];
    [operation setValue:leftRightChestStr index:6];
    operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
        
    };
    [[BluetoothManager share] writeValueByOperation:operation];

    
    
}

- (void)updateStartStopState:(UIButton *)button
{
    if(button.tag == kButtonStartTag) {
        button.tag = kButtonStopTag;
        [button setImage:[UIImage imageNamed:@"STOP"] forState:UIControlStateNormal];
        _currentStartStop = 1;
        
        // 重启定时器
        [self startTimer];
        // 开启动画
        [self startAnimation];
        
        _startDate = [NSDate date];
        
        
    } else if(button.tag == kButtonStopTag) {
        button.tag = kButtonStartTag;
        [button setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        _currentStartStop = 0;
        
        // 停止计时
        [self stopTimer];
        // 取消动画
        [self stopAnimation];
        
        // 插入数据库
        MassageRecordModel *model = [[MassageRecordModel alloc] init];
        model.userID = [UserInfo share].userId;
        model.startTime = _startDate;
        model.endTime = [NSDate date];
        model.type = MassageTypeManual;
        [[RecordManager share] addToDB:model];
        
        _timeLabel.text = @"00:00";
        _currentTime = 0;
    }

}

- (void)updateLeftRightChestState:(BOOL)isLeftChest button:(UIButton *)button
{
    if(isLeftChest) {
        // 左胸
        if(button.tag == kButtonUnselectedTag) {
            button.tag = kButtonSelectedTag;
            [button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateNormal];
            // [button setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateHighlighted];
            
        } else if(button.tag == kButtonSelectedTag) {
            if(_rightChestButton.tag == kButtonUnselectedTag) {
                //[MBProgressHUD showHUDByContent:@"左胸和右胸必须选中一个" view:self.view];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步操作开关至少一个被选中" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                [MBProgressHUD showHUDByContent:@"同步操作开关至少一个被选中" view: self.view];
                return;
            }
            button.tag = kButtonUnselectedTag;
            [button setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateNormal];
            //[button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateHighlighted];
        }
    } else {
        // 右胸
        if(button.tag == kButtonUnselectedTag) {
            button.tag = kButtonSelectedTag;
            [button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateNormal];
            //[button setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateHighlighted];
            
        } else if(button.tag == kButtonSelectedTag) {
            if(_leftChestButton.tag == kButtonUnselectedTag) {
                //[MBProgressHUD showHUDByContent:@"左胸和右胸必须选中一个" view:self.view];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"左胸和右胸必须选中一个!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
                [MBProgressHUD showHUDByContent:@"同步操作开关至少一个被选中" view: self.view];
                return;
            }
            button.tag = kButtonUnselectedTag;
            [button setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateNormal];
            //[button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateHighlighted];
        }
        
    }
    
    
    if(_leftChestButton.tag == kButtonSelectedTag && _rightChestButton.tag == kButtonSelectedTag) {
        _currentLeftRightChest = 0;
    } else if(_leftChestButton.tag == kButtonSelectedTag) {
        _currentLeftRightChest = 1;
    } else if(_rightChestButton.tag == kButtonSelectedTag) {
        _currentLeftRightChest = 2;
    }
}

- (void)sendData
{
    
    NSString *startStopStr = [NSString stringWithFormat:@"0%ld", _currentStartStop];
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currentGear];
    NSString *leftRightChestStr = [NSString stringWithFormat:@"0%ld", _currentLeftRightChest];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:startStopStr index:3];
    [operation setValue:@"01" index:4];
    [operation setValue:gearStr index:5];
    [operation setValue:leftRightChestStr index:6];
    operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
        
    };
    [[BluetoothManager share] writeValueByOperation:operation];
}


- (void)startTimer
{
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    //[_timer fire];
}

- (void)stopTimer
{
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)timerHandler
{
    _currentTime ++;
    
    NSString *minStr = @"";
    NSString *secStr = @"";
    NSInteger min = _currentTime / 60;
    NSInteger sec = _currentTime % 60;
    if(min < 10) {
        minStr = [NSString stringWithFormat:@"0%ld",min];
    } else if(min < 60) {
        minStr = [NSString stringWithFormat:@"%ld",min];
    }
    if(sec < 10) {
        secStr = [NSString stringWithFormat:@"0%ld",sec];
    } else if(sec < 60) {
        secStr = [NSString stringWithFormat:@"%ld",sec];
    }
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@", minStr, secStr];
    NSLog(@"timeStr----- %@", timeStr);
    _timeLabel.text = timeStr;
}

- (void)bindingDeviceInHandkneed
{
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)backButtonHandleInHandkneed
{
    
    // 退出时停止
    _currentStartStop = 0;
    [self sendData];
    
    [self bluetoothDisConnectHandlerInHandkneed];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)bluetoothDisConnectHandlerInHandkneed
{
    if(_startButton.tag == kButtonStopTag) {
        
        _startButton.tag = kButtonStartTag;
        [_startButton setImage:[UIImage imageNamed:@"START"] forState:UIControlStateNormal];
        
        // 停止计时
        [self stopTimer];
        // 取消动画
        [self stopAnimation];
     
        
        // 插入数据库
        MassageRecordModel *model = [[MassageRecordModel alloc] init];
        model.userID = [UserInfo share].userId;
        model.startTime = _startDate;
        model.endTime = [NSDate date];
        model.type = MassageTypeAuto;
        [[RecordManager share] addToDB:model];
    }
    _timeLabel.text = @"00:00";
    _currentTime = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
