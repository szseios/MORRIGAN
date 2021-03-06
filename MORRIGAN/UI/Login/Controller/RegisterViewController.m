//
//  注册界面
//
//  RegisterViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RegisterViewController.h"
#import "NMOANetWorking.h"
#import "UserInfo.h"
#import "LoginManager.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "LoginBaseController.h"



#define kManButtonTag     1001
#define kWomanButtonTag   1002

#define kAlertViewTagOfConfirmPhoneNumber  2001
#define kAlertViewTagOfIntoLogin           2002


#define kgetAuthCodeButtonOfGetting     3001
#define kgetAuthCodeButtonOfNormal      3002


@interface RegisterViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{

    NSString *_sexString;
    UIButton *_manButton;
    UIButton *_womanButton;
    UITextField *_phoneNumbrInputView;
    UITextField *_authCodeInputView;
    UIButton *_getAuthCodeButton;
    UITextField *_passwordInputView;
    UIButton *_showPwdButton;
    UIButton *_cleanUpButton;
    
    NSTimer *_getAuthCodeTimer;
    NSInteger _currentSec;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化视图
    [self initView];
    
    
    // 默认性别：男
    _sexString = @"F";
    [self updateSelectSexState];

}


- (void)initView
{
    [super initView];
    
//    // 性别选择
//    CGFloat imageViewH = 270.0;
//    if(kScreenHeight < 570) {
//        // 5s
//        imageViewH = 270.0 - 70;
//    }
//    UIView *sexRootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
//    sexRootView.backgroundColor = [Utils stringTOColor:kColor_440067];
//    [self.rootView addSubview:sexRootView];
//    // 选择性别
//    CGFloat labelView1Y = 35.0;
//    CGFloat labelView1H = 30.0;
//    if(kScreenHeight < 570) {
//        // 5s
//        labelView1Y = 35.0 - 20;
//    }
//    UILabel *labelView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y, kScreenWidth, labelView1H)];
//    labelView1.text = @"选择性别";
//    labelView1.textColor = [UIColor whiteColor];
//    labelView1.textAlignment = NSTextAlignmentCenter;
//    labelView1.font = [UIFont boldSystemFontOfSize:20.0];
//    [sexRootView addSubview:labelView1];
//    // 一旦选择 性别 注册后不可更改
//    CGFloat labelView2H = 20.0;
//    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y + labelView1H, kScreenWidth, labelView2H)];
//    labelView2.text = @"一旦选择 性别 注册后不可更改";
//    labelView2.textColor = [UIColor whiteColor];
//    labelView2.textAlignment = NSTextAlignmentCenter;
//    labelView2.font = [UIFont systemFontOfSize:15.0];
//    [sexRootView addSubview:labelView2];
//    // 男士
//    CGFloat secBtnY = labelView2.frame.origin.y + labelView2.frame.size.height + 20.0;
//    CGFloat sexBtnLeftRightMarging = 60.0;
//    CGFloat sexBtnH = 100.0;
//    if(kScreenHeight < 570) {
//        // 5s
//        sexBtnH = 70.0;
//    }
//
//    CGFloat setBtnSpace = (kScreenWidth - 2*sexBtnLeftRightMarging - sexBtnH *2);
//    UIButton *manButton = [[UIButton alloc] initWithFrame:CGRectMake(sexBtnLeftRightMarging, secBtnY, sexBtnH, sexBtnH)];
//    //manButton.backgroundColor = [UIColor whiteColor];
//    manButton.tag = kManButtonTag;
//    [manButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
//    _manButton = manButton;
//    [sexRootView addSubview:manButton];
//    // 女士
//    UIButton *womanButton = [[UIButton alloc] initWithFrame:CGRectMake(sexBtnLeftRightMarging + sexBtnH + setBtnSpace, secBtnY, sexBtnH, sexBtnH)];
//    //womanButton.backgroundColor = [UIColor whiteColor];
//    womanButton.tag = kWomanButtonTag;
//    [womanButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
//    _womanButton = womanButton;
//    [sexRootView addSubview:womanButton];
//    // 男士
//    CGFloat manLabelY = manButton.frame.origin.y + manButton.frame.size.height + 10.0;
//    CGFloat manLabelW = sexBtnH;
//    CGFloat manLabelH = 20.0;
//    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(manButton.frame.origin.x, manLabelY, manLabelW, manLabelH)];
//    manLabel.text = @"男士";
//    manLabel.textAlignment = NSTextAlignmentCenter;
//    manLabel.textColor = [UIColor whiteColor];
//    manLabel.font = [UIFont boldSystemFontOfSize:17.0];
//    [sexRootView addSubview:manLabel];
//    // 女士
//    UILabel *womanLabel = [[UILabel alloc] initWithFrame:CGRectMake(womanButton.frame.origin.x, manLabelY, manLabelW, manLabelH)];
//    womanLabel.text = @"女士";
//    womanLabel.textAlignment = NSTextAlignmentCenter;
//    womanLabel.textColor = [UIColor whiteColor];
//    womanLabel.font = [UIFont boldSystemFontOfSize:17.0];
//    [sexRootView addSubview:womanLabel];
    
    // 上半部分视图
    CGFloat imageViewH = 434/2.0;
    if(kScreenHeight < 570) {
        // 5s
        imageViewH = 434/2.5;
    }
    
    UIView *topRootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
    //topRootView.backgroundColor = [UIColor redColor];
    topRootView.backgroundColor = [Utils stringTOColor:kColor_440067];
    [self.rootView addSubview:topRootView];
    // 取消按钮
    CGFloat cancleBtnY = 0.0;
    if(kScreenHeight < 570) {
        // 5s
        cancleBtnY = 0.0;
    }
    CGFloat cancleBtnW = 35.0;
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, cancleBtnY, cancleBtnW, cancleBtnW)];
    //cancleBtn.backgroundColor = [UIColor blueColor];
    [cancleBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [cancleBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancleButtonClickInForgetPwd) forControlEvents:UIControlEventTouchUpInside];
    //[topRootView addSubview:cancleBtn];
    // 忘记密码
    CGFloat labelView1Y = (imageViewH-40-20-20)/2;
    CGFloat labelView1H = 40.0;
    UILabel *labelView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y, kScreenWidth, labelView1H)];
    labelView1.text = @"手机号注册";
    labelView1.textColor = [UIColor whiteColor];
    labelView1.textAlignment = NSTextAlignmentCenter;
    labelView1.font = [UIFont systemFontOfSize:24.0];
    [topRootView addSubview:labelView1];
    // 输入您的手机号,获取验证码即可注册
    CGFloat labelView2H = 20.0;
    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(20, labelView1Y + labelView1H, kScreenWidth - 20*2, labelView2H)];
    labelView2.text = @"输入您的手机号,获取验证码即可注册";
    //    labelView2.numberOfLines = 1;
    //    [labelView2 sizeToFit];
    labelView2.textColor = [UIColor whiteColor];
    labelView2.textAlignment = NSTextAlignmentCenter;
    labelView2.font = [UIFont systemFontOfSize:15.0];
    [topRootView addSubview:labelView2];
    
    // 注册成功后,密码要注意牢记
    UILabel *labelView3 = [[UILabel alloc] initWithFrame:CGRectMake(20, labelView1Y + labelView1H + labelView2H, kScreenWidth - 20*2, labelView2H)];
    labelView3.text = @"注册成功后,密码要注意牢记";
    //    labelView3.numberOfLines = 1;
    //    [labelView3 sizeToFit];
    labelView3.textColor = [UIColor whiteColor];
    labelView3.textAlignment = NSTextAlignmentCenter;
    labelView3.font = [UIFont systemFontOfSize:15.0];
    [topRootView addSubview:labelView3];
    
    
    UIColor *inputViewTextColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3];
    // 手机号
    CGFloat editViewPaddingTop = 20.0;
    if(kScreenHeight < 500) {
        // 4/ipa
        editViewPaddingTop = 20.0;
    }
    CGFloat editViewPaddingLeftRight = 30.0;
    CGFloat editViewH = 44.0;
    CGFloat editViewW = kScreenWidth - editViewPaddingLeftRight * 2;
    UIView *phoneNumRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop, editViewW, editViewH)];
    phoneNumRootView.backgroundColor = [UIColor clearColor];
    [self.rootView addSubview:phoneNumRootView];
    // 手机图标
    CGFloat iconW = 25.0;
    UIImageView *phoneIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (editViewH - iconW)/2, iconW, iconW)];
    //phoneIconView.backgroundColor = [UIColor orangeColor];
    phoneIconView.image = [UIImage imageNamed:@"ic_mobile"];
    [phoneNumRootView addSubview:phoneIconView];
    // 清除手机号按钮
    CGFloat cleanUpViewW = 30.0;
    UIButton *cleanUpView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - cleanUpViewW , (editViewH - cleanUpViewW)/2, cleanUpViewW, cleanUpViewW)];
    cleanUpView.alpha = 0.5;
    //cleanUpView.backgroundColor = [UIColor blueColor];
    [cleanUpView addTarget:self action:@selector(cleanUpButtonClickRegister) forControlEvents:UIControlEventTouchUpInside];
    _cleanUpButton = cleanUpView;
    _cleanUpButton.hidden = YES;
    [_cleanUpButton setImage:[UIImage imageNamed:@"icon_remove"] forState:UIControlStateNormal];
    [phoneNumRootView addSubview:cleanUpView];
    // 手机输入框
    CGFloat phoneinputViewPaddingLeft = 5.0;
    UITextField *phoneInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, phoneNumRootView.frame.size.width - iconW - cleanUpViewW - phoneinputViewPaddingLeft, editViewH)];
    //phoneInputView.backgroundColor = [UIColor greenColor];
    phoneInputView.placeholder = @"请输入手机号码";
    phoneInputView.delegate = self;
    [phoneInputView setInputAccessoryView:self.keyboardTopView];
    // 注意：先设置phoneInputView.placeholder才有效
    [phoneInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneInputView.textColor = [UIColor whiteColor];
    [phoneInputView addTarget:self  action:@selector(textFieldDidChange:)  forControlEvents:UIControlEventAllEditingEvents];
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
    [self.rootView addSubview:authCodeRootView];
    // 验证码图标
    UIImageView *authCodeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (editViewH - iconW)/2, iconW, iconW)];
    //authCodeIconView.backgroundColor = [UIColor orangeColor];
    authCodeIconView.image = [UIImage imageNamed:@"ic_authcode"];
    [authCodeRootView addSubview:authCodeIconView];
    // 获取验证码
    CGFloat getAuthCodeViewW = 120.0;
    UIButton *getAuthCodeView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - getAuthCodeViewW + 3 , 0, getAuthCodeViewW, editViewH)];
    //getAuthCodeView.backgroundColor = [UIColor blueColor];
    [getAuthCodeView addTarget:self action:@selector(getAuthCodeButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
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
    authCodeInputView.delegate = self;
    [authCodeInputView setInputAccessoryView:self.keyboardTopView];
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
    [self.rootView addSubview:PWDRootView];
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
    PWDInputView.placeholder = @"请输入密码";
    PWDInputView.delegate = self;
    [PWDInputView setInputAccessoryView:self.keyboardTopView];
    [PWDInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    PWDInputView.textColor = [UIColor whiteColor];
    PWDInputView.secureTextEntry = NO;
    _passwordInputView = PWDInputView;
    [PWDRootView addSubview:PWDInputView];
    // 分割线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView3.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    lineView3.alpha = 0.1;
    [PWDRootView addSubview:lineView3];

    

    // 注册／登录
    CGFloat registerAndLoginBtnRootViewH = 40.0;
    CGFloat registerAndLoginBtnRootViewW = editViewW;
    CGFloat registerAndLoginBtnRootViewSpace = 20.0;
    CGFloat registerAndLoginBtnRootViewX = editViewPaddingLeftRight;
    CGFloat registerAndLoginBtnRootViewY = kScreenHeight - 120.0 - registerAndLoginBtnRootViewH;
    if(kScreenHeight < 500) {
        // 4/ipa
        registerAndLoginBtnRootViewY = PWDRootView.origin.y + PWDRootView.size.height + 30.0;
    } else if(kScreenHeight < 570) {
        // 5s
        registerAndLoginBtnRootViewY = kScreenHeight - 90.0 - registerAndLoginBtnRootViewH;
    }
    UIView *registerAndLoginBtnRootView = [[UIView alloc]initWithFrame:CGRectMake(registerAndLoginBtnRootViewX, registerAndLoginBtnRootViewY, registerAndLoginBtnRootViewW, registerAndLoginBtnRootViewH)];
    registerAndLoginBtnRootView.backgroundColor = [UIColor clearColor];
    [self.rootView addSubview:registerAndLoginBtnRootView];
    
    // 登录
    CGFloat buttonW = (registerAndLoginBtnRootViewW - registerAndLoginBtnRootViewSpace)/2;
    UIButton *loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, registerAndLoginBtnRootViewH)];
    [loginBtnView setTitle:@"登录" forState:UIControlStateNormal];
    //loginBtnView.backgroundColor = [UIColor orangeColor];
    loginBtnView.backgroundColor = [UIColor clearColor];
    [loginBtnView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8]forState:UIControlStateNormal];
    [loginBtnView addTarget:self action:@selector(registerAndLoginButtonClickInRegisterSetBg:) forControlEvents:UIControlEventTouchDown];
    [loginBtnView addTarget:self action:@selector(loginButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtnView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [loginBtnView.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 0.8 });
    [loginBtnView.layer setBorderColor:colorref];//边框颜色
    [registerAndLoginBtnRootView addSubview:loginBtnView];
    
    // 注册
    UIButton *registerBtnView = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + registerAndLoginBtnRootViewSpace, 0, buttonW, registerAndLoginBtnRootViewH)];
    [registerBtnView setTitle:@"注册" forState:UIControlStateNormal];
    //registerBtnView.backgroundColor = [UIColor blueColor];
    registerBtnView.backgroundColor = [UIColor clearColor];
    [registerBtnView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8]forState:UIControlStateNormal];
    [registerBtnView addTarget:self action:@selector(registerAndLoginButtonClickInRegisterSetBg:) forControlEvents:UIControlEventTouchDown];
    [registerBtnView addTarget:self action:@selector(registerButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtnView.layer setMasksToBounds:YES];
    [registerBtnView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [registerBtnView.layer setBorderWidth:1.0]; //边框宽度
    [registerBtnView.layer setBorderColor:colorref];//边框颜色
    [registerAndLoginBtnRootView addSubview:registerBtnView];

    
    
}


#pragma mark - 按钮点击处理

// 获取验证码按钮点击
- (void)sexButtonClickInRegister:(id)sender
{
    NSLog(@"sexButtonClickInRegister");
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case kManButtonTag:
        {
            _sexString = @"M";
        }
            break;
            
        case kWomanButtonTag:
        {
            _sexString = @"F";
        }
            break;
            
        default:
            break;
    }
    
    [self updateSelectSexState];
    
}

