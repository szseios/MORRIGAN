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

@interface HistoryDataController () <BasicBarViewDelegate,UITableViewDelegate,UITableViewDataSource,PNChartDelegate>

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) UISegmentedControl *pageSegmente;

@property (nonatomic , strong) UITableView *bottomTableView;

@property (nonatomic , strong) NSArray *titleArray;

@property (nonatomic , strong) UIView *dayView;

@property (nonatomic , strong) UIView *weekView;

@property (nonatomic , strong) PNBarChart *dayBarChat;

@property (nonatomic , strong) PNBarChart *weekBarChat;

@property (nonatomic , strong) UILabel *minuteDataLabel;

@property (nonatomic , strong) UILabel *dateLabel;

@property (nonatomic , strong) UILabel *weekMinuteDataLabel;

@property (nonatomic , strong) UILabel *weekDateLabel;

@property (nonatomic , strong) NSMutableArray *weekDataArray;

@end

@implementation HistoryDataController

static NSString *cellID = @"DataCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 114)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    [self getDataFromService];
    _titleArray = @[@"今日目标",@"今日护养",@"剩余目标值"];
    
    [self setUpBarView];
    [self setUpSegmentPageView];
    [self setUpDayBarChatView];
    [self setUpWeekBarChatView];
    [self setUpBottomView];
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
}

- (void)getDataFromService
{
    _weekDataArray = [NSMutableArray array];
    
    __weak HistoryDataController *blockSelf = self;
    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_GET_RECORD urlString:URL_GET_RECORD httpHead:nil bodyString:bodyString objectTaskFinished:^(NSError *error, id obj) {
        
        if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
            NSArray *hlarray = [obj objectForKey:@"hlInfo"];
            if (hlarray) {
                for (NSDictionary *dict in hlarray) {
                    NSString *timeLong = [dict objectForKey:@"timeLong"];
                    [blockSelf.weekDataArray addObject:timeLong];
                }
            }
        }else{
            [MBProgressHUD showHUDByContent:[obj objectForKey:@"retMsg"] view:UI_Window afterDelay:2];
        }
    }];

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
    [_pageSegmente setFrame:CGRectMake(40, 74, kScreenWidth - 80, 30)];
    [self.view addSubview:_pageSegmente];
    [_pageSegmente setTintColor:[UIColor whiteColor]];
    [_pageSegmente setBackgroundImage:[UIImage imageNamed:@"basicBackground"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [_pageSegmente addTarget:self action:@selector(changeToDayOrWeek:) forControlEvents:UIControlEventValueChanged];
    [_pageSegmente setSelectedSegmentIndex:0];
}

- (void)setUpDayBarChatView
{
    UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, kScreenWidth, 250)];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:chatView.bounds];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [chatView addSubview:backImageView];
    [self.view addSubview:chatView];
    
    _dayView = [[UIView alloc] initWithFrame:chatView.frame];
    _dayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dayView];
    
    CGFloat labelY = 0;
    _minuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY, 60, 60)];
    _minuteDataLabel.textColor = [UIColor whiteColor];
    _minuteDataLabel.textAlignment = NSTextAlignmentRight;
    _minuteDataLabel.font = [UIFont systemFontOfSize:35];
    _minuteDataLabel.text = @"88";
    [_dayView addSubview:_minuteDataLabel];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 40, 30)];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = @"分钟";
    [_dayView addSubview:unitLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, kScreenWidth - 120, 30)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy年MM月dd号"];
    NSString *dateStr = [fomatter stringFromDate:[NSDate date]];
    _dateLabel.text = dateStr;
    [_dayView addSubview:_dateLabel];
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    CGFloat dayBarViewH = 180;
    CGFloat dayBarViewY = 50;
    _dayBarChat = [[PNBarChart alloc] initWithFrame:CGRectMake(10, dayBarViewY, kScreenWidth-20, dayBarViewH)];
    _dayBarChat.backgroundColor = [UIColor clearColor];
    _dayBarChat.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    _dayBarChat.yChartLabelWidth = 0.0;
    _dayBarChat.chartMarginLeft = 0.0;
    _dayBarChat.chartMarginRight = 0.0;
    _dayBarChat.chartMarginTop = 0.0;
    _dayBarChat.chartMarginBottom = 5.0;
    _dayBarChat.xLabelSkip = 6;
    _dayBarChat.labelMarginTop = 0.0;
    _dayBarChat.showChartBorder = YES;
    _dayBarChat.yMaxValue = 60;
    [_dayBarChat setXLabels:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24]];
    
    [_dayBarChat setYValues:@[@0,@0,@0,@0,@0.0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0]];
    [_dayBarChat setStrokeColor:PNWhite];
    [_dayBarChat strokeChart];
    
    _dayBarChat.delegate = self;
    [_dayView addSubview:_dayBarChat];
}

