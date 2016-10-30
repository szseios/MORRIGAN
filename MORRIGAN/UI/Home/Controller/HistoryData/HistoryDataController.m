//
//  HistoryDataController.m
//  MORRIGAN
//
//  Created by azz on 2016/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HistoryDataController.h"
#import "HistoryDataCell.h"
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface HistoryDataController () <BasicBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) UISegmentedControl *pageSegmente;

@property (nonatomic , strong) UITableView *bottomTableView;

@property (nonatomic , strong) NSArray *titleArray;

@property (nonatomic , strong) UIView *dayView;

@property (nonatomic , strong) UIView *weekView;

@end

@implementation HistoryDataController

static NSString *cellID = @"DataCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 104)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    _titleArray = @[@"今日目标",@"今日护养",@"剩余目标值"];
    
    [self setUpBarView];
    [self setUpSegmentPageView];
    [self setUpBarChatView];
    [self setUpBottomView];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"今日一览"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpSegmentPageView
{
    _pageSegmente = [[UISegmentedControl alloc] initWithItems:@[@"日",@"周"]];
    [_pageSegmente setFrame:CGRectMake(20, 64, kScreenWidth - 40, 30)];
    [self.view addSubview:_pageSegmente];
    [_pageSegmente setTintColor:[UIColor whiteColor]];
    [_pageSegmente setBackgroundImage:[UIImage imageNamed:@"basicBackground"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [_pageSegmente addTarget:self action:@selector(changeToDayOrWeek:) forControlEvents:UIControlEventValueChanged];
    [_pageSegmente setSelectedSegmentIndex:0];
}

- (void)setUpBarChatView
{
    UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, 250)];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:chatView.bounds];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [chatView addSubview:backImageView];
    [self.view addSubview:chatView];
    
    UIView *dayView = [[UIView alloc] initWithFrame:chatView.frame];
    dayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dayView];
    
    CGFloat labelY = 0;
    UILabel *minuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY, 60, 60)];
    minuteDataLabel.textColor = [UIColor whiteColor];
    minuteDataLabel.textAlignment = NSTextAlignmentRight;
    minuteDataLabel.font = [UIFont systemFontOfSize:35];
    minuteDataLabel.text = @"88";
    [dayView addSubview:minuteDataLabel];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 40, 30)];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = @"分钟";
    [dayView addSubview:unitLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, kScreenWidth - 120, 30)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy年MM月dd号"];
    NSString *dateStr = [fomatter stringFromDate:[NSDate date]];
    dateLabel.text = dateStr;
    [dayView addSubview:dateLabel];
    
}

- (void)setUpBottomView
{
    CGFloat tableViewY = 250 + 110;
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,tableViewY ,kScreenWidth , 200) style:UITableViewStylePlain];
    _bottomTableView.delegate = self;
    _bottomTableView.dataSource = self;
    [_bottomTableView registerNib:[UINib nibWithNibName:@"HistoryDataCell" bundle:nil] forCellReuseIdentifier:cellID];
    _bottomTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_bottomTableView];
}



- (void)changeToDayOrWeek:(UISegmentedControl *)sender
{
    
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

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell setTitle:_titleArray[indexPath.row] minuteCount:nil withIndexPath:indexPath];
    return cell;
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