- (void)updateSelectSexState
{
    if([_sexString isEqualToString:@"M"]) {
        [_manButton setImage:[UIImage imageNamed:@"ic_man_selected"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"ic_woman_unselected"] forState:UIControlStateNormal];
    } else if([_sexString isEqualToString:@"F"]) {
        [_manButton setImage:[UIImage imageNamed:@"ic_man_unselected"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"ic_woman_selected"] forState:UIControlStateNormal];
    }
}


// 获取验证码按钮点击
- (void)getAuthCodeButtonClickInRegister:(id)sender
{
    NSLog(@"getAuthCodeButtonClickInRegister");
    
    
    if(_getAuthCodeButton.tag == kgetAuthCodeButtonOfGetting){
        return;
    }
    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate checkReachable] == NO) {
        return;
    }
    
//    if(phoneNumber && phoneNumber.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
    if(!isPhoneNumberRight) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        [MBProgressHUD showHUDByContent:@"请输入正确的手机号" view:self.view];
        return;
    }
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:phoneNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = kAlertViewTagOfConfirmPhoneNumber;
//    [alert show];
    
    // 获取手机验证码
    [self getPhoneMsgCode];
    //[self ifRegister:_phoneNumbrInputView.text];
}


// 手机输入框点击
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(textField == _phoneNumbrInputView) {
//        if(textField.text.length >= 1) {
//            _cleanUpButton.hidden = NO;
//        }
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _phoneNumbrInputView) {
        _cleanUpButton.hidden = YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneNumbrInputView) {
        if (textField.text.length >= 11 && string.length>0) return NO;
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _phoneNumbrInputView) {
        if(textField.text.length >= 1) {
            _cleanUpButton.hidden = NO;
        }else {
            _cleanUpButton.hidden = YES;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _phoneNumbrInputView) {
        [_authCodeInputView becomeFirstResponder];
    } else if(textField == _authCodeInputView) {
        [_passwordInputView becomeFirstResponder];
    } else {
        [_passwordInputView endEditing:YES];
        return YES;
    }
    
    
    return YES;
}


