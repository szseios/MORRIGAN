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
#import "BluetoothManager.h"
#import "RecordManager.h"
#import "MassageRecordModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


#define kTagOfDefault       0        // 默认按钮tag
#define kTagOfSoft          1000     // 轻柔按钮tag
#define kTagOfWater         1001     // 水波按钮tag
#define kTagOfMicroPress    1002     // 微按按钮tag
#define kTagOfStrongVibr    1003     // 强振按钮tag
#define kTagOfFeel          1004     // 动感按钮tag


#define kButtonStartTag     1005
#define kButtonStopTag      1006


@interface AutoKneadViewController ()
{
    NSArray *_topFiveButtonArray;
    
    UIButton *_buttonStartStop;
    FuntionButton *_dragButton;
    FuntionButton *_tempButton;
    UIButton *_curKneeding;
    UILabel *_prepareLabel;
    
    NSDate *_startDate;

    BOOL _preKneeding;   // 正在体验按摩
    NSTimer *_timer;     // 6s切换按摩方式定时器
}
@property (nonatomic , strong) NSTimer *backgroundTimer;

@end

@implementation AutoKneadViewController

- (void)viewDidLoad {
    
    
    [self viewInit];
    [super viewDidLoad];
    [self startBackgroundTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDisConnectHandlerInAutoKnead) name:DisconnectPeripheral object:nil];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopKneed];
    if(_backgroundTimer) {
        [_backgroundTimer invalidate];
        _backgroundTimer = nil;
    }
}


