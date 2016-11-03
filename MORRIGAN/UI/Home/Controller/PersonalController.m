//
//  PersonalController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "PersonalController.h"
#import "AppDelegate.h"
#import "SetTargetController.h"
#import "MyDataController.h"
#import "AboutMorriganController.h"
#import "SuggestionController.h"
#import "RelateDeviceController.h"
#import "HistoryDataController.h"
#import "LoginViewController.h"


@interface PersonalController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic , strong) UITableView *personalTableView;

@property (nonatomic , strong) UIView *headerView;

@property (nonatomic , strong) UIImageView *rightImageView;

@end

@implementation PersonalController


static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroudView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backgroudView];
    
    CGFloat cellWidth = kScreenWidth * 3 / 4;
    _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,cellWidth ,self.view.height) style:UITableViewStyleGrouped];
    _personalTableView.delegate = self;
    _personalTableView.dataSource = self;
    _personalTableView.backgroundColor = [UIColor clearColor];
    [_personalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:_personalTableView];
    
    //headerView
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 120)];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 35, 80, 80)];
    headerImageView.clipsToBounds = YES;
    headerImageView.layer.cornerRadius = 40;
//    headerImageView.image = [UIImage imageNamed:@"defaultHeaderView"];
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].imgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeaderView"] options:SDWebImageHandleCookies | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeaderImage)];
    [headerImageView addGestureRecognizer:tap];
    [_headerView addSubview:headerImageView];
    
    CGFloat nameLabelY = headerImageView.height / 2 + 15;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(120, nameLabelY, cellWidth - 120, 40)];
    nameLabel.text = [UserInfo share].nickName;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:nameLabel];
    
    _personalTableView.tableHeaderView = _headerView;
    
    
}

- (void)selectHeaderImage
{
    
}

- (void)moveToBack
{
    [UIView animateWithDuration:0.3 animations:^{
        _rightImageView.x = 0;
        _rightImageView.y = 0;
    } completion:^(BOOL finished) {
        _rightImageView.hidden = YES;
        _rightImageView = nil;
        self.view.alpha = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MOVETOHOMEPAGENOTIFICATION object:nil];
        });
    }];
}

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 3 / 4, 20, kScreenWidth, kScreenHeight)];
    
    _rightImage = rightImage;
    _rightImageView.image = rightImage;
    [self.view addSubview:_rightImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToBack)];
    _rightImageView.userInteractionEnabled = YES;
    [_rightImageView addGestureRecognizer:tap];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"我的资料";
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"我的资料";
                cell.imageView.image = [UIImage imageNamed:@"icon_header"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"设定目标";
                cell.imageView.image = [UIImage imageNamed:@"icon_setTarget"];
            }
                break;
                
            case 2:
            {
                cell.textLabel.text = @"历史记录";
                cell.imageView.image = [UIImage imageNamed:@"icon_history"];
            }
                break;
                
            case 3:
            {
                cell.textLabel.text = @"关联设备";
                cell.imageView.image = [UIImage imageNamed:@"icon_linkDevice"];
            }
                break;

                
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"关于摩莉";
                cell.imageView.image = [UIImage imageNamed:@"icon_aboutMORRIGAN"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"意见反馈";
                cell.imageView.image = [UIImage imageNamed:@"icon_feekBack"];
            }
                break;
                
            case 2:
            {
                cell.textLabel.text = @"注销用户信息";
                cell.imageView.image = [UIImage imageNamed:@"icon_logout"];
            }
                break;

                
            default:
                break;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
    label.textColor = [UIColor whiteColor];
    if (section == 0) {
        
        label.text = @"按摩时";
        return label;
    }else{
        label.text = @"关于应用";
        return label;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellWithIndexPath:)]) {
        [self.delegate didSelectCellWithIndexPath:indexPath];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"move" object:nil];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
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
        switch (indexPath.row) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            
        }];
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
