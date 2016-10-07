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


#define kManButtonTag     1001
#define kWomanButtonTag   1002



@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];

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
    manButton.backgroundColor = [UIColor greenColor];
    manButton.tag = kManButtonTag;
    [manButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
    [sexRootView addSubview:manButton];
    // 女士
    UIButton *womanButton = [[UIButton alloc] initWithFrame:CGRectMake(sexBtnLeftRightMarging + sexBtnH + setBtnSpace, secBtnY, sexBtnH, sexBtnH)];
    womanButton.backgroundColor = [UIColor greenColor];
    womanButton.tag = kWomanButtonTag;
    [womanButton addTarget:self action:@selector(sexButtonClickInRegister:) forControlEvents:UIControlEventTouchUpInside];
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
    [PWDRootView addSubview:showPWDView];
    // 密码输入框
    UITextField *PWDInputView = [[UITextField alloc] initWithFrame:CGRectMake(iconW + phoneinputViewPaddingLeft, 0, PWDRootView.frame.size.width - iconW - showPWDViewW - phoneinputViewPaddingLeft, editViewH)];
    PWDInputView.backgroundColor = [UIColor greenColor];
    PWDInputView.placeholder = @"设置密码";
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
            
        }
            break;
            
        case kWomanButtonTag:
        {
            
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
}

// 显示密码按钮点击
- (void)showPWDButtonClickInRegister
{
    NSLog(@"showPWDButtonClickInRegister");
}


// 注册按钮点击
- (void)registerButtonClickInRegister
{
    NSLog(@"registerButtonClickInRegister");
}


// 登陆按钮点击
- (void)loginButtonClickInRegister
{
    NSLog(@"loginButtonClickInRegister");
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
