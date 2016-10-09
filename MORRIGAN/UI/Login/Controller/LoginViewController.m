//
//  登陆界面
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
#import "HomeViewController.h"

@interface LoginViewController ()
{
    UITextField *_phoneNumbrInputView;
    UITextField *_passwordInputView;
    UIButton *_showPwdButton;
    
    UIAlertView *remoteAlertView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    if([UserInfo share].mobile && [UserInfo share].mobile.length > 0) {
         _phoneNumbrInputView.text = [UserInfo share].mobile;
    }
    if([UserInfo share].password && [UserInfo share].password.length > 0) {
        _passwordInputView.text = [UserInfo share].password;
    }
    
}

- (void)initView
{

    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    rootView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:rootView];
    
    
    // 上面的图片
    CGFloat imageViewH = 200.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imageViewH)];
    imageView.backgroundColor = [UIColor redColor];
    [rootView addSubview:imageView];
    
    
    // 手机号
    CGFloat editViewPaddingTop = 50.0;
    CGFloat editViewPaddingLeftRight = 20.0;
    CGFloat editViewH = 64.0;
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
    
    
  
    // 密码
    CGFloat PWDeditViewPaddingTop = 10.0;
    UIView *PWDRootView = [[UIView alloc] initWithFrame:CGRectMake(editViewPaddingLeftRight, imageViewH + editViewPaddingTop + editViewH + PWDeditViewPaddingTop, editViewW, editViewH)];
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
    [showPWDView addTarget:self action:@selector(showPWDButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    _showPwdButton = showPWDView;
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"输入密码";
    PWDInputView.secureTextEntry = YES;
    _passwordInputView = PWDInputView;
    [PWDRootView addSubview:PWDInputView];
    // 分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, editViewH - 1, editViewW, 1)];
    lineView2.backgroundColor = [UIColor blackColor];
    [PWDRootView addSubview:lineView2];
    
    
    
    // 忘记密码
    CGFloat forgetPWDViewW = 100.0;
    CGFloat forgetPWDViewH = 45.0;
    UIButton *forgetPWDView = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - editViewPaddingLeftRight - forgetPWDViewW, PWDRootView.frame.origin.y + PWDRootView.frame.size.height + 5, forgetPWDViewW, forgetPWDViewH)];
    [forgetPWDView setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPWDView addTarget:self action:@selector(forgetPWDButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:forgetPWDView];
    
    
    
    // 注册／登陆
    CGFloat registerAndLoginBtnRootViewH = 64.0;
    CGFloat registerAndLoginBtnRootViewW = editViewW;
    CGFloat registerAndLoginBtnRootViewSpace = 20.0;
    CGFloat registerAndLoginBtnRootViewX = editViewPaddingLeftRight;
    CGFloat registerAndLoginBtnRootViewY = kScreenHeight - 100.0 - registerAndLoginBtnRootViewH;
    UIView *registerAndLoginBtnRootView = [[UIView alloc]initWithFrame:CGRectMake(registerAndLoginBtnRootViewX, registerAndLoginBtnRootViewY, registerAndLoginBtnRootViewW, registerAndLoginBtnRootViewH)];
    registerAndLoginBtnRootView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:registerAndLoginBtnRootView];
    // 注册
    CGFloat buttonW = (registerAndLoginBtnRootViewW - registerAndLoginBtnRootViewSpace)/2;
    UIButton *registerBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonW, registerAndLoginBtnRootViewH)];
    [registerBtnView setTitle:@"注册" forState:UIControlStateNormal];
    registerBtnView.backgroundColor = [UIColor blueColor];
    [registerBtnView addTarget:self action:@selector(registerButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:registerBtnView];
    // 登陆
    UIButton *loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + registerAndLoginBtnRootViewSpace, 0, buttonW, registerAndLoginBtnRootViewH)];
    [loginBtnView setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtnView.backgroundColor = [UIColor orangeColor];
    [loginBtnView addTarget:self action:@selector(loginButtonClickInLogin) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:loginBtnView];
    
    
}


#pragma mark - 按钮点击处理

// 显示密码按钮点击
- (void)showPWDButtonClickInLogin
{
    NSLog(@"showPWDButtonClickInLogin");
    _passwordInputView.secureTextEntry = !_passwordInputView.secureTextEntry;
    _showPwdButton.backgroundColor = _passwordInputView.secureTextEntry ? [UIColor blueColor] : [UIColor redColor];
}


// 忘记密码按钮点击
- (void)forgetPWDButtonClickInLogin
{
    NSLog(@"forgetPWDButtonClickInLogin");
}


// 注册按钮点击
- (void)registerButtonClickInLogin
{
    NSLog(@"registerButtonClickInLogin");
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}


// 登陆按钮点击
- (void)loginButtonClickInLogin
{
    NSLog(@"loginButtonClickInLogin");

    
    NSString *phoneNumber = _phoneNumbrInputView.text;
    NSString *password = _passwordInputView.text;
    BOOL isPhoneNumberRight = [Utils checkMobile: phoneNumber];
    BOOL isPasswordRight = [Utils checkPassWord: password];
    
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

    
    // 登陆
    [self beginLogin:phoneNumber password:password];
}


#pragma mark - other

// 登陆
- (void)beginLogin:(NSString *)phoneNumber password:(NSString *)password
{
    [self remoteAnimation:@"正在登陆, 请稍候..."];
    
    NSLog(@"登陆，手机：%@, 密码：%@ ", phoneNumber, password);
    
    NSDictionary *dictionary = @{@"mobile": phoneNumber,
                                 @"password": password
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_LOGIN
                              urlString:URL_LOGIN
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [remoteAlertView dismissWithClickedButtonIndex:0 animated:YES];
         });
         
         
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             NSLog(@"登陆成功！");
             
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
             
             
             
             // 进入主页
             HomeViewController *homeViewController = [[HomeViewController alloc] init];
             [self.navigationController pushViewController:homeViewController animated:YES];
             
         } else {
             
             NSLog(@"登陆失败！");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[obj objectForKey:HTTP_KEY_RESULTMESSAGE] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
