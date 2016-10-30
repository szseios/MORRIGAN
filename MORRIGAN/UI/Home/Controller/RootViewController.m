//
//  RootViewController.m
//  MOLIPageDemo
//
//  Created by azz on 2016/10/15.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "RootViewController.h"
#import "HomePageController.h"
#import "PersonalController.h"
#import "HomePageSuperController.h"

@interface UIImageView (backImageMove)

- (void)setViewCopiedImage:(UIView *)view;

@end

@implementation UIImageView (backImageMove)

- (void)setViewCopiedImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 4);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end

@interface RootViewController () <UIGestureRecognizerDelegate,HomePageControllerDelegate>

@property (nonatomic , strong) HomePageController *homeCtl;

@property (nonatomic , strong) PersonalController *personCtl;

@property (nonatomic , strong) UIViewController *currentCtl;

@property (nonatomic , strong) UIImageView *rightImageView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroudView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:backgroudView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToHomePage) name:MOVETOHOMEPAGENOTIFICATION object:nil];
    
    _homeCtl = [[HomePageController alloc] init];
    _homeCtl.delegate = self;
    [self addChildViewController:_homeCtl];
    
    _personCtl = [[PersonalController alloc] init];
    [self addChildViewController:_personCtl];
    
    [self.view addSubview:_personCtl.view];
    [self.view addSubview:_homeCtl.view];
}


- (void)moveToHomePage
{
    _personCtl.view.alpha = 0;
    [self.view addSubview:_homeCtl.view];
    [self.view insertSubview:_personCtl.view belowSubview:_homeCtl.view];
//    _personCtl.view.alpha = 1;
}

- (void)leftClick
{
    _rightImageView = [[UIImageView alloc] initWithFrame:self.navigationController.view.bounds];
    [_rightImageView setViewCopiedImage:self.navigationController.view];
    [self.navigationController.view addSubview:_rightImageView];
    _personCtl.view.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        
        [_homeCtl.view removeFromSuperview];
        _rightImageView.y = 20;
        _rightImageView.x = 300;
    } completion:^(BOOL finished) {
        [_personCtl setRightImage:_rightImageView.image];
        _rightImageView.hidden = YES;
        _rightImageView = nil;
        [_rightImageView removeFromSuperview];
        [_homeCtl.view removeFromSuperview];
    }];
}


- (void)rightClick
{
    
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
