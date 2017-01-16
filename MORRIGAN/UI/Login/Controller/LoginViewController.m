//
//  登录界面
//
//  LoginViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfo.h"
#import "LoginManager.h"
#import "Utils.h"
#import "NMOANetWorking.h"
#import "RootViewController.h"
#import "ForgetPwdViewController.h"
#import "RecordManager.h"
#import "AppDelegate.h"
#import "GuideViewController.h"
#import "TargetModel.h"

#define kAlertViewTagOfIntoRegister  1000

@interface LoginViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
    UITextField *_phoneNumbrInputView;
    UITextField *_passwordInputView;
    UIButton *_showPwdButton;
    UIButton *_cleanUpButton;

}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self initView];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults objectForKey:kUserDefaultIdKey];
    NSString *password = [defaults objectForKey:kUserDefaultPasswordKey];
    if(phoneNumber && phoneNumber.length > 0 && password && password.length > 0) {
        NSLog(@"%@",phoneNumber);
        NSLog(@"%@",password);
        _phoneNumbrInputView.text = phoneNumber;
        _passwordInputView.text = password;
        // 自动登录
        [self loginButtonClickInLogin: nil];
    } else if([UserInfo share].mobile && [UserInfo share].mobile.length > 0) {
         _phoneNumbrInputView.text = [UserInfo share].mobile;
    }
    
    
//    if([UserInfo share].mobile && [UserInfo share].mobile.length > 0 && [UserInfo share].password && [UserInfo share].password.length > 0)
//    {
//        // 注册成功返回
//        _phoneNumbrInputView.text = [UserInfo share].mobile;
//        //_passwordInputView.text = [UserInfo share].password;
//        
//    } else {
//        
//        // 注销登录成功时调用这个
//        //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        //    [defaults removeObjectForKey:kUserDefaultIdKey];
//        //    [defaults removeObjectForKey:kUserDefaultPasswordKey];
//        
//        
//        
//        // 自动登录
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *phoneNumber = [defaults objectForKey:kUserDefaultIdKey];
//        NSString *password = [defaults objectForKey:kUserDefaultPasswordKey];
//        if(phoneNumber && phoneNumber.length > 0 && password && password.length > 0) {
//            NSLog(@"%@",phoneNumber);
//            NSLog(@"%@",password);
//            _phoneNumbrInputView.text = phoneNumber;
//            _passwordInputView.text = password;
//            [self loginButtonClickInLogin: nil];
//        }
//        
//    }
}


