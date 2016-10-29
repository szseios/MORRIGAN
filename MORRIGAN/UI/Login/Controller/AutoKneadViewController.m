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
{
    FuntionButton *_dragButton;
    FuntionButton *_tempButton;

}

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
    CGFloat backButtonW = 42.0;
    if(kScreenHeight < 570) {
        // 5s
        backButtonW = 35.0;
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 26, backButtonW, backButtonW)];
    [backButton setImage:[UIImage imageNamed:@"ic_backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"ic_backButton"] forState:UIControlStateHighlighted];
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
    
    // 设置按钮
    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 40, 26, backButtonW, backButtonW)];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
    [linkButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateHighlighted];
    [self.view addSubview:linkButton];
    
    
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
    // 顶部一个按钮：按钮3
    FuntionButton *button3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button3 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
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
    [self.view addSubview:button1];
    
    buttonX = kScreenWidth - 30.0 - buttonW;
    if(kScreenHeight < 570) {
        // 5s
        buttonX = kScreenWidth - 30.0 - buttonW;
    }
    // 第三行右边按钮：按钮5
    FuntionButton *button5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button5 setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.view addSubview:button5];
    
    // 开始／停止按钮
    CGFloat startBtnW = 70.0;
    CGFloat startBtnY = button5.frame.origin.y + 30.0;
    if(kScreenHeight > 700) {
        //6p
        startBtnY = button5.frame.origin.y + 50.0;
    } else if(kScreenHeight < 570) {
        // 5s
        startBtnY = button5.frame.origin.y + 20.0;
    }
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
    if(kScreenHeight < 570) {
        // 5s
        buttonY = label2.frame.origin.y + label2.frame.size.height + 40;
    }
    buttonX = margingLeftRight;
    // 轻柔（底部：1行－左）
    FuntionButton *funButton1 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton1.buttonImage = [UIImage imageNamed:@"soft"];
    [funButton1 setImage:funButton1.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton1 addGestureRecognizer:panGestureRecognizer1];
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
    [funButton2 setImage:funButton2.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton2 addGestureRecognizer:panGestureRecognizer2];
    [self.view addSubview:funButton2];
    UILabel *labelWater = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelWater.text = @"水波";
    labelWater.textColor = [Utils stringTOColor:kColor_6911a5];
    labelWater.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelWater];
    
    buttonX = kScreenWidth - margingLeftRight - buttonW;
    // 微按（底部：1行－右）
    FuntionButton *funButton3 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton3.buttonImage = [UIImage imageNamed:@"lightPress"];
    [funButton3 setImage:funButton3.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton3 addGestureRecognizer:panGestureRecognizer3];
    [self.view addSubview:funButton3];
    UILabel *labelLittle = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelLittle.text = @"微按";
    labelLittle.textColor = [Utils stringTOColor:kColor_6911a5];
    labelLittle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelLittle];
    
    buttonY = funButton3.frame.origin.y + funButton3.frame.size.height + 50;
    if(kScreenHeight < 570) {
        // 5s
        buttonY = funButton3.frame.origin.y + funButton3.frame.size.height + 30;
    }
    buttonX = funButton1.frame.origin.x + funButton1.frame.size.width + ((funButton2.frame.origin.x - (funButton1.frame.origin.x + funButton1.frame.size.width))/2 - buttonW/2);
    // 强振（底部：2行－左）
    FuntionButton *funButton4 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton4.buttonImage = [UIImage imageNamed:@"strongShake"];
    [funButton4 setImage:funButton4.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton4 addGestureRecognizer:panGestureRecognizer4];
    [self.view addSubview:funButton4];
    UILabel *labelStrong = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelStrong.text = @"强振";
    labelStrong.textColor = [Utils stringTOColor:kColor_6911a5];
    labelStrong.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelStrong];
    
    buttonX = funButton2.frame.origin.x + funButton2.frame.size.width + ((funButton3.frame.origin.x - (funButton2.frame.origin.x + funButton2.frame.size.width))/2 - buttonW/2);
    // 动感（底部：2行－右）
    FuntionButton *funButton5 = [[FuntionButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    funButton5.buttonImage = [UIImage imageNamed:@"movingFeel"];
    [funButton5 setImage:funButton5.buttonImage forState:UIControlStateNormal];
    UIPanGestureRecognizer *panGestureRecognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [funButton5 addGestureRecognizer:panGestureRecognizer5];
    [self.view addSubview:funButton5];
    UILabel *labelFeel = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, buttonY + buttonH + 10, buttonW, 20)];
    labelFeel.text = @"动感";
    labelFeel.textColor = [Utils stringTOColor:kColor_6911a5];
    labelFeel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelFeel];
    
    // 用于随意拖动的按钮
    _dragButton = [[FuntionButton alloc] initWithFrame:CGRectMake(50, buttonY, buttonW, buttonH)];
    [self.view addSubview:_dragButton];
    
    
}


- (void)dragReplyButton:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    
    FuntionButton *targetButton = (FuntionButton *)recognizer.view;
    if(targetButton != _dragButton) {
        _dragButton.hidden = NO;
        _dragButton.frame = targetButton.frame;
        [_dragButton addGestureRecognizer:recognizer];
        [_dragButton setImage:targetButton.buttonImage forState:UIControlStateNormal];
        [targetButton removeGestureRecognizer:recognizer];
        _tempButton = targetButton;
    }
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_tempButton addGestureRecognizer:recognizer];
        [_dragButton removeGestureRecognizer:recognizer];
        _dragButton.hidden = YES;
    }
    
    
    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint location = [recognizer locationInView:self];
//        
//        if (location.y < 0 || location.y > self.bounds.size.height) {
//            return;
//        }
//        CGPoint translation = [recognizer translationInView:self];
//        
//        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
//        [recognizer setTranslation:CGPointZero inView:self];
//        
//    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
//        CGRect currentFrame = self.addReplyView.frame;
//        
//        if (currentFrame.origin.x < 0) {
//            currentFrame.origin.x = 0;
//            if (currentFrame.origin.y < 0) {
//                currentFrame.origin.y = 4;
//            } else if ((currentFrame.origin.y + currentFrame.size.height) > self.bounds.size.height) {
//                currentFrame.origin.y = self.bounds.size.height - currentFrame.size.height;
//            }
//            [UIView animateWithDuration:0.5 animations:^{
//                self.addReplyView.frame = currentFrame;
//            }];
//            return;
//        }
//        if ((currentFrame.origin.x + currentFrame.size.width) > self.bounds.size.width) {
//            currentFrame.origin.x = self.bounds.size.width - currentFrame.size.width;
//            if (currentFrame.origin.y < 0) {
//                currentFrame.origin.y = 4;
//            } else if ((currentFrame.origin.y + currentFrame.size.height) > self.bounds.size.height) {
//                currentFrame.origin.y = self.bounds.size.height - currentFrame.size.height;
//            }
//            [UIView animateWithDuration:0.5 animations:^{
//                self.addReplyView.frame = currentFrame;
//            }];
//            return;
//        }
//        if (currentFrame.origin.y < 0) {
//            currentFrame.origin.y = 4;
//            [UIView animateWithDuration:0.5 animations:^{
//                self.addReplyView.frame = currentFrame;
//            }];
//            return;
//        }
//        if ((currentFrame.origin.y + currentFrame.size.height) > self.bounds.size.height) {
//            currentFrame.origin.y = self.bounds.size.height - currentFrame.size.height;
//            [UIView animateWithDuration:0.5 animations:^{
//                self.addReplyView.frame = currentFrame;
//            }];
//            return;
//        }
//    }
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