- (void)setUpWeekBarChatView
{
    _weekView = [[UIView alloc] initWithFrame:_dayView.frame];
    _weekView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weekView];
    
    _weekMinuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
    _weekMinuteDataLabel.textColor = [UIColor whiteColor];
    _weekMinuteDataLabel.textAlignment = NSTextAlignmentRight;
    _weekMinuteDataLabel.font = [UIFont systemFontOfSize:35];
    _weekMinuteDataLabel.text = @"__";
    [_weekView addSubview:_weekMinuteDataLabel];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 40, 30)];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = @"分钟";
    [_weekView addSubview:unitLabel];
    
    _weekDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, kScreenWidth - 120, 30)];
    _weekDateLabel.textColor = [UIColor whiteColor];
    _weekDateLabel.textAlignment = NSTextAlignmentRight;
    _weekDateLabel.text = [self currentWeekFirstDayToLastDay];
    [_weekView addSubview:_weekDateLabel];
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    CGFloat dayBarViewH = 180;
    CGFloat dayBarViewY = 50;
    _weekBarChat = [[PNBarChart alloc] initWithFrame:CGRectMake(10, dayBarViewY, kScreenWidth-20, dayBarViewH)];
    _weekBarChat.backgroundColor = [UIColor clearColor];
    _weekBarChat.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    _weekBarChat.yChartLabelWidth = 0.0;
    _weekBarChat.chartMarginLeft = 0.0;
    _weekBarChat.chartMarginRight = 0.0;
    _weekBarChat.chartMarginTop = 0.0;
    _weekBarChat.chartMarginBottom = 5.0;
    _weekBarChat.labelMarginTop = 0.0;
    _weekBarChat.showChartBorder = YES;
    _weekBarChat.isShowWeekLabel = YES;
    _weekBarChat.yMaxValue = 60;
    [_weekBarChat setXLabels:@[@1,@2,@3,@4,@5,@6,@7]];
    if (_weekDataArray.count > 0) {
       [_weekBarChat setYValues:_weekDataArray];
    }else{
        if (_weekDataArray && _weekDataArray.count == 7) {
            [_weekBarChat setYValues:_weekDataArray];
        }else{
          [_weekBarChat setYValues:@[@0,@0,@0,@0,@0,@0,@0]];
        }
        
    }
    [_weekBarChat setStrokeColor:PNWhite];
    [_weekBarChat strokeChart];
    
    _weekBarChat.delegate = self;
    [_weekView addSubview:_weekBarChat];
    _weekView.hidden = YES;
    
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

- (NSString *)currentWeekFirstDayToLastDay
{
    NSInteger week;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    week = [comps weekday];
    NSInteger backCount;
    NSInteger aheadCount;
    switch (week) {
        case 0:
        {
            backCount = 7;
            aheadCount = 0;
        }
            break;
        case 1:
        {
            backCount = 6;
            aheadCount = 1;
        }
            break;
            
        case 2:
        {
            backCount = 5;
            aheadCount = 2;
        }
            break;
            
        case 3:
        {
            backCount = 4;
            aheadCount = 3;
        }
            break;
            
        case 4:
        {
            backCount = 3;
            aheadCount = 4;
        }
            break;
            
        case 5:
        {
            backCount = 2;
            aheadCount = 5;
        }
            break;
            
        case 6:
        {
            backCount = 1;
            aheadCount = 6;
        }
            break;
            
        default:
            break;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *backDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*backCount];
    NSDate *aheadDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*aheadCount];
    NSString *backStr = [formatter stringFromDate:backDate];
    NSString *aheadStr = [formatter stringFromDate:aheadDate];
    NSString *currentStr = [NSString stringWithFormat:@"%@-%@",backStr,aheadStr];
    return currentStr;
}



- (void)changeToDayOrWeek:(UISegmentedControl *)sender
{
    NSInteger buttonIndex = sender.selectedSegmentIndex;
    if (buttonIndex == 0) {
        _dayView.hidden = NO;
        _weekView.hidden = YES;
        _titleArray = @[@"今日目标",@"今日护养",@"剩余目标值"];
        [_bottomTableView reloadData];
    }else{
        _dayView.hidden = YES;
        _weekView.hidden = NO;
        _titleArray = @[@"今日目标",@"今日护养",@"剩余目标值",@"平均养护"];
        [_bottomTableView reloadData];
    }
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:HistoryDataController");
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
