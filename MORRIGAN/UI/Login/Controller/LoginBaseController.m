//
//  LoginBaseController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "LoginBaseController.h"

@interface LoginBaseController ()
{

}

@end

@implementation LoginBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 注册通知
    [self addNotification];
}


- (void)initView
{
    // 键盘收起条
    self.keyboardTopView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self.keyboardTopView setBarStyle:UIBarStyleDefault];
    self.keyboardTopView.backgroundColor = [UIColor whiteColor];
    self.keyboardTopView.alpha = 0.9;
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
    [self.keyboardTopView setItems:buttonsArray];
    
  
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.rootView.backgroundColor = [Utils stringTOColor:kColor_6911a5];
    [self.view addSubview:self.rootView];
    self.rootScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.rootScroolView addSubview:self.rootView];
    self.rootScroolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.rootScroolView.scrollEnabled = NO;
    [self.view addSubview:self.rootScroolView];
}


#pragma mark - 键盘弹出／隐藏

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect f = _rootScroolView.frame;
    f.size.height = kScreenHeight - height;
    _rootScroolView.frame = f;
    _rootScroolView.scrollEnabled = YES;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect f = _rootScroolView.frame;
    f.size.height = kScreenHeight;
    _rootScroolView.frame = f;
    _rootScroolView.scrollEnabled = NO;
}


- (void)addNotification
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)closeKeyboard{
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        [win endEditing:YES];
    }
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
