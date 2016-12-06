//
//  AboutMorriganController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "AboutMorriganController.h"
#import "WebInfoController.h"
#import "AboutMorriganCell.h"

@interface AboutMorriganController () <UITableViewDelegate, UITableViewDataSource,BasicBarViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;

@property (nonatomic , strong) BasicBarView *barView;

@end

@implementation AboutMorriganController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    
    // Do any additional setup after loading the view from its nib.
    [_aboutTableView registerNib:[UINib nibWithNibName:@"AboutMorriganCell" bundle:nil] forCellReuseIdentifier:cellID];
    _aboutTableView.tableFooterView = [UIView new];
    _aboutTableView.bounces = NO;
    [self setUpBarView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果没有连上蓝牙设备,开始执行动画
    if (![BluetoothManager share].isConnected) {
        [_barView startFlashing];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_barView stopFlashing];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"关于MORRIGAN" isShowRightButton:YES];
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


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutMorriganCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AboutMorriganCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"产品团队";
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"服务条例";
        }
            break;
            
        case 2:
        {
            cell.titleLabel.text = @"隐私政策";
        }
            break;

            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.aboutTableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            WebInfoController *productCtl = [[WebInfoController alloc] initWithTitle:@"产品团队" webURL:@"product-team"];
            productCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productCtl animated:YES];
        }
            break;
        case 1:
        {
            WebInfoController *productCtl = [[WebInfoController alloc] initWithTitle:@"服务条例" webURL:@"service"];
            productCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productCtl animated:YES];
        }
            break;
            
        case 2:
        {
            WebInfoController *productCtl = [[WebInfoController alloc] initWithTitle:@"隐私政策" webURL:@"private"];
            productCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productCtl animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:AboutMorriganController");
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
