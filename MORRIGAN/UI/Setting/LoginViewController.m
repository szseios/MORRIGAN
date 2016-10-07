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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];

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
    [showPWDView addTarget:self action:@selector(showPWDButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"输入密码";
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
    [forgetPWDView addTarget:self action:@selector(forgetPWDButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    [registerBtnView addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:registerBtnView];
    // 登陆
    UIButton *loginBtnView = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + registerAndLoginBtnRootViewSpace, 0, buttonW, registerAndLoginBtnRootViewH)];
    [loginBtnView setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtnView.backgroundColor = [UIColor orangeColor];
    [loginBtnView addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerAndLoginBtnRootView addSubview:loginBtnView];
    
    
}


#pragma mark - 按钮点击处理

// 显示密码按钮点击
- (void)showPWDButtonClick
{
    NSLog(@"showPWDButtonClick");
}


// 忘记密码按钮点击
- (void)forgetPWDButtonClick
{
    NSLog(@"forgetPWDButtonClick");
}


// 注册按钮点击
- (void)registerButtonClick
{
    NSLog(@"registerButtonClick");
}


// 登陆按钮点击
- (void)loginButtonClick
{
    NSLog(@"loginButtonClick");
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
