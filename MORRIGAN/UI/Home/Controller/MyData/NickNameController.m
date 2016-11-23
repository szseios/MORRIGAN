//
//  NickNameControllerViewController.m
//  MORRIGAN
//
//  Created by azz on 2016/10/16.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "NickNameController.h"

@interface NickNameController ()<BasicBarViewDelegate>

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) BasicBarView *barView;

@end

@implementation NickNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 84, kScreenWidth - 40, 30)];
    [self.view addSubview:_textField];
    _textField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    _textField.clipsToBounds = YES;
    _textField.layer.cornerRadius = 5;
    
    if ([UserInfo share].nickName.length > 0) {
        _textField.text = [UserInfo share].nickName;
    }else{
        _textField.placeholder = @"请输入昵称";
    }
    
    [self setUpBarView];
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemCancel withTitle:@"修改昵称" isShowRightButton:YES];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}
#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEnsure
{
    if (_textField.text.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGENICKNAME object:_textField.text];
        [UserInfo share].nickName = _textField.text;
        [self uploadPersonalData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)uploadPersonalData
{
        NSDictionary *dictionary = @{
                                     @"userId":[UserInfo share].userId,
                                     @"nickName":[UserInfo share].nickName
                                     };
        NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
        [[NMOANetWorking share] taskWithTag:ID_EDIT_USERINFO
                                  urlString:URL_EDIT_USERINFO
                                   httpHead:nil
                                 bodyString:bodyString
                         objectTaskFinished:^(NSError *error, id obj)
         {
             if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
                 [MBProgressHUD showHUDByContent:@"修改个人信息成功！" view:UI_Window afterDelay:2];
                 NSLog(@"修改个人信息成功！");
             }else{
                 [MBProgressHUD showHUDByContent:@"修改个人信息失败！" view:UI_Window afterDelay:2];
             }
             
             
         }];
}
    
    
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:NickNameController");
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