// 显示密码按钮点击
- (void)cleanUpButtonClickRegister
{
    NSLog(@"cleanUpButtonClickInLogin");
    _phoneNumbrInputView.text = @"";
    _passwordInputView.text = @"";
}

// 显示密码按钮点击
- (void)showPWDButtonClickInRegister
{
    NSLog(@"showPWDButtonClickInRegister");
    _passwordInputView.secureTextEntry = !_passwordInputView.secureTextEntry;
    //_showPwdButton.backgroundColor = _passwordInputView.secureTextEntry ? [UIColor blueColor] : [UIColor redColor];
    [_showPwdButton setImage:[UIImage imageNamed:_passwordInputView.secureTextEntry ?@"ic_show_pwd_on" : @"ic_show_pwd_off"] forState:UIControlStateNormal];
 
}

// 注册/登录按钮按下(改变按钮背景)
- (void)registerAndLoginButtonClickInRegisterSetBg:(id)sender
{
    NSLog(@"registerButtonClickInLoginSetBg");
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [Utils stringTOColor:kColor_440067];
    
}

// 注册按钮点击
- (void)registerButtonClickInRegister:(id)sender
{
    NSLog(@"registerButtonClickInRegister");
    
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor clearColor];
    
    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    NSString *authCode = _authCodeInputView.text;
    NSString *password = _passwordInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    BOOL isPasswordRight = [Utils checkPassWord: password];
    BOOL isauthCodeRight = [Utils checkAuthCode: authCode];
    
     // 校验顺序：网络 - 用户名格式 - 注册未注册 - 用户名、密码、用户和用户名
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate checkReachable] == NO) {
        return;
    }
    
    // 校验
