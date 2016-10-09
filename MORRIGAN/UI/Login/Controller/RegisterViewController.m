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



#define kManButtonTag     1001
#define kWomanButtonTag   1002

#define kAlertViewTagOfConfirmPhoneNumber  2001
#define kAlertViewTagOfIntoLogin           2002



@interface RegisterViewController () <UIAlertViewDelegate>
{
    NSString *_sexString;
    UIButton *_manButton;
    UIButton *_womanButton;
    UITextField *_phoneNumbrInputView;
    UITextField *_authCodeInputView;
    UITextField *_passwordInputView;
    UIButton *_showPwdButton;
    
    UIAlertView *remoteAlertView;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化视图
    [self initView];
    
    
    // 默认性别：男
    _sexString = @"M";
    _manButton.backgroundColor = [UIColor greenColor];

}


- (void)initView
{

    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    rootView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:rootView];
    
    
    // 性别选择
    CGFloat imageViewH = 270.0;
    UIView *sexRootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
    sexRootView.backgroundColor = [UIColor redColor];
    [rootView addSubview:sexRootView];
    // 选择性别
    CGFloat labelView1Y = 35.0;
    CGFloat labelView1H = 30.0;
    UILabel *labelView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y, kScreenWidth, labelView1H)];
    labelView1.text = @"选择性别";
    labelView1.textColor = [UIColor whiteColor];
    labelView1.textAlignment = NSTextAlignmentCenter;
    labelView1.font = [UIFont boldSystemFontOfSize:20.0];
    [sexRootView addSubview:labelView1];
    // 一旦选择 性别 注册后不可更改
    CGFloat labelView2H = 20.0;
    UILabel *labelView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, labelView1Y + labelView1H, kScreenWidth, labelView2H)];
    labelView2.text = @"一旦选择 性别 注册后不可更改";
    labelView2.textColor = [UIColor whiteColor];
    labelView2.textAlignment = NSTextAlignmentCenter;
    labelView2.font = [UIFont systemFontOfSize:15.0];
    [sexRootView addSubview:labelView2];
    // 男士
    CGFloat secBtnY = labelView2.frame.origin.y + labelView2.frame.size.height + 20.0;
    CGFloat sexBtnLeftRightMarging = 60.0;
    CGFloat sexBtnH = 100.0;
    CGFloat setBtnSpace = (kScreenWidth - 2*sexBtnLeftRightMarging - sexBtnH *2);
    UIButton *manButton = [[UIButton alloc] initWithFrame:CGRectMake(sexBtnLeftRightMarging, secBtnY, sexBtnH, sexBtnH)];
    manButton.backgroundColor = [UIColor whiteColor];
    manButton.tag = kManButtonTag;
    [manButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
    _manButton = manButton;
    [sexRootView addSubview:manButton];
    // 女士
    UIButton *womanButton = [[UIButton alloc] initWithFrame:CGRectMake(sexBtnLeftRightMarging + sexBtnH + setBtnSpace, secBtnY, sexBtnH, sexBtnH)];
    womanButton.backgroundColor = [UIColor whiteColor];
    womanButton.tag = kWomanButtonTag;
    [womanButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
    _womanButton = womanButton;
    [sexRootView addSubview:womanButton];
    // 男士
    CGFloat manLabelY = manButton.frame.origin.y + manButton.frame.size.height + 10.0;
    CGFloat manLabelW = sexBtnH;
    CGFloat manLabelH = 20.0;
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(manButton.frame.origin.x, manLabelY, manLabelW, manLabelH)];
    manLabel.text = @"男士";
    manLabel.textAlignment = NSTextAlignmentCenter;
    manLabel.textColor = [UIColor whiteColor];
    manLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [sexRootView addSubview:manLabel];
    // 女士
    UILabel *womanLabel = [[UILabel alloc] initWithFrame:CGRectMake(womanButton.frame.origin.x, manLabelY, manLabelW, manLabelH)];
    womanLabel.text = @"女士";
    womanLabel.textAlignment = NSTextAlignmentCenter;
    womanLabel.textColor = [UIColor whiteColor];
    womanLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [sexRootView addSubview:womanLabel];
    
    
    
    
    // 手机号
    CGFloat editViewPaddingTop = 30.0;
    CGFloat editViewPaddingLeftRight = 20.0;
    CGFloat editViewH = 54.0;
    CGFloat editViewW = kScreenWidth - editViewPaddingLeftRight * 2;
    UIView *phoneNumRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop, editViewW, editViewH)];
    phoneNumRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:phoneNumRootView];
    // 手机图标
    CGFloat iconW = 50.0;
    UIImageView *phoneIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, editViewH)];
    phoneIconView.backgroundColor = [UIColor orangeColor];
    [phoneNumRootView addSubview:phoneIconView];
    // 手机输入框
    CGFloat phoneinputViewPaddingLeft = 10.0;
    UITextField *phoneInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, phoneNumRootView.frame.size.width - iconW - phoneinputViewPaddingLeft, editViewH)];
    phoneInputView.backgroundColor = [UIColor greenColor];
    phoneInputView.placeholder = @"请填写手机号码";
    _phoneNumbrInputView = phoneInputView;
    [phoneNumRootView addSubview:phoneInputView];
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [phoneNumRootView addSubview:lineView];
    
    
    // 验证码
    CGFloat authCodeViewPaddingTop = 10.0;
    UIView *authCodeRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + authCodeViewPaddingTop, editViewW, editViewH)];
    authCodeRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:authCodeRootView];
    // 验证码图标
    UIImageView *authCodeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, editViewH)];
    authCodeIconView.backgroundColor = [UIColor orangeColor];
    [authCodeRootView addSubview:authCodeIconView];
    // 获取验证码
    CGFloat getAuthCodeViewW = 100.0;
    UIButton *getAuthCodeView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - getAuthCodeViewW , 0, getAuthCodeViewW, editViewH)];
    getAuthCodeView.backgroundColor = [UIColor blueColor];
    [getAuthCodeView addTarget:self action:@selector(getAuthCodeButtonClickInRegister) forControlEvents:UIControlEventTouchUpInside];
    [getAuthCodeView setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeRootView addSubview:getAuthCodeView];
    // 验证码输入框
    UITextField *authCodeInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, authCodeRootView.frame.size.width - iconW - getAuthCodeViewW - phoneinputViewPaddingLeft, editViewH)];
    authCodeInputView.backgroundColor = [UIColor greenColor];
    authCodeInputView.placeholder = @"输入验证码";
    _authCodeInputView = authCodeInputView;
    [authCodeRootView addSubview:authCodeInputView];
    // 分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView2.backgroundColor = [UIColor blackColor];
    [authCodeRootView addSubview:lineView2];
    
    
  
    // 密码
    CGFloat PWDeditViewPaddingTop = 10.0;
    UIView *PWDRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + authCodeViewPaddingTop + editViewH  + PWDeditViewPaddingTop, editViewW, editViewH)];
    PWDRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:PWDRootView];
    // 密码图标
    UIImageView *PWDIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, editViewH)];
    PWDIconView.backgroundColor = [UIColor orangeColor];
    [PWDRootView addSubview:PWDIconView];
    // 显示密码按钮
    CGFloat showPWDViewW = 50.0;
    UIButton *showPWDView = [[UIButton alloc] initWithFrame:CGRectMake(editViewW - showPWDViewW , 0, showPWDViewW, editViewH)];
    showPWDView.backgroundColor = [UIColor blueColor];
    [showPWDView addTarget:self action:@selector(showPWDButtonClickInRegister) forControlEvents:UIControlEventTouchUpInside];
    _showPwdButton = showPWDView;
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"设置密码";
    PWDInputView.secureTextEntry = YES;
    _passwordInputView = PWDInputView;
    [PWDRootView addSubview:PWDInputView];
    // 分割线
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView3.backgroundColor = [UIColor blackColor];
    [PWDRootView addSubview:lineView3];
    
    
    
    // 注册／登陆
    CGFloat registerAndLoginBtnRootViewH = 64.0;
    CGFloat registerAndLoginBtnRootViewW = editViewW;
    CGFloat registerAndLoginBtnRootViewSpace = 20.0;
    CGFloat registerAndLoginBtnRootViewX = editViewPaddingLeftRight;
    CGFloat registerAndLoginBtnRootViewY = kScreenHeight - 80.0 - registerAndLoginBtnRootViewH;
    UIView *registerAndLoginBtnRootView = [[UIView alloc]initWithFrame:CGRectMake(registerAndLoginBtnRootViewX, registerAndLoginBtnRootViewY, registerAndLoginBtnRootViewW, registerAndLoginBtnRootViewH)];
    registerAndLoginBtnRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:registerAndLoginBtnRootView];
    // 注册
    CGFloat buttonW = (registerAndLoginBtnRootViewW - registerAndLoginBtnRootViewSpace)/2;
    UIButton *registerBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, registerAndLoginBtnRootViewH)];
    [registerBtnView setTitle:@"注册" forState:UIControlStateNormal];
    registerBtnView.backgroundColor = [UIColor blueColor];
    [registerBtnView addTarget:self action:@selector(registerButtonClickInRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:registerBtnView];
    // 登陆
    UIButton *loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + registerAndLoginBtnRootViewSpace, 0, buttonW, registerAndLoginBtnRootViewH)];
    [loginBtnView setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtnView.backgroundColor = [UIColor orangeColor];
    [loginBtnView addTarget:self action:@selector(loginButtonClickInRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:loginBtnView];
    
    
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
            _womanButton.backgroundColor = [UIColor whiteColor];
            _manButton.backgroundColor = [UIColor greenColor];
            _sexString = @"M";
        }
            break;
            
        case kWomanButtonTag:
        {
            _manButton.backgroundColor = [UIColor whiteColor];
            _womanButton.backgroundColor = [UIColor greenColor];
            _sexString = @"F";
        }
            break;
            
        default:
            break;
    }
    
}


