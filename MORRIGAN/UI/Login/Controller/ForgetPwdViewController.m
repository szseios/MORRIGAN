//
//  找回密码界面
//
//  ForgetPwdViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "NMOANetWorking.h"
#import "UserInfo.h"
#import "LoginManager.h"
#import "Utils.h"



#define kManButtonTag     1001
#define kWomanButtonTag   1002

#define kAlertViewTagOfConfirmPhoneNumber  2001
#define kAlertViewTagOfIntoLogin           2002

#define kgetAuthCodeButtonOfGetting     3001
#define kgetAuthCodeButtonOfNormal      3002


@interface ForgetPwdViewController () <UIAlertViewDelegate>
{
    UITextField *_phoneNumbrInputView;
    UITextField *_authCodeInputView;
    UIButton *_getAuthCodeButton;
    UITextField *_passwordInputView;
    UIButton *_showPwdButton;
    
    UIAlertView *remoteAlertView;
    NSTimer *_getAuthCodeTimer;
    NSInteger _currentSec;
}

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化视图
    [self initView];

}


- (void)initView
{

    // 键盘收起条
    UIToolbar * keyboardTopView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [keyboardTopView setBarStyle:UIBarStyleDefault];
    keyboardTopView.backgroundColor = [UIColor whiteColor];
    keyboardTopView.alpha = 0.9;
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 1, 50, 28);
    [btn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"  收起" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    btn.alpha = 0.6;
    // btn.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [keyboardTopView setItems:buttonsArray];
    
    
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    rootView.backgroundColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:rootView];
    self.rootScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.rootScroolView addSubview:rootView];
    self.rootScroolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.rootScroolView.scrollEnabled = NO;
    [self.view addSubview:self.rootScroolView];
    
    
    // 上半部分视图
    CGFloat imageViewH = 434/2.0;
    if(kScreenHeight < 570) {
        // 5s
        imageViewH = 434/2.5;
    }

    UIView *topRootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
    //topRootView.backgroundColor = [UIColor redColor];
    topRootView.backgroundColor = [Utils stringTOColor:kColor_440067];
    [rootView addSubview:topRootView];
    // 取消按钮
    CGFloat cancleBtnY = 25.0;
    if(kScreenHeight < 570) {
        // 5s
        cancleBtnY = 20.0;
    }
    CGFloat cancleBtnW = 40.0;
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, cancleBtnY, cancleBtnW, cancleBtnW)];
    //cancleBtn.backgroundColor = [UIColor blueColor];
    [cancleBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [cancleBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancleButtonClickInForgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [topRootView addSubview:cancleBtn];
    // 忘记密码
    CGFloat labelView1Y = cancleBtnY + cancleBtnW;
    CGFloat labelView1H = 30.0;
    UILabel *labelView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y, kScreenWidth, labelView1H)];
    labelView1.text = @"忘记密码";
    labelView1.textColor = [UIColor whiteColor];
    labelView1.textAlignment = NSTextAlignmentCenter;
    labelView1.font = [UIFont boldSystemFontOfSize:20.0];
    [topRootView addSubview:labelView1];
    // 输入您的手机号，获取验证码方可修改密码，密码修改成功后，要牢记哦
    CGFloat labelView2H = 20.0;
    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(20, labelView1Y + labelView1H, kScreenWidth - 20*2, labelView2H)];
    labelView2.text = @" 输入您的手机号,获取验证码方可修改密码,密码修改成功后,要牢记哦";
    labelView2.numberOfLines = 0;
    [labelView2 sizeToFit];
    labelView2.textColor = [UIColor whiteColor];
    labelView2.textAlignment = NSTextAlignmentCenter;
    labelView2.font = [UIFont systemFontOfSize:15.0];
    [topRootView addSubview:labelView2];

    
    UIColor *inputViewTextColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3];
    // 手机号
    CGFloat editViewPaddingTop = 50.0;
    CGFloat editViewPaddingLeftRight = 30.0;
    CGFloat editViewH = 44.0;
    CGFloat editViewW = kScreenWidth - editViewPaddingLeftRight * 2;
    UIView *phoneNumRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop, editViewW, editViewH)];
    phoneNumRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:phoneNumRootView];
    // 手机图标
    CGFloat iconW = 25.0;
    UIImageView *phoneIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (editViewH - iconW)/2, iconW, iconW)];
    //phoneIconView.backgroundColor = [UIColor orangeColor];
    phoneIconView.image = [UIImage imageNamed:@"ic_mobile"];
    [phoneNumRootView addSubview:phoneIconView];
    // 手机输入框
    CGFloat phoneinputViewPaddingLeft = 5.0;
    UITextField *phoneInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, phoneNumRootView.frame.size.width - iconW - phoneinputViewPaddingLeft, editViewH)];
    //phoneInputView.backgroundColor = [UIColor greenColor];
    phoneInputView.placeholder = @"请填写手机号码";
    [phoneInputView setInputAccessoryView:keyboardTopView];
    // 注意：先设置phoneInputView.placeholder才有效
    [phoneInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneInputView.textColor = [UIColor whiteColor];
    _phoneNumbrInputView = phoneInputView;
    [phoneNumRootView addSubview:phoneInputView];
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    lineView.alpha = 0.1;
    [phoneNumRootView addSubview:lineView];
    
    
    
    // 验证码
    CGFloat authCodeViewPaddingTop = 10.0;
    UIView *authCodeRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + authCodeViewPaddingTop, editViewW, editViewH)];
    authCodeRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:authCodeRootView];
    // 验证码图标
    UIImageView *authCodeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (editViewH - iconW)/2, iconW, iconW)];
    //authCodeIconView.backgroundColor = [UIColor orangeColor];
    authCodeIconView.image = [UIImage imageNamed:@"ic_authcode"];
    [authCodeRootView addSubview:authCodeIconView];
    // 获取验证码
    CGFloat getAuthCodeViewW = 120.0;
    UIButton *getAuthCodeView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - getAuthCodeViewW + 3 , 0, getAuthCodeViewW, editViewH)];
    //getAuthCodeView.backgroundColor = [UIColor blueColor];
    [getAuthCodeView addTarget:self action:@selector(getAuthCodeButtonClickInForgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [getAuthCodeView setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAuthCodeView.alpha = 0.6;
    _getAuthCodeButton = getAuthCodeView;
    _getAuthCodeButton.tag = kgetAuthCodeButtonOfNormal;
    [authCodeRootView addSubview:getAuthCodeView];
    // 垂直分割线
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(editViewW - getAuthCodeViewW, 0, 1.0, editViewH - 5)];
    verticalLine.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    verticalLine.alpha = 0.1;
    [authCodeRootView addSubview:verticalLine];
    
    // 验证码输入框
    UITextField *authCodeInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, authCodeRootView.frame.size.width - iconW - getAuthCodeViewW - phoneinputViewPaddingLeft, editViewH)];
    //authCodeInputView.backgroundColor = [UIColor greenColor];
    authCodeInputView.placeholder = @"输入验证码";
    [authCodeInputView setInputAccessoryView:keyboardTopView];
    [authCodeInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    authCodeInputView.textColor = [UIColor whiteColor];
    _authCodeInputView = authCodeInputView;
    [authCodeRootView addSubview:authCodeInputView];
    // 分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView2.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    lineView2.alpha = 0.1;
    [authCodeRootView addSubview:lineView2];
    
    
    // 密码
    CGFloat PWDeditViewPaddingTop = 10.0;
    UIView *PWDRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + authCodeViewPaddingTop + editViewH  + PWDeditViewPaddingTop, editViewW, editViewH)];
    PWDRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:PWDRootView];
    // 密码图标
    UIImageView *PWDIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (editViewH - iconW)/2, iconW, iconW)];
    //PWDIconView.backgroundColor = [UIColor orangeColor];
    PWDIconView.image = [UIImage imageNamed:@"ic_pwd"];
    [PWDRootView addSubview:PWDIconView];
    // 显示密码按钮
    CGFloat showPWDViewW = 30.0;
    UIButton *showPWDView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - showPWDViewW , (editViewH - showPWDViewW)/2, showPWDViewW, showPWDViewW)];
    //showPWDView.backgroundColor = [UIColor blueColor];
    [showPWDView addTarget:self action:@selector(showPWDButtonClickInRegister) forControlEvents:UIControlEventTouchUpInside];
    _showPwdButton = showPWDView;
    [_showPwdButton setImage:[UIImage imageNamed:@"ic_show_pwd_off"] forState:UIControlStateNormal];
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    //PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"输入密码";
    [PWDInputView setInputAccessoryView:keyboardTopView];
    [PWDInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    PWDInputView.textColor = [UIColor whiteColor];
    PWDInputView.secureTextEntry = YES;
    _passwordInputView = PWDInputView;
    [PWDRootView addSubview:PWDInputView];
    // 分割线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView3.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    lineView3.alpha = 0.1;
    [PWDRootView addSubview:lineView3];
    
    
    
    // 底部确定按钮
    CGFloat okBtnRootViewH = 44.0;
    CGFloat okBtnRootViewW = editViewW;
    CGFloat okBtnRootViewX = editViewPaddingLeftRight;
    CGFloat okBtnRootViewY = kScreenHeight - 100.0 - okBtnRootViewH;
    UIView *okBtnRootView = [[UIView alloc]initWithFrame:CGRectMake(okBtnRootViewX, okBtnRootViewY, okBtnRootViewW, okBtnRootViewH)];
    okBtnRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:okBtnRootView];
    // 确定
    CGFloat buttonW = okBtnRootViewW;
    UIButton *okBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, okBtnRootViewH)];
    [okBtnView setTitle:@"完成" forState:UIControlStateNormal];
    okBtnView.backgroundColor = [UIColor clearColor];
    [okBtnView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8]forState:UIControlStateNormal];
    [okBtnView addTarget:self action:@selector(okButtonClickInForgetPwdSetBg:) forControlEvents:UIControlEventTouchDown];
    [okBtnView addTarget:self action:@selector(okButtonClickInForgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 0.8 });
    [okBtnView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [okBtnView.layer setBorderWidth:1.0]; //边框宽度
    [okBtnView.layer setBorderColor:colorref];//边框颜色
    [okBtnRootView addSubview:okBtnView];

    
    
}

