//
//  WebInfoController.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "WebInfoController.h"

@interface WebInfoController () <BasicBarViewDelegate>

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) NSString *webTitle;

@property (nonatomic , strong) NSString *urlStr;

@property (nonatomic , strong) UIWebView *webView;

@end

@implementation WebInfoController

- (instancetype)initWithTitle:(NSString *)title webURL:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _webTitle = title;
        _urlStr = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    
    [self setUpBarView];
    
    NSURLCache *cahces = [NSURLCache sharedURLCache];
    [cahces removeAllCachedResponses];
    [cahces setDiskCapacity:0];
    [cahces setMemoryCapacity:0];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_webView];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:_urlStr ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
    
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:_webTitle];
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
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