//    if(phoneNumber && phoneNumber.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
//    
//    if(!isPhoneNumberRight) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的手机号码有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
//    
//    
//    if(password && password.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
//    
//    if(!isPasswordRight) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码格式有误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
//    
//    if(authCode && authCode.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
//    
//    if(!isauthCodeRight) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码格式错误，请重新填写" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
    if(phoneNumber && phoneNumber.length == 0) {
        [MBProgressHUD showHUDByContent:@"请输入正确的手机号" view:self.view];
        return;
    }
    
    if(authCode && authCode.length == 0) {
        [MBProgressHUD showHUDByContent:@"请输入验证码" view:self.view];
        return;
    }
    
    if(password && password.length == 0) {
       [MBProgressHUD showHUDByContent:@"请输入密码" view:self.view];
        return;
    }

    
    if(!isPhoneNumberRight || !isPasswordRight) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号或密码错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //        [alert show];
        [MBProgressHUD showHUDByContent:@"手机号或密码错误" view:self.view];
        return;
    }
    
    
//    if(authCode == nil || authCode.length == 0 ) {
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码格式错误，请重新填写" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        //        [alert show];
//        //        return;
//        //    }
//        [MBProgressHUD showHUDByContent:@"请输入验证码" view:self.view];
//        return;
//    }
    
    
    [self ifRegister:_phoneNumbrInputView.text];