#pragma mark - 按钮点击处理

// 获取验证码按钮点击
- (void)getAuthCodeButtonClickInForgetPwd:(id)sender
{
    NSLog(@"getAuthCodeButtonClickInForgetPwd");
    
    if(_getAuthCodeButton.tag == kgetAuthCodeButtonOfGetting){
        return;
    }
    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    
    if(phoneNumber && phoneNumber.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(!isPhoneNumberRight) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的手机号码有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:phoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = kAlertViewTagOfConfirmPhoneNumber;
    [alert show];
}

// 显示密码按钮点击
- (void)showPWDButtonClickInRegister
{
    NSLog(@"showPWDButtonClickInRegister");
    _passwordInputView.secureTextEntry = !_passwordInputView.secureTextEntry;
    //_showPwdButton.backgroundColor = _passwordInputView.secureTextEntry ? [UIColor blueColor] : [UIColor redColor];
    [_showPwdButton setImage:[UIImage imageNamed:_passwordInputView.secureTextEntry ?@"ic_show_pwd_off" : @"ic_show_pwd_on"] forState:UIControlStateNormal];
    
}

// 取消按钮点击
- (void)cancleButtonClickInForgetPwd
{
    [self.navigationController popViewControllerAnimated:NO];
}

// 完成按钮点击（改变背景色）
- (void)okButtonClickInForgetPwdSetBg:(id)sender
{
    NSLog(@"okButtonClickInForgetPwd");
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [Utils stringTOColor:kColor_440067];
}


// 完成按钮点击
- (void)okButtonClickInForgetPwd:(id)sender
{
    NSLog(@"okButtonClickInForgetPwd");
    
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor clearColor];
    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    NSString *authCode = _authCodeInputView.text;
    NSString *password = _passwordInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    BOOL isPasswordRight = [Utils checkPassWord: password];
    BOOL isauthCodeRight = [Utils checkAuthCode: authCode];
    
    // 校验
    if(phoneNumber && phoneNumber.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(!isPhoneNumberRight) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的手机号码有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    
    if(password && password.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(!isPasswordRight) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码格式有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(authCode && authCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if(!isauthCodeRight) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码格式错误，请重新填写" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    // 更改密码
    [self beginResetPwd:phoneNumber authCode:authCode password:password];
}




#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if(alertView.tag == kAlertViewTagOfIntoLogin) {
                
                
            }

        }
            break;
            
        case 1:
        {
            if(alertView.tag == kAlertViewTagOfConfirmPhoneNumber) {
               
                // 获取手机验证码
                [self getPhoneMsgCode];
                
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - other

// 获取手机验证码
- (void)getPhoneMsgCode
{
    NSDictionary *dictionary = @{@"mobile":_phoneNumbrInputView.text};
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_GET_PHONE_MSG_CODE
                              urlString:URL_GET_PHONE_MSG_CODE
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             
             NSLog(@"获取验证码成功！");
             [self startTimer];
             
         } else {
             
             NSLog(@"获取验证码失败！");
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
         
     }];
}


- (void)getAuthCodeTimerHander
{
    NSLog(@"getAuthCodeTimerHander");
    _currentSec --;
    if(_currentSec == 0) {
        [self stopTimer];
    } else {
        [_getAuthCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_currentSec] forState:UIControlStateNormal];
    }
    
}