- (void)initView
{
    [super initView];
    
    // 上面的图片
    CGFloat imageViewH = 434/2.0;
    if(kScreenHeight < 570) {
        // 5s
        imageViewH = 434/2.5;
    }
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
    imageViewBg.backgroundColor = [Utils stringTOColor:kColor_440067];
    CGFloat imageH = (imageViewH - 169) + 30;
    CGFloat imageW = (kScreenWidth - 169) + 20;
    if(kScreenHeight < 570) {
        // 5s
        imageH = (imageViewH - 169) + 50;
    }
    CGFloat imageVieY = 169/2;
    if(kScreenHeight < 570) {
        // 5s
        imageVieY = 169/2 - 20;
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-imageW)/2, imageVieY, imageW, imageH)];
    imageView.image = [UIImage imageNamed:@"bg_morrig"];
    [imageViewBg addSubview:imageView];
    [self.rootView addSubview:imageViewBg];
    

    
    
    UIColor *inputViewTextColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3];
    // 手机号
    CGFloat editViewPaddingTop = 70.0;
    if(kScreenHeight < 570) {
        // 5s
        editViewPaddingTop = 50.0;
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
    [cleanUpView addTarget:self action:@selector(cleanUpButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
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
    
    
  
    // 密码
    CGFloat PWDeditViewPaddingTop = 20.0;
    UIView *PWDRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + PWDeditViewPaddingTop, editViewW, editViewH)];
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
    [showPWDView addTarget:self action:@selector(showPWDButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    _showPwdButton = showPWDView;
    [_showPwdButton setImage:[UIImage imageNamed:@"ic_show_pwd_off"] forState:UIControlStateNormal];
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    //PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"请输入密码";
    [PWDInputView setInputAccessoryView:self.keyboardTopView];
    [PWDInputView setValue:inputViewTextColor forKeyPath:@"_placeholderLabel.textColor"];
    PWDInputView.textColor = [UIColor whiteColor];
    PWDInputView.secureTextEntry = NO;
    _passwordInputView = PWDInputView;
    [PWDRootView addSubview:PWDInputView];
    // 分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView2.backgroundColor = [Utils stringTOColor:kColor_ffffff];
    lineView2.alpha = 0.1;
    [PWDRootView addSubview:lineView2];
    
    
    
    // 忘记密码
    CGFloat forgetPWDViewW = 100.0;
    CGFloat forgetPWDViewH = 45.0;
    UIButton *forgetPWDView = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - editViewPaddingLeftRight - forgetPWDViewW, PWDRootView.frame.origin.y + PWDRootView.frame.size.height + 5, forgetPWDViewW, forgetPWDViewH)];
    [forgetPWDView setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPWDView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.6] forState:UIControlStateNormal];
    [forgetPWDView addTarget:self action:@selector(forgetPWDButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView addSubview:forgetPWDView];
    
    
    
    // 注册／登录
    CGFloat registerAndLoginBtnRootViewH = 40.0;
    CGFloat registerAndLoginBtnRootViewW = editViewW;
    CGFloat registerAndLoginBtnRootViewSpace = 20.0;
    CGFloat registerAndLoginBtnRootViewX = editViewPaddingLeftRight;
    CGFloat registerAndLoginBtnRootViewY = kScreenHeight - 120.0 - registerAndLoginBtnRootViewH;
    if(kScreenHeight < 500) {
        // 4/ipa
        registerAndLoginBtnRootViewY = PWDRootView.origin.y + PWDRootView.size.height + 60.0;
    }
    
    UIView *registerAndLoginBtnRootView = [[UIView alloc]initWithFrame:CGRectMake(registerAndLoginBtnRootViewX, registerAndLoginBtnRootViewY, registerAndLoginBtnRootViewW, registerAndLoginBtnRootViewH)];
    registerAndLoginBtnRootView.backgroundColor = [UIColor clearColor];
    [self.rootView addSubview:registerAndLoginBtnRootView];
    // 注册
    CGFloat buttonW = (registerAndLoginBtnRootViewW - registerAndLoginBtnRootViewSpace)/2;
    UIButton *registerBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, registerAndLoginBtnRootViewH)];
    [registerBtnView setTitle:@"注册" forState:UIControlStateNormal];
    //registerBtnView.backgroundColor = [UIColor blueColor];
    registerBtnView.backgroundColor = [UIColor clearColor];
    [registerBtnView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8]forState:UIControlStateNormal];
    [registerBtnView addTarget:self action:@selector(registerAndLoginButtonClickInLoginSetBg:) forControlEvents:UIControlEventTouchDown];
    [registerBtnView addTarget:self action:@selector(registerButtonClickInLogin:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtnView.layer setMasksToBounds:YES];
    [registerBtnView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [registerBtnView.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 0.8 });
    [registerBtnView.layer setBorderColor:colorref];//边框颜色
    [registerAndLoginBtnRootView addSubview:registerBtnView];
    // 登录
    UIButton *loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + registerAndLoginBtnRootViewSpace, 0, buttonW, registerAndLoginBtnRootViewH)];
    [loginBtnView setTitle:@"登录" forState:UIControlStateNormal];
    //loginBtnView.backgroundColor = [UIColor orangeColor];
    loginBtnView.backgroundColor = [UIColor clearColor];
    [loginBtnView setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.8]forState:UIControlStateNormal];
    [loginBtnView addTarget:self action:@selector(registerAndLoginButtonClickInLoginSetBg:) forControlEvents:UIControlEventTouchDown];
    [loginBtnView addTarget:self action:@selector(loginButtonClickInLogin:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtnView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [loginBtnView.layer setBorderWidth:1.0]; //边框宽度
    [loginBtnView.layer setBorderColor:colorref];//边框颜色
    [registerAndLoginBtnRootView addSubview:loginBtnView];
    
    
}


#pragma mark - 按钮点击处理
// 手机输入框点击
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(textField == _phoneNumbrInputView) {
//        _cleanUpButton.hidden = NO;
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

// 显示密码按钮点击
- (void)cleanUpButtonClickInLogin
{
    NSLog(@"cleanUpButtonClickInLogin");
    _phoneNumbrInputView.text = @"";
    _passwordInputView.text = @"";
}

// 显示密码按钮点击
- (void)showPWDButtonClickInLogin
{
    NSLog(@"showPWDButtonClickInLogin");
    _passwordInputView.secureTextEntry = !_passwordInputView.secureTextEntry;
    //_showPwdButton.backgroundColor = _passwordInputView.secureTextEntry ? [UIColor blueColor] : [UIColor redColor];
    [_showPwdButton setImage:[UIImage imageNamed:_passwordInputView.secureTextEntry ?@"ic_show_pwd_on" : @"ic_show_pwd_off"] forState:UIControlStateNormal];
}


// 忘记密码按钮点击
- (void)forgetPWDButtonClickInLogin
{
    NSLog(@"forgetPWDButtonClickInLogin");
    ForgetPwdViewController *forgetPwdViewController = [[ForgetPwdViewController alloc] init];
    forgetPwdViewController.phoneNumber = _phoneNumbrInputView.text;
    [self.navigationController pushViewController:forgetPwdViewController animated:YES];
}

// 注册/登录按钮按下(改变按钮背景)
- (void)registerAndLoginButtonClickInLoginSetBg:(id)sender
{
    NSLog(@"registerButtonClickInLoginSetBg");
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [Utils stringTOColor:kColor_440067];
   
}

// 注册按钮点击
- (void)registerButtonClickInLogin:(id)sender
{
    NSLog(@"registerButtonClickInLogin");
    
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor clearColor];
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}


// 登录按钮点击
- (void)loginButtonClickInLogin:(id)sender
{
    NSLog(@"loginButtonClickInLogin");

    
////     进入主页（测试）
//    RootViewController *homeViewController = [[RootViewController alloc] init];
//    [self.navigationController pushViewController:homeViewController animated:YES];
//    return;

    if(sender) {
        UIButton *button = (UIButton *)sender;
        button.backgroundColor = [UIColor clearColor];
    }
   
    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    NSString *password = _passwordInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    BOOL isPasswordRight = [Utils checkPassWord: password];
    
    // 校验顺序：网络 - 用户名格式 - 注册未注册 - 用户名、密码、用户和用户名
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate checkReachable] == NO) {
        return;
    }
    
    // 校验
