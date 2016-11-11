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

@property (nonatomic , strong) UILabel *nameLabel;

@property (nonatomic , strong) UIImageView *headerImageView;

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
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 35, 80, 80)];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = 40;
//    headerImageView.image = [UIImage imageNamed:@"defaultHeaderView"];
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].imgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeaderView"] options:SDWebImageHandleCookies | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeaderImage)];
//    [_headerImageView addGestureRecognizer:tap];
    [_headerView addSubview:_headerImageView];
    
    CGFloat nameLabelY = _headerImageView.height / 2 + 15;
    _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(120, nameLabelY, cellWidth - 120, 40)];
    _nameLabel.text = [UserInfo share].nickName ? [UserInfo share].nickName : @"";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_nameLabel];
    
    _personalTableView.tableHeaderView = _headerView;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nameLabel.text = [UserInfo share].nickName ? [UserInfo share].nickName : @"";
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].imgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeaderView"] options:SDWebImageHandleCookies | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)selectHeaderImage
{
    
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
