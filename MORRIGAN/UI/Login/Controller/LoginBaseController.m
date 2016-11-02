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
