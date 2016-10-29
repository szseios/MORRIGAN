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
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, kScreenWidth - 50, 30)];
    [self.view addSubview:_textField];
    if ([UserInfo share].nickName.length > 0) {
        _textField.text = [UserInfo share].nickName;
    }else{
        _textField.placeholder = @"请输入昵称";
    }
    
    [self setUpBarView];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"我的资料"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}
#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBingdingDevice
{
    NSLog(@"绑定设备");
}

- (void)rightBarButtonClick
{
    if (_textField.text.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGENICKNAME object:_textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