// 视图初始化
- (void)viewInit
{
    
    
    // 上面部分背景
    UIImageView *upBgView;
    if(kScreenHeight < 500) {
        // 4/ipa
        upBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/1.7)];
    } else {
        upBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    }
    upBgView.image = [UIImage imageNamed:@"auto_upBackground_before"];
    [self.view addSubview:upBgView];
    
    
    // 下面部分背景
    CGFloat downBgViewY = kScreenHeight/2 - 75;
    if(kScreenHeight > 700) {
        //6p
        downBgViewY = kScreenHeight/2 - 80;
    } else if(kScreenHeight < 570) {
        // 5s
        downBgViewY = kScreenHeight/2 - 63;
    }
    if(kScreenHeight < 500) {
        // 4/ipa
        downBgViewY = kScreenHeight/2 -10;
    }
    
    UIImageView *downBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, downBgViewY, kScreenWidth, kScreenHeight/3*2)];
    downBgView.image = [UIImage imageNamed:@"auto_downBackgrround"];
    [self.view addSubview:downBgView];
    
    // 返回按钮
    CGFloat backButtonW = 32.0;
    if(kScreenHeight < 570) {
        // 5s
        backButtonW = 32.0;
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 26, backButtonW, backButtonW)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonHandleInAutokneed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 标题
    CGFloat titleLabelY = 25.0;
    if(kScreenHeight < 570) {
        // 5s
        titleLabelY = 15.0;
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, titleLabelY, kScreenWidth - 200, 40)];
    titleLabel.text = @"自动按摩";
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    if(kScreenHeight < 570) {
        // 5s
        titleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 7.0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
//    // 连接蓝牙按钮
//    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 40, 26, backButtonW, backButtonW)];
//    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
//    [linkButton addTarget:self action:@selector(bindingDeviceInAutoKnead) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:linkButton];
    
    
    CGFloat buttonW = 60.0;
    if(kScreenHeight < 570) {
        // 5s
        buttonW = 50.0;
    }
    CGFloat buttonH = buttonW;
    CGFloat buttonX = (kScreenWidth - buttonW)/2;
    CGFloat buttonY = 65.0;
    if(kScreenHeight > 700) {
        //6p
        buttonY = 75.0;
    } else if(kScreenHeight < 570) {
        // 5s
        buttonY = 55.0;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    // 顶部一个按钮：按钮3
    FuntionButton *button3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button3 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    button3.funCodeString = @"00";
    [self.view addSubview:button3];

    buttonX = 60.0;
    if(kScreenHeight > 700) {
        //6p
        buttonX = 70.0;
    } else if(kScreenHeight < 570) {
        // 5s
        buttonX = 50.0;
    }
    buttonY = buttonY + 40.0;
    // 第二行左边按钮：按钮2
    FuntionButton *button2 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button2 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    button2.funCodeString = @"00";
    [self.view addSubview:button2];
    
    buttonX = kScreenWidth - 60.0 - buttonW;
    if(kScreenHeight > 700) {
        //6p
        buttonX = kScreenWidth - 70.0 - buttonW;
    } else if(kScreenHeight < 570) {
        // 5s
        buttonX = kScreenWidth - 50.0 - buttonW;
    }
    // 第二行右边按钮：按钮4
    FuntionButton *button4 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button4 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    button4.funCodeString = @"00";
    [self.view addSubview:button4];
    
    buttonX = 30.0;
    if(kScreenHeight < 570) {
        // 5s
        buttonX = 25.0;
    }
    if(kScreenHeight < 570) {
        // 5s
        buttonY = buttonY + 40.0 + 50.0;
    } else {
        buttonY = buttonY + 40.0 + 60.0;
    }
    // 第三行左边按钮：按钮1
    FuntionButton *button1 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button1 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    button1.funCodeString = @"00";
    [self.view addSubview:button1];
    
    buttonX = kScreenWidth - 30.0 - buttonW;
    if(kScreenHeight < 570) {
        // 5s
        buttonX = kScreenWidth - 30.0 - buttonW;
    }
    // 第三行右边按钮：按钮5
    FuntionButton *button5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button5 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    button5.funCodeString = @"00";
    [self.view addSubview:button5];
    
    
    button1.arrayIndex = 0;
    [tempArray addObject:button1];
    button2.arrayIndex = 1;
    [tempArray addObject:button2];
    button3.arrayIndex = 2;
    [tempArray addObject:button3];
    button4.arrayIndex = 3;
    [tempArray addObject:button4];
    button5.arrayIndex = 4;
    [tempArray addObject:button5];
    _topFiveButtonArray = tempArray;
    
    
    // 开始／停止按钮
    CGFloat startBtnW = 80;
    CGFloat startBtnY = button5.frame.origin.y + 20;
    if(kScreenHeight > 700) {
        //6p
        startBtnY = button5.frame.origin.y + 20.0 + 20;
    } else if(kScreenHeight < 570) {
        // 5s
        startBtnW = 70;
        startBtnY = button5.frame.origin.y - 20 + 30;
    }
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - startBtnW)/2, startBtnY, startBtnW, startBtnW)];
    [startBtn addTarget:self action:@selector(startBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.tag = kButtonStopTag;
    [startBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [self.view addSubview:startBtn];
    _buttonStartStop = startBtn;
    
    // 准备按摩吧!
    UILabel *prepareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startBtn.frame.origin.y - 40, kScreenWidth, 20)];
    prepareLabel.text = @"准备按摩吧!";
    prepareLabel.textAlignment = NSTextAlignmentCenter;
    prepareLabel.font = [UIFont systemFontOfSize:16.0];
    prepareLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:prepareLabel];
    _prepareLabel = prepareLabel;
    
    // 正在按摩的模式
    CGFloat curKneedingY = startBtn.frame.origin.y - 70;
    if(kScreenHeight > 700) {
        //6p
        curKneedingY = startBtn.frame.origin.y - 80;
    } else if(kScreenHeight < 570) {
        // 5s
        curKneedingY = startBtn.frame.origin.y - 50;
    }
    _curKneeding = [[UIButton alloc] initWithFrame:CGRectMake(startBtn.frame.origin.x + (startBtn.frame.size.width - buttonW)/2, curKneedingY, buttonW, buttonH)];
    [_curKneeding setImage:[UIImage imageNamed:@"icon-lightPress"] forState:UIControlStateNormal];
    [self.view addSubview:_curKneeding];
    _curKneeding.hidden = YES;
    
    // 向上拖动 任意模式按钮
    CGFloat label1H = 18;
    CGFloat label1Y = startBtn.frame.origin.y + startBtn.frame.size.height + 20;
    if(kScreenHeight < 500) {
        // 4/ipa
        label1Y = startBtn.frame.origin.y + startBtn.frame.size.height + 5;
    }
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
    if(kScreenHeight < 570) {
        // 5s
        buttonY = label2.frame.origin.y + label2.frame.size.height + 40;
    }
    if(kScreenHeight < 500) {
        // 4/ipa
        buttonY = label2.frame.origin.y + label2.frame.size.height + 5;
    }
    buttonX = margingLeftRight;
   
    // 轻柔（底部：1行－左）
    FuntionButton *funButton1 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton1.buttonImage = [UIImage imageNamed:@"soft"];
    funButton1.buttonBeenDrapImage = [UIImage imageNamed:@"select_soft"];
    funButton1.buttonKneedingImage = [UIImage imageNamed:@"icon-soft"];
    [funButton1 setImage:funButton1.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton1 addGestureRecognizer:panGestureRecognizer1];
    [funButton1 addTarget:self action:@selector(preKneedHandler:) forControlEvents:UIControlEventTouchUpInside];
    funButton1.tag = kTagOfSoft;
    funButton1.funCodeString = @"01";
    [self.view addSubview:funButton1];
    UILabel *labelLight = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelLight.text = @"轻柔";
    labelLight.textColor = [Utils stringTOColor:kColor_6911a5];
    labelLight.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelLight];
    
    buttonX = (kScreenWidth-buttonW)/2;
    // 水波（底部：1行－中）
    FuntionButton *funButton2 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton2.buttonImage = [UIImage imageNamed:@"warter"];
    funButton2.buttonBeenDrapImage = [UIImage imageNamed:@"select_warter"];
    funButton2.buttonKneedingImage = [UIImage imageNamed:@"icon-warter"];
    [funButton2 setImage:funButton2.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton2 addGestureRecognizer:panGestureRecognizer2];
    [funButton2 addTarget:self action:@selector(preKneedHandler:) forControlEvents:UIControlEventTouchUpInside];
    funButton2.tag = kTagOfWater;
    funButton2.funCodeString = @"02";
    [self.view addSubview:funButton2];
    UILabel *labelWater = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelWater.text = @"水波";
    labelWater.textColor = [Utils stringTOColor:kColor_6911a5];
    labelWater.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelWater];
    
    buttonX = kScreenWidth - margingLeftRight - buttonW;
    
    
    // 动感（底部：2行－右）
    FuntionButton *funButton5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton5.buttonImage = [UIImage imageNamed:@"movingFeel"];
    funButton5.buttonBeenDrapImage = [UIImage imageNamed:@"select_movingFeel"];
    funButton5.buttonKneedingImage = [UIImage imageNamed:@"icon-movingFeel"];
    [funButton5 setImage:funButton5.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton5 addGestureRecognizer:panGestureRecognizer5];
    [funButton5 addTarget:self action:@selector(preKneedHandler:) forControlEvents:UIControlEventTouchUpInside];
    funButton5.tag = kTagOfFeel;
    funButton5.funCodeString = @"05";
    [self.view addSubview:funButton5];
    UILabel *labelFeel = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelFeel.text = @"动感";
    labelFeel.textColor = [Utils stringTOColor:kColor_6911a5];
    labelFeel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelFeel];
    
    buttonY = funButton5.frame.origin.y + funButton5.frame.size.height + 50;
    if(kScreenHeight < 570) {
        // 5s
        buttonY = funButton5.frame.origin.y + funButton5.frame.size.height + 30;
    }
    buttonX = funButton1.frame.origin.x + funButton1.frame.size.width + ((funButton2.frame.origin.x - (funButton1.frame.origin.x + funButton1.frame.size.width))/2 - buttonW/2);
    
    // 微按（底部：1行－右）
    FuntionButton *funButton3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton3.buttonImage = [UIImage imageNamed:@"lightPress"];
    funButton3.buttonBeenDrapImage = [UIImage imageNamed:@"select_lightPress"];
    funButton3.buttonKneedingImage = [UIImage imageNamed:@"icon-lightPress"];
    [funButton3 setImage:funButton3.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton3 addGestureRecognizer:panGestureRecognizer3];
    [funButton3 addTarget:self action:@selector(preKneedHandler:) forControlEvents:UIControlEventTouchUpInside];
    funButton3.tag = kTagOfMicroPress;
    funButton3.funCodeString = @"03";
    [self.view addSubview:funButton3];
    UILabel *labelLittle = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelLittle.text = @"微按";
    labelLittle.textColor = [Utils stringTOColor:kColor_6911a5];
    labelLittle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelLittle];
    
    buttonX = funButton2.frame.origin.x + funButton2.frame.size.width + ((funButton5.frame.origin.x - (funButton2.frame.origin.x + funButton2.frame.size.width))/2 - buttonW/2);
    // 强振（底部：2行－左）
    FuntionButton *funButton4 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton4.buttonImage = [UIImage imageNamed:@"strongShake"];
    funButton4.buttonBeenDrapImage = [UIImage imageNamed:@"select_strongShake"];
    funButton4.buttonKneedingImage = [UIImage imageNamed:@"icon-strongShake"];
    [funButton4 setImage:funButton4.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton4 addGestureRecognizer:panGestureRecognizer4];
    [funButton4 addTarget:self action:@selector(preKneedHandler:) forControlEvents:UIControlEventTouchUpInside];
    funButton4.tag = kTagOfStrongVibr;
    funButton4.funCodeString = @"04";
    [self.view addSubview:funButton4];
    UILabel *labelStrong = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelStrong.text = @"强震";
    labelStrong.textColor = [Utils stringTOColor:kColor_6911a5];
    labelStrong.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelStrong];
    
    
    
    
    // 用于随意拖动的按钮
    _dragButton = [[FuntionButton alloc] initWithFrame:CGRectMake(50, buttonY, buttonW, buttonH)];
    [self.view addSubview:_dragButton];
    
    
}

