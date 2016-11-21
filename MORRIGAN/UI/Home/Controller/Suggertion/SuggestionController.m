//
//  SuggestionController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "SuggestionController.h"

@interface SuggestionController ()<UITextViewDelegate,BasicBarViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;

@property (nonatomic , strong) BasicBarView *barView;

@end

@implementation SuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _suggestTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLabel) name:UITextViewTextDidChangeNotification object:nil];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    
    [self setUpBarView];
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
    [_suggestTextView becomeFirstResponder];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemCancel withTitle:@"意见反馈" isShowRightButton:YES];
    [self.view addSubview:_barView];
    _barView.delegate = self;
    [_barView setRightButtonEnable:NO];
}

- (void)hiddenLabel
{
    _holderLabel.hidden = YES;
}

#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEnsure
{
    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
                                 @"content": _suggestTextView.text ? _suggestTextView.text : @"",
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_FEEDBACK_MOLI urlString:URL_FEEDBACK_MOLI httpHead:nil bodyString:bodyString objectTaskFinished:^(NSError *error, id obj) {
        
        if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
            [MBProgressHUD showHUDByContent:@"反馈成功！" view:UI_Window afterDelay:2];
            NSLog(@"修改目标成功！");
        }else{
            [MBProgressHUD showHUDByContent:@"反馈失败！" view:UI_Window afterDelay:2];
        }
    }];
}



#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 70 || textView.text.length == 0) {
        [_barView setRightButtonEnable:NO];
    }else{
        [_barView setRightButtonEnable:YES];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hiddenLabel];
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:SuggestionController");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
