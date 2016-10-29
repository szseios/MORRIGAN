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
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    [self setUpBarView];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemCancel withTitle:@"意见反馈"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
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

- (void)clickBingdingDevice
{
    NSLog(@"绑定设备");
}



#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hiddenLabel];
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