// 按摩体验
- (void)preKneedHandler:(id)sender
{
    if(_preKneeding == YES ||  _buttonStartStop.tag == kButtonStartTag || ![UserInfo share].isConnected) {
        return;
    }
    
    FuntionButton *button = (FuntionButton *)sender;
    NSLog(@"tag: %ld, %@", button.tag, button.funCodeString);
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:@"02" index:4];
    [operation setValue:@"01" index:3];
    [operation setValue:button.funCodeString index:7];
    operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
        
    };
    [[BluetoothManager share] writeValueByOperation:operation];
    _preKneeding = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if(_buttonStartStop.tag == kButtonStopTag) {
            [self stopKneed];
        }
        
    });
}


// 更新按摩模式
- (void)updateMode
{
    [self stopKneed];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:@"02" index:4];
    [operation setValue:@"01" index:3];
    
    BOOL beenEnd = YES;
    for (NSInteger i = 0; i < _topFiveButtonArray.count; i++) {
        FuntionButton *button = _topFiveButtonArray[i];
        if(button.funCodeString == nil || [button.funCodeString isEqualToString:@"00"]) {
            button.funCodeString = @"00";
        }
        if(![button.funCodeString isEqualToString:@"00"]){
            if(i > _curKneeding.tag) {
                beenEnd = NO;
                _curKneeding.tag = i;
                NSLog(@"准备发送－－－－－－---------------- %ld, %@", _curKneeding.tag, button.funCodeString);
                [_curKneeding setImage:button.buttonKneedingImage forState:UIControlStateNormal];
                [operation setValue:button.funCodeString index:7];
                operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
                    
                };
                [[BluetoothManager share] writeValueByOperation:operation];
                break;
            }
        }
    }

    if(beenEnd) {
        _curKneeding.tag = -1;
        [self updateMode];
    }
    
}

