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
    BOOL _animationStarting;            // 动画已启动
    
    NSDate *_startDate;
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
    
    
    
    // 圆环1
    UIImageView *circle1 = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 70, kScreenWidth+20, kScreenWidth+20)];
    circle1.alpha = 0;
    circle1.image = [UIImage imageNamed:@"line_circle_3"];
    [self.view addSubview:circle1];
    _circle1 = circle1;
    // 圆环2
    UIImageView *circle2 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20, 70 + 20, kScreenWidth-20, kScreenWidth-20)];
    circle2.image = [UIImage imageNamed:@"line_circle_3"];
    circle2.alpha = 0;
    [self.view addSubview:circle2];
    _circle2 = circle2;
    // 圆环3
    UIImageView *circle3 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20 + 20, 70 + 20 + 20, kScreenWidth-20 - 20*2, kScreenWidth-20-20*2)];
    circle3.image = [UIImage imageNamed:@"line_circle_3"];
    circle3.alpha = 0;
    [self.view addSubview:circle3];
    _circle3 = circle3;
    // 圆环4
    UIImageView *circle4 = [[UIImageView alloc] initWithFrame:CGRectMake(-10 + 20 + 20 + 20, 70 + 20 + 20 + 20, kScreenWidth-20 - 20*2 - 20*2, kScreenWidth-20-20*2 - 20*2)];
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
    CGFloat timeLabelW = 100;
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
    timeLabel.font = [UIFont boldSystemFontOfSize:25.0];
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
    UIButton *leftChestButton = [[UIButton alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, chestButtonY, chestButtonW, chestButtonH)];
    //leftChestButton.backgroundColor = [UIColor orangeColor];
    leftChestButton.tag = kButtonSelectedTag;
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateNormal];
    [leftChestButton setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateHighlighted];
    [leftChestButton  addTarget:self action:@selector(leftChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: leftChestButton];
    _leftChestButton = leftChestButton;
    UILabel *leftChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(chestButtonMargingLeftRight, kScreenHeight - chestLabelH - 30, chestLabelW, chestLabelH)];
    leftChestLabel.textAlignment = NSTextAlignmentCenter;
    leftChestLabel.text = @"左胸";
    leftChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:leftChestLabel];
    
    // 右胸
    UIButton *rightChestButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, chestButtonY, chestButtonW, chestButtonH)];
    //rightChestButton.backgroundColor = [UIColor orangeColor];
    rightChestButton.tag = kButtonSelectedTag;
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateNormal];
    [rightChestButton setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateHighlighted];
    [rightChestButton  addTarget:self action:@selector(rightChestButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: rightChestButton];
    _rightChestButton = rightChestButton;
    UILabel *rightChestLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - chestButtonMargingLeftRight - chestButtonW, kScreenHeight - chestLabelH - 30, chestLabelW, chestLabelH)];
    rightChestLabel.textAlignment = NSTextAlignmentCenter;
    rightChestLabel.text = @"右胸";
    rightChestLabel.textColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:rightChestLabel];

    
}


- (void)startAnimation
{
    _animationStarting = YES;
    
    
    CGFloat tempTime = (kDelayTime - kDelayTimeEnd) / 4;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimation1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tempTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimation2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tempTime * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimation3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tempTime * 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimation4];
    });

}

- (void)stopAnimation {
    _animationStarting = NO;
}


- (void)startAnimation1 {
    
    __weak HandKneadViewController *weakSelf = self;
    CGRect frame1 = _circle1.frame;
    _circle1.alpha = 0;
    _circle1.frame = _bigCircleRootView.frame;
    
   
    [UIView animateWithDuration:kDelayTime animations:^{
        _circle1.alpha = 1.0;
        _circle1.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDelayTimeEnd animations:^{
            _circle1.alpha = 0;
        } completion:^(BOOL finished) {
            if(_animationStarting) [weakSelf startAnimation1];
        }];
        
    }];

}

- (void)startAnimation2 {
    
    __weak HandKneadViewController *weakSelf = self;
    CGRect frame1 = _circle1.frame;
    _circle2.alpha = 0;
    _circle2.frame = _bigCircleRootView.frame;


    [UIView animateWithDuration:kDelayTime animations:^{
        _circle2.alpha = 1.0;
        _circle2.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDelayTimeEnd animations:^{
            _circle2.alpha = 0;
        } completion:^(BOOL finished) {
            if(_animationStarting) [weakSelf startAnimation2];
        }];
        
    }];

}

- (void)startAnimation3 {
    
    __weak HandKneadViewController *weakSelf = self;
    CGRect frame1 = _circle1.frame;
    _circle3.alpha = 0;
    _circle3.frame = _bigCircleRootView.frame;
    
    [UIView animateWithDuration:kDelayTime animations:^{
        _circle3.alpha = 1.0;
        _circle3.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDelayTimeEnd animations:^{
            _circle3.alpha = 0;
        } completion:^(BOOL finished) {
            if(_animationStarting) [weakSelf startAnimation3];
        }];
        
    }];
    
    
}


- (void)startAnimation4 {
    
    __weak HandKneadViewController *weakSelf = self;
    CGRect frame1 = _circle1.frame;
    _circle4.alpha = 0;
    _circle4.frame = _bigCircleRootView.frame;
        
    [UIView animateWithDuration:kDelayTime animations:^{
        _circle4.alpha = 1.0;
        _circle4.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDelayTimeEnd animations:^{
            _circle4.alpha = 0;
        } completion:^(BOOL finished) {
            if(_animationStarting) [weakSelf startAnimation4];
        }];
        
    }];
    
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
    
    
    if (![BluetoothManager share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"蓝牙未连接，请先连接设备再来按摩吧" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
    }

}

- (void)updateLeftRightChestState:(BOOL)isLeftChest button:(UIButton *)button
{
    if(isLeftChest) {
        // 左胸
        if(button.tag == kButtonUnselectedTag) {
            button.tag = kButtonSelectedTag;
            [button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"leftBreast"] forState:UIControlStateHighlighted];
            
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
            [button setImage:[UIImage imageNamed:@"leftBreast_highlight"] forState:UIControlStateHighlighted];
        }
    } else {
        // 右胸
        if(button.tag == kButtonUnselectedTag) {
            button.tag = kButtonSelectedTag;
            [button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"rightBreast"] forState:UIControlStateHighlighted];
            
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
            [button setImage:[UIImage imageNamed:@"rightBreast_higlight"] forState:UIControlStateHighlighted];
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
    [_timer fire];
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