//    // 注册
//    [self beginRegister:phoneNumber authCode:authCode password:password sex:_sexString];
    
}


// 登录按钮点击
- (void)loginButtonClickInRegister:(id)sender
{
    NSLog(@"loginButtonClickInRegister");
    
    [self stopTimer];
    
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor clearColor];
    
    [LoginManager share].autoLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if(alertView.tag == kAlertViewTagOfIntoLogin) {
                
                // 进入登录界面
                [self intoLoginPage];
            }

        }
            break;
            
        case 1:
        {
            if(alertView.tag == kAlertViewTagOfConfirmPhoneNumber) {
                // 获取手机验证码
                //[self getPhoneMsgCode];
                [self ifRegister:_phoneNumbrInputView.text];
                
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
             [MBProgressHUD showHUDByContent:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] view:self.view];
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


// 注册
- (void)beginRegister:(NSString *)phoneNumber authCode:(NSString *)authCode password:(NSString *)password sex:(NSString *)sex
{
   
    [self stopTimer];
    [self showRemoteAnimation:@"正在注册, 请稍候..."];
    
    NSLog(@"注册，手机：%@, 验证码：%@, 密码：%@ , 性别：%@", phoneNumber, authCode, password, sex);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber,
                                 @"msgCode": authCode,
                                 @"password": password,
                                 @"sex": sex,
                                 };
    __block RegisterViewController *selfBlock = self;
    NSInteger startTimeInterval = [[NSDate date] timeIntervalSince1970];
    __block NSString *phoneNumberBlock = phoneNumber;
    __block NSString *passwordBlock = password;
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_REGISTER
                              urlString:URL_REGISTER
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         NSInteger endTimeInterval = [[NSDate date] timeIntervalSince1970];
         if(endTimeInterval - startTimeInterval < 1) {
             sleep(1.0 - (endTimeInterval - startTimeInterval));
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self hideRemoteAnimation];
         });
         
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"注册成功！");
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功!" message:@"点击确认进入登录界面" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//             alert.tag = kAlertViewTagOfIntoLogin;
//             [alert show];
             [MBProgressHUD showHUDByContent:@"注册成功" view:self.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 // 保存用户名和密码，自动登录
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:phoneNumberBlock forKey:kUserDefaultIdKey];
                 [defaults setObject:passwordBlock forKey:kUserDefaultPasswordKey];
                 [defaults synchronize];
                 // 进入登录界面
                 [selfBlock intoLoginPage];
             });
             
             
         } else {
             
             NSLog(@"注册失败！: %@",[obj objectForKey:HTTP_KEY_RESULTMESSAGE]);
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败!" message: [obj objectForKey:HTTP_KEY_RESULTMESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//             [alert show];
             [MBProgressHUD showHUDByContent:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] view:self.view];
         }
         
     }];
    

}

// 是否注册
- (void)ifRegister:(NSString *)phoneNumber
{
    NSLog(@"是否注册，手机：%@", phoneNumber);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber};
    __weak RegisterViewController *weakSelf = self;
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_IFREGISTER
                              urlString:URL_IFREGISTER
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"账号已经注册！");
             
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"该手机号已被注册" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//             [alert show];
             [MBProgressHUD showHUDByContent:@"该手机号已被注册" view:self.view];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"该手机号已注册" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             alert.tag = kAlertViewTagOfIntoLogin;
             [alert show];
             
             
         } else if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_ERROR]) {
             NSLog(@"账号未注册！");
//             // 获取手机验证码
//             [weakSelf getPhoneMsgCode];
             
             // 注册
             [self beginRegister:_phoneNumbrInputView.text authCode:_authCodeInputView.text password:_passwordInputView.text sex:_sexString];
             
         }
         
     }];
}


// 进入登录界面
- (void)intoLoginPage
{
    [UserInfo share].mobile = _phoneNumbrInputView.text;
    [UserInfo share].password = _passwordInputView.text;
    [UserInfo share].sex = _sexString;
    
    
    [LoginManager share].autoLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
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