- (void)dragReplyButton:(UIPanGestureRecognizer *)recognizer {
    
    
//    if(_preKneeding == YES) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在按摩，不能拖动" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        
//        return;
//    }
//
//    
//    if(_buttonStartStop.tag == kButtonStartTag) {
//        // [MBProgressHUD showHUDByContent:@"正在按摩，不能拖动！" view: self.view];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在按摩，不能拖动" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
    FuntionButton *targetButton = (FuntionButton *)recognizer.view;
    if(_preKneeding == NO) {
        if(targetButton != _dragButton) {
            _dragButton.hidden = NO;
            _dragButton.frame = targetButton.frame;
            [_dragButton addGestureRecognizer:recognizer];
            _dragButton.buttonImage = targetButton.buttonImage;
            _dragButton.buttonBeenDrapImage = targetButton.buttonBeenDrapImage;
            _dragButton.buttonKneedingImage = targetButton.buttonKneedingImage;
            _dragButton.funCodeString = targetButton.funCodeString;
            [_dragButton setImage:_dragButton.buttonImage forState:UIControlStateNormal];
            _dragButton.tag = targetButton.tag;
            [targetButton removeGestureRecognizer:recognizer];
            _tempButton = targetButton;
        }
        NSLog(@"-----%@", _dragButton.funCodeString);
    }
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(_buttonStartStop.tag == kButtonStartTag || _preKneeding == YES) {
            return;
        }
        [_tempButton addGestureRecognizer:recognizer];
        [_dragButton removeGestureRecognizer:recognizer];
        _dragButton.hidden = YES;
    }
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if(_buttonStartStop.tag == kButtonStartTag || _preKneeding == YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"正在按摩，不能拖动" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
       
        if(_buttonStartStop.tag == kButtonStartTag || _preKneeding == YES) {
            return;
        }
        
        CGPoint location = [recognizer locationInView:self.view];
        if (location.y < 0 || location.y > self.view.bounds.size.height) {
            return;
        }
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if(_buttonStartStop.tag == kButtonStartTag || _preKneeding == YES) {
            return;
        }
        
        CGFloat dragButtonX = _dragButton.frame.origin.x;
        CGFloat dragButtonY = _dragButton.frame.origin.y;
        CGFloat dragButtonW = _dragButton.frame.size.width;
        CGFloat dragButtonH = _dragButton.frame.size.height;
        
        for (FuntionButton *button in _topFiveButtonArray) {
            
            
            CGFloat x = button.frame.origin.x;
            CGFloat y = button.frame.origin.y;
            CGFloat w = button.frame.size.width;
            CGFloat h = button.frame.size.height;
          
            // 1.先计算离谁最近：|(dragButtonY + dragButtonH) - (y + h)|    +    |(dragButtonX + dragButtonW) - (x + w)|
            button.distanceFromDragButton = fabsf((dragButtonY + dragButtonH) - (y + h)) + fabsf((dragButtonX + dragButtonW) - (x + w));
            NSLog(@"排序前：%ld  %f", button.arrayIndex, button.distanceFromDragButton);
            
            
        }
        
        // 2.获取distanceFromDragButton最小的button
        NSArray *tempArray = [_topFiveButtonArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            FuntionButton *button1 = (FuntionButton *)obj1;
            FuntionButton *button2 = (FuntionButton *)obj2;
            if(button1.distanceFromDragButton < button2.distanceFromDragButton) {
                return NO;
            } else {
                return YES;
            }
        }];

        for (FuntionButton *button in tempArray) {
            NSLog(@"排序后：%ld  %f", button.arrayIndex, button.distanceFromDragButton);
        }
        
        // 3.判断该dragButton是否可以落到该地：|dragButtonY - y| < h  ||  |dragButtonX - x| < w   = result（YES:可以落地）
        FuntionButton *button = tempArray[0];
        CGFloat x = button.frame.origin.x;
        CGFloat y = button.frame.origin.y;
        CGFloat w = button.frame.size.width;
        CGFloat h = button.frame.size.height;
        if(fabsf(dragButtonY - y) < h || fabsf(dragButtonX - x) < w) {
            FuntionButton *newButton = [[FuntionButton alloc] initWithFrame:button.frame];
            // 如果该位置已经添加了，不允许重复添加
            if(button.tag == kTagOfDefault) {
                newButton.arrayIndex = button.arrayIndex;
                newButton.tag = _dragButton.tag;
                newButton.buttonImage = _dragButton.buttonImage;
                newButton.buttonBeenDrapImage = _dragButton.buttonBeenDrapImage;
                newButton.buttonKneedingImage = _dragButton.buttonKneedingImage;
                [newButton setImage:newButton.buttonBeenDrapImage forState:UIControlStateNormal];
                UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topFiveButtonGesture:)];
                [newButton addGestureRecognizer:panGestureRecognizer];
                [self.view addSubview:newButton];
                
                // 将顶部被添加的按钮设置tag，代表了一种按摩模式
                button.tag = _dragButton.tag;
                button.funCodeString = _dragButton.funCodeString;
                button.buttonKneedingImage = _dragButton.buttonKneedingImage;
            }
            
        }
        
    }
}

