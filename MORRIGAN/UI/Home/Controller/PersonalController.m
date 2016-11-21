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
#import "PersonalCell.h"


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
    
    CGFloat cellWidth = kScreenWidth-80;
    _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,cellWidth ,self.view.height) style:UITableViewStyleGrouped];
    _personalTableView.delegate = self;
    _personalTableView.dataSource = self;
    _personalTableView.backgroundColor = [UIColor clearColor];
    [_personalTableView registerNib:[UINib nibWithNibName:@"PersonalCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:_personalTableView];
    
    //headerView
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 103)];
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 37, 51, 51)];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.width / 2;
//    headerImageView.image = [UIImage imageNamed:@"defaultHeaderView"];
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].imgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeaderView"] options:SDWebImageHandleCookies | SDWebImageRetryFailed | SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [_headerView addSubview:_headerImageView];
    
    CGFloat nameLabelY = _headerImageView.height / 2 + 17;
    CGFloat nameLabelX = CGRectGetMaxX(_headerImageView.frame) + 17;
    _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(nameLabelX, nameLabelY, cellWidth - nameLabelX, 34)];
    _nameLabel.text = [UserInfo share].nickName ? [UserInfo share].nickName : @"";
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textColor = [Utils stringTOColor:@"#ffffff"];
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
    PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (!cell) {
        cell = [[PersonalCell alloc] init];
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"我的资料";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_header"];
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"设定目标";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_setTarget"];
            }
                break;
                
            case 2:
            {
                cell.titleLabel.text = @"历史记录";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_history"];
            }
                break;
                
            case 3:
            {
                cell.titleLabel.text = @"关联设备";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_linkDevice"];
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
                cell.titleLabel.text = @"关于摩莉";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_aboutMORRIGAN"];
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"意见反馈";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_feekBack"];
            }
                break;
                
            case 2:
            {
                cell.titleLabel.text = @"注销用户信息";
                cell.leftImageView.image = [UIImage imageNamed:@"icon_logout"];
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
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth-80 , 32)];
    sectionView.backgroundColor = [Utils stringTOColor:@"#8d03d6"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 32)];
    label.textColor = [Utils stringTOColor:@"#ffffff"];
    label.alpha = 0.4;
    label.font = [UIFont systemFontOfSize:16];
    if (section == 0) {
        
        label.text = @"按摩时";
        
    }else{
        label.text = @"关于应用";
       
    }
    [sectionView addSubview:label];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
