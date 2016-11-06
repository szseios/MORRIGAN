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
#import "SetTargetController.h"
#import "MyDataController.h"
#import "AboutMorriganController.h"
#import "SuggestionController.h"
#import "RelateDeviceController.h"
#import "HistoryDataController.h"
#import "LoginViewController.h"

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

@interface RootViewController () <UIGestureRecognizerDelegate,HomePageControllerDelegate,PersonalControllerDelegate>

@property (nonatomic , strong) HomePageController *homeCtl;

@property (nonatomic , strong) PersonalController *personCtl;

@property (nonatomic , strong) UIViewController *currentCtl;

@property (nonatomic , strong) UIImageView *rightImageView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:self.navigationController.view.bounds];
    backgroudView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backgroudView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToHomePage) name:MOVETOHOMEPAGENOTIFICATION object:nil];
    
    _homeCtl = [[HomePageController alloc] init];
    _homeCtl.delegate = self;
    [self addChildViewController:_homeCtl];
    
    _personCtl = [[PersonalController alloc] init];
    _personCtl.delegate = self;
//    _personCtl.view.x = -kScreenWidth * 3 / 4;
    [self addChildViewController:_personCtl];
    
    [self.view addSubview:_personCtl.view];
    [self.view addSubview:_homeCtl.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [UIView animateWithDuration:0.3 animations:^{
        
        _homeCtl.view.x = kScreenWidth * 3 / 4;
//        _personCtl.view.x = 0;
    } completion:^(BOOL finished) {

    }];
}

- (void)back
{
    [UIView animateWithDuration:0.3 animations:^{
//        _homeCtl.view.x = 0;
        _personCtl.view.x = -kScreenWidth * 3 / 4;
    } completion:^(BOOL finished) {
        _rightImageView.hidden = YES;
        _rightImageView = nil;
    }];
}


- (void)rightClick
{
    [UIView animateWithDuration:0.3 animations:^{
        _homeCtl.view.x = 0;
//        _personCtl.view.x = -kScreenWidth * 3 / 4;
    } completion:^(BOOL finished) {
        _rightImageView.hidden = YES;
        _rightImageView = nil;
    }];
}

#pragma mark - PersonalControllerDelegate

- (void)didSelectCellWithIndexPath:(NSIndexPath *)index
{
    if (index.section == 0) {
        switch (index.row) {
            case 0:
            {
                MyDataController *myDataCtl = [[MyDataController alloc] init];
                myDataCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myDataCtl animated:YES];
            }
                break;
            case 1:
            {
                SetTargetController *targetCtl = [[SetTargetController alloc] init];
                targetCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:targetCtl animated:YES];
            }
                break;
                
            case 2:
            {
                HistoryDataController *historyCtl = [[HistoryDataController alloc] init];
                historyCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:historyCtl animated:YES];
            }
                break;
                
            case 3:
            {
                RelateDeviceController *relateCtl = [[RelateDeviceController alloc] init];
                relateCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:relateCtl animated:YES];
            }
                break;
                
                
            default:
                break;
        }
    }
    else{
        switch (index.row) {
            case 0:
            {
                AboutMorriganController *aboutCtl = [[AboutMorriganController alloc] initWithTitle:@"关于MORRIGAN" showBackButton:YES showRightButton:YES rightButtonImageName:@"icon_rightItem_link" backButtonImageName:@"icon_rightArrow"];
                [self.navigationController pushViewController:aboutCtl animated:YES];
            }
                break;
            case 1:
            {
                SuggestionController *suggestCtl = [[SuggestionController alloc] initWithTitle:@"意见反馈" showBackButton:YES showRightButton:YES rightButtonText:@"确定" backButtonText:@"取消"];
                [self.navigationController pushViewController:suggestCtl animated:YES];
            }
                break;
                
            case 2:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销用户信息" message:@"注销后此账号将删除所有有关信息，只能通过重新注册才能登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
                [alert show];
            }
                break;
                
                
            default:
                break;
        }
    }

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
