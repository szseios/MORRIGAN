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

@interface RootViewController () <UIGestureRecognizerDelegate,HomePageControllerDelegate,PersonalControllerDelegate>

@property (nonatomic , strong) HomePageController *homeCtl;

@property (nonatomic , strong) PersonalController *personCtl;

@property (nonatomic , strong) UIViewController *currentCtl;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:self.navigationController.view.bounds];
    backgroudView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didregisterUser) name:kRecordManagerUploadEndNotification object:nil];
    
    [self.view addSubview:backgroudView];
    
    _homeCtl = [[HomePageController alloc] init];
    _homeCtl.delegate = self;
    [self addChildViewController:_homeCtl];
    
    _personCtl = [[PersonalController alloc] init];
    _personCtl.delegate = self;
    [self addChildViewController:_personCtl];
    
    [self.view addSubview:_personCtl.view];
    [self.view addSubview:_homeCtl.view];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)leftClick
{
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform newTransform =
        CGAffineTransformScale(_homeCtl.view.transform, 0.9, 0.9);
        [_homeCtl.view setTransform:newTransform];
        _homeCtl.view.x = kScreenWidth-80;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)rightClick
{
    [UIView animateWithDuration:0.3 animations:^{
        _homeCtl.view.x = 0;
        CGAffineTransform newTransform = CGAffineTransformConcat(_homeCtl.view.transform,  CGAffineTransformInvert(_homeCtl.view.transform));
        _homeCtl.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
        [_homeCtl.view setTransform:newTransform];
    } completion:^(BOOL finished) {
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
                AboutMorriganController *aboutCtl = [[AboutMorriganController alloc] init];
                [self.navigationController pushViewController:aboutCtl animated:YES];
            }
                break;
            case 1:
            {
                SuggestionController *suggestCtl = [[SuggestionController alloc] init];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self registerUser];
    }
}

- (void)registerUser
{
    // 上传护理记录数据
    [[RecordManager share] uploadDBDatas:YES];
    [MBProgressHUD showHUDAddedTo:UI_Window animated:YES];
    
   
}

- (void)didregisterUser
{
    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId?[UserInfo share].userId:@""
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_CANCEL_MOLI
                              urlString:URL_CANCEL_MOLI
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         [MBProgressHUD hideAllHUDsForView:UI_Window animated:YES];
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             
             [MBProgressHUD showHUDByContent:@"注销成功！" view:UI_Window afterDelay:2];
             NSLog(@"注销成功！");
             [UserInfo share].mobile = @"";
             [UserInfo share].password = @"";
             // 注销登陆成功时调用这个
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults removeObjectForKey:kUserDefaultIdKey];
             [defaults removeObjectForKey:kUserDefaultPasswordKey];
             LoginViewController *loginViewController = [[LoginViewController alloc] init];
             [self.navigationController pushViewController:loginViewController animated:NO];
         }else{
             [MBProgressHUD showHUDByContent:@"注销失败！" view:UI_Window afterDelay:2];
         }
         
         
     }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