- (void)topFiveButtonGesture:(UIPanGestureRecognizer *)recognizer {
    
    if(_buttonStartStop.tag == kButtonStartTag) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint location = [recognizer locationInView:self.view];
        if (location.y < 0 || location.y > self.view.bounds.size.height) {
            return;
        }
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        FuntionButton *newButton = (FuntionButton *)recognizer.view;
        NSLog(@"%ld",newButton.arrayIndex);
        FuntionButton *button = _topFiveButtonArray[newButton.arrayIndex];
        if(fabsf(newButton.frame.origin.y - button.frame.origin.y) > newButton.frame.size.height || fabsf(newButton.frame.origin.x - button.frame.origin.x) > newButton.frame.size.width) {
            [newButton removeFromSuperview];
            button.tag = kTagOfDefault;
            button.funCodeString = @"00";
        } else {
            newButton.frame = button.frame;
        }
        
    }
}

- (void)startBtnHandler:(id)sender
{
    
    BOOL hasSelected = NO;
    for (FuntionButton *button in _topFiveButtonArray) {
        NSLog(@"-----当前按摩顺序----：：%ld  %ld  %@", button.arrayIndex, button.tag, button.funCodeString);
        if(button.funCodeString == nil || [button.funCodeString isEqualToString:@"00"]) {
            button.funCodeString = @"00";
            //[MBProgressHUD showHUDByContent:@"请添加自动按摩组合" view: self.view];
            //return;
        }
        if(![button.funCodeString isEqualToString:@"00"]){
            hasSelected = YES;
        }
    }


    // 必须选择一个
    if(hasSelected == NO) {
        [MBProgressHUD showHUDByContent:@"请先选择组合模式" view: self.view];
        return;
    }
    
    if (![UserInfo share].isConnected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先连接设备再来开始按摩吧" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(_buttonStartStop.tag == kButtonStopTag) {
        _buttonStartStop.tag = kButtonStartTag;
        [_buttonStartStop setImage:[UIImage imageNamed:@"STOP"] forState:UIControlStateNormal];
        _startDate = [NSDate date];
        
        _prepareLabel.hidden = YES;
        _curKneeding.hidden = NO;
        _curKneeding.tag = -1;
        
        [self startTimer];
        
    } else {
        _buttonStartStop.tag = kButtonStopTag;
        [_buttonStartStop setImage:[UIImage imageNamed:@"START"] forState:UIControlStateNormal];
        
        _prepareLabel.hidden = NO;
        _curKneeding.hidden = YES;
        
        [self stopTimer];
        [self stopKneed];
        
        // 插入数据库
        MassageRecordModel *model = [[MassageRecordModel alloc] init];
        model.userID = [UserInfo share].userId;
        model.startTime = _startDate;
        model.endTime = [NSDate date];
        model.type = MassageTypeAuto;
        [[RecordManager share] addToDB:model];
    }
}