- (void)startTimer
{
    _getAuthCodeButton.tag = kgetAuthCodeButtonOfGetting;
    _currentSec = 60;
    [_getAuthCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_currentSec] forState:UIControlStateNormal];
    
    if(_getAuthCodeTimer) {
        [_getAuthCodeTimer invalidate];
        _getAuthCodeTimer = nil;
    }
    _getAuthCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getAuthCodeTimerHander) userInfo:nil repeats:YES];
}


- (void)stopTimer
{
    [_getAuthCodeTimer invalidate];
    _getAuthCodeTimer = nil;
    _getAuthCodeButton.tag = kgetAuthCodeButtonOfNormal;
    _currentSec = 0;
    [_getAuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}


// 重置密码
- (void)beginResetPwd:(NSString *)phoneNumber authCode:(NSString *)authCode password:(NSString *)password
{
    [self stopTimer];
    
    [self remoteAnimation:@"正在重置密码, 请稍候..."];
    
    NSLog(@"重置密码，手机：%@, 验证码：%@, 密码：%@", phoneNumber, authCode, password);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber,
                                 @"msgCode": authCode,
                                 @"newPsw": password
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_RESET_PWD
                              urlString:URL_RESET_PWD
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
         });
         
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"重置密码成功！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [obj objectForKey:HTTP_KEY_RESULTMESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             alert.tag = kAlertViewTagOfIntoLogin;
             [alert show];
             
         } else {
             NSLog(@"重置密码失败！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重置密码失败!" message: [obj objectForKey:HTTP_KEY_RESULTMESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alert show];
         }
         
     }];
    
    
}


-(void)remoteAnimation:(NSString *)message{
    
    if (remoteAlertView) {
        remoteAlertView = nil;
    }
    remoteAlertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil ];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 80.0, 30.0, 30.0)];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    aiView.color = [UIColor blackColor];
    [remoteAlertView setValue:aiView forKey:@"accessoryView"];
    [remoteAlertView show];
    [aiView startAnimating];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