//    if(phoneNumber && phoneNumber.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输账号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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

    if(!isPhoneNumberRight || !isPasswordRight) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号或密码错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        [MBProgressHUD showHUDByContent:@"手机号或密码错误" view:self.view];
        return;
    }
    

    // 是否注册
    [self ifRegister:phoneNumber password:password];
    
}


#pragma mark - other
// 是否注册
- (void)ifRegister:(NSString *)phoneNumber password:(NSString *)password
{
    NSLog(@"是否注册，手机：%@, 密码：%@ ", phoneNumber, password);
    [self showRemoteAnimation:@"正在登录, 请稍候..."];
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber};
    __weak LoginViewController *weakSelf = self;
    __block NSString *phoneNumberBlock = phoneNumber;
    __block NSString *passwordBlock = password;
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_IFREGISTER
                              urlString:URL_IFREGISTER
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {

         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"账号已经注册！");
             // 登录
             [weakSelf beginLogin:phoneNumberBlock password:passwordBlock];
             
         } else if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_ERROR]) {
             NSLog(@"账号未注册！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"该手机号未注册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
             alert.tag = kAlertViewTagOfIntoRegister;
             [alert show];

         }
         
     }];
}


// 登录
- (void)beginLogin:(NSString *)phoneNumber password:(NSString *)password
{
    
    NSLog(@"登录，手机：%@, 密码：%@ ", phoneNumber, password);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber,
                                 @"password": password
                                 };
    __weak LoginViewController *weakSelf = self;
    NSInteger startTimeInterval = [[NSDate date] timeIntervalSince1970];
    __block NSString *phoneNumberBlock = phoneNumber;
    __block NSString *passwordBlock = password;
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_LOGIN
                              urlString:URL_LOGIN
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         NSInteger endTimeInterval = [[NSDate date] timeIntervalSince1970];
         if(endTimeInterval - startTimeInterval < 1) {
             sleep(1.0 - (endTimeInterval - startTimeInterval));
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf hideRemoteAnimation];
         });
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"登录成功！");
             [MBProgressHUD showHUDByContent:@"登录成功！" view:self.view];

             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 // 保存用户信息
                 NSDictionary *userInfoDict = [obj objectForKey:@"userInfo"];
                 NSLog(@"%@", userInfoDict);
                 [UserInfo share].authCode = [userInfoDict objectForKey:@"authCode"];
                 [UserInfo share].emotion = [userInfoDict objectForKey:@"emotion"];
                 [UserInfo share].high = [userInfoDict objectForKey:@"high"];
                 [UserInfo share].imgUrl = [userInfoDict objectForKey:@"imgUrl"];
                 [UserInfo share].mobile = [userInfoDict objectForKey:@"mobile"];
                 [UserInfo share].nickName = [userInfoDict objectForKey:@"nickName"];
                 [UserInfo share].password = [userInfoDict objectForKey:@"password"];
                 [UserInfo share].sex = [userInfoDict objectForKey:@"sex"];
                 [UserInfo share].target = [userInfoDict objectForKey:@"target"];
                 [UserInfo share].userId = [userInfoDict objectForKey:@"userId"];
                 [UserInfo share].weight = [userInfoDict objectForKey:@"weight"];
                 [UserInfo share].age = [userInfoDict objectForKey:@"age"];
                 NSString *temp =[UserInfo share].emotion;
                 if ([[UserInfo share].emotion isEqualToString:@"B"]) {
                     [UserInfo share].emotionStr = @"恋爱";
                 }
                 else if ([[UserInfo share].emotion isEqualToString:@"M"]) {
                     [UserInfo share].emotionStr = @"已婚";
                 }
                 else if ([[UserInfo share].emotion isEqualToString:@"S"]) {
                     [UserInfo share].emotionStr = @"未婚";
                 }
                 
                 // 保存用户名和密码，下次自动登录
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:phoneNumberBlock forKey:kUserDefaultIdKey];
                 [defaults setObject:passwordBlock forKey:kUserDefaultPasswordKey];
                 [defaults synchronize];
                 
                 // 登录成功后获取已绑定设备
                 [weakSelf fetchBindedDevices];
                     // 进入主页
                     RootViewController *homeViewController = [[RootViewController alloc] init];
                     NSLog(@"%@",weakSelf.navigationController);
                     [weakSelf.navigationController pushViewController:homeViewController animated:YES];
                     
                     // 上传护理记录数据
                     [[RecordManager share] uploadDBDatas:NO];
                 
             });

         } else {
             
             NSLog(@"登录失败！");
             
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] == nil ? @"登录失败！": [obj objectForKey:HTTP_KEY_RESULTMESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//             [alert show];
             [MBProgressHUD showHUDByContent:@"帐号或密码错误" view:self.view];
             
         }
         
     }];
}

- (void)loginResult
{
    
}

- (void)fetchBindedDevices {
    NSDictionary *dictionary = @{@"userId":[UserInfo share].userId};
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_GET_DEVICELIST
                              urlString:URL_GET_DEVICELIST
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         NSString *code = [obj objectForKey:@"retCode"];
         if ([code isEqualToString:@"000"]) {
             NSArray *array = [obj objectForKey:@"deviceInfo"];
             NSMutableArray *peripheals = [[NSMutableArray alloc] init];
             for (NSDictionary *dictionary in array) {
                 PeripheralModel *model = [[PeripheralModel alloc] init];
                 model.name = [dictionary objectForKey:@"deviceName"];
                 model.macAddress = [dictionary objectForKey:@"mac"];
                 model.userID = [dictionary objectForKey:@"userId"];
                 [peripheals addObject:model];
             }
             [DBManager insertPeripherals:peripheals];
         }
         else {
             NSLog(@"获取设备列表失败");
         }
     }];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            if(alertView.tag == kAlertViewTagOfIntoRegister) {
                
                // 进入注册界面
                RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
                [self.navigationController pushViewController:registerViewController animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
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