- (void)bindingDeviceInAutoKnead
{
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)backButtonHandleInAutokneed
{
    [self stopTimer];
    [self stopKneed];
    
    [self bluetoothDisConnectHandlerInAutoKnead];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 停止按摩
- (void)stopKneed {
    
    _preKneeding = NO;
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:@"00" index:3];
    operation.response = ^(NSString *response,long tag,NSError *error,BOOL success) {
        
    };
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (void)bluetoothDisConnectHandlerInAutoKnead
{
    if(_buttonStartStop.tag == kButtonStartTag) {
  
        _prepareLabel.hidden = NO;
        _curKneeding.hidden = YES;
        
        [self stopTimer];
        [self stopKneed];
        _buttonStartStop.tag = kButtonStopTag;
        [_buttonStartStop setImage:[UIImage imageNamed:@"START"] forState:UIControlStateNormal];
       
        // 插入数据库
        MassageRecordModel *model = [[MassageRecordModel alloc] init];
        model.userID = [UserInfo share].userId;
        model.startTime = _startDate;
        model.endTime = [NSDate date];
        model.type = MassageTypeAuto;
        [[RecordManager share] addToDB:model];
    }

}


- (void)startTimer
{
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateMode) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTimer
{
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)startBackgroundTimer
{
    if(_backgroundTimer) {
        [_backgroundTimer invalidate];
        _backgroundTimer = nil;
    }
    _backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getData) userInfo:nil repeats:YES];
}

- (void)getData
{
    [[RecordManager share] getStarRank];
    
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
