//
//  GuideViewController.m
//  MORRIGAN
//
//  Created by azz on 2016/12/5.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "GuideViewController.h"
#import "GuidePageControl.h"
#import "RootViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) GuidePageControl *pageControll;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *imageArray = @[@"guide_1",@"guide_2",@"guide_3",@"guide_4"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.navigationController.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [_scrollView addSubview:imageView];
        
        if (i == 3) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth * i) + (kScreenWidth - 132) / 2, kScreenHeight- 86, 132, 44)];
            [button addTarget:self action:@selector(transToMORRIGAN) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"进入摩莉" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.tintColor = [UIColor whiteColor];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = button.height / 2;
            [button.layer setBorderWidth:1.0]; //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
            
            [button.layer setBorderColor:colorref];//边框颜色
            [_scrollView addSubview:button];
        }
    }
    
    _pageControll = [[GuidePageControl alloc] initWithFrame:CGRectMake(40, kScreenHeight - 124, kScreenWidth - 80, 30)];
    [self.navigationController.view addSubview:_pageControll];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < kScreenWidth) {
        [_pageControll setCurrentPage:0];
    }
    else if (offsetX >= kScreenWidth && offsetX < kScreenWidth *2){
        
        [_pageControll setCurrentPage:1];
        
    }else if (offsetX >= kScreenWidth*2 && offsetX < kScreenWidth *3) {
        
        [_pageControll setCurrentPage:2];
        
    }else if (offsetX >= kScreenWidth*3 && offsetX < kScreenWidth *4) {
        
        [_pageControll setCurrentPage:3];
        
    }
}

- (void)transToMORRIGAN
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SHOWGUIDEVIEW];;
    // 进入主页
    RootViewController *homeViewController = [[RootViewController alloc] init];
    
    [self.navigationController pushViewController:homeViewController animated:YES];
    
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    [_pageControll removeFromSuperview];
    _pageControll = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc");
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