// 获取验证码按钮点击
- (void)getAuthCodeButtonClickInRegister
{
    NSLog(@"getAuthCodeButtonClickInRegister");
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
    _showPwdButton.backgroundColor = _passwordInputView.secureTextEntry ? [UIColor blueColor] : [UIColor redColor];
 
}


// 注册按钮点击
- (void)registerButtonClickInRegister
{
    NSLog(@"registerButtonClickInRegister");
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

    // 注册
    [self beginRegister:phoneNumber authCode:authCode password:password sex:_sexString];
    
}


// 登陆按钮点击
- (void)loginButtonClickInRegister
{
    NSLog(@"loginButtonClickInRegister");
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
                
                // 进入登陆界面
                [self intoLoginPage];
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
         } else {
             
             NSLog(@"获取验证码失败！");
         }
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
         
     }];
}

// 注册
- (void)beginRegister:(NSString *)phoneNumber authCode:(NSString *)authCode password:(NSString *)password sex:(NSString *)sex
{
    
    [self remoteAnimation:@"正在注册, 请稍候..."];
    
    NSLog(@"注册，手机：%@, 验证码：%@, 密码：%@ , 性别：%@", phoneNumber, authCode, password, sex);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber,
                                 @"msgCode": authCode,
                                 @"password": password,
                                 @"sex": sex,
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_REGISTER
                              urlString:URL_REGISTER
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
         });
         
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"注册成功！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功!" message:@"点击确认进入登陆界面" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             alert.tag = kAlertViewTagOfIntoLogin;
             [alert show];
             
         } else {
             
             NSLog(@"注册失败！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败!" message: [obj objectForKey:HTTP_KEY_RESULTMESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alert show];
         }
         
     }];
    

}


// 进入登陆界面
- (void)intoLoginPage
{
    [UserInfo share].mobile = _phoneNumbrInputView.text;
    [UserInfo share].password = _passwordInputView.text;
    [UserInfo share].sex = _sexString;
    
    
    [LoginManager share].autoLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)remoteAnimation:(NSString *)message{
    
    if (remoteAlertView) {
        remoteAlertView = nil;
    }
    remoteAlertView =  [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil ];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 80.0, 30.0, 30.0)];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    aiView.color = [UIColor blackColor];
    //check if os version is 7 or above. ios7.0及以上UIAlertView弃用了addSubview方法
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        [remoteAlertView setValue:aiView forKey:@"accessoryView"];
    }else{
        [remoteAlertView addSubview:aiView];
    }
    // 不加这句不显示
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
