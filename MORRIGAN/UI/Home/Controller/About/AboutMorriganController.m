//
//  AboutMorriganController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "AboutMorriganController.h"
#import "WebInfoController.h"

@interface AboutMorriganController () <UITableViewDelegate, UITableViewDataSource,BasicBarViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;

@property (nonatomic , strong) BasicBarView *barView;

@end

@implementation AboutMorriganController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    // Do any additional setup after loading the view from its nib.
    [_aboutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self setUpBarView];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"我的资料"];
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
    NSLog(@"绑定设备");
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"产品团队";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"服务条例";
        }
            break;
            
        case 2:
        {
            cell.textLabel.text = @"隐私政策";
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