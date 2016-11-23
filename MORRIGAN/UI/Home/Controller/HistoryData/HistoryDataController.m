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
#import "MassageRecordModel.h"
#import "DBManager.h"

#define kWeekFormatDict @{@"0":@"周一",@"1":@"周二",@"2":@"周三",@"3":@"周四",@"4":@"周五",@"5":@"周六",@"6":@"周日",}


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

@property (nonatomic , strong) UILabel *weekUnitLabel;

@property (nonatomic , strong) UILabel *weekDateLabel;

@property (nonatomic , strong) NSMutableArray *weekBarViewArray;

@property (nonatomic , strong) NSMutableArray *weekDataArray;

@property (nonatomic , assign) NSInteger weekTarget;

@property (nonatomic , assign) NSInteger weekTimeLong;

@property (nonatomic , assign) BOOL loadRecordDataSucceed;





@end

@implementation HistoryDataController

static NSString *cellID = @"DataCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    
    _titleArray = @[@"今日目标",@"今日护养",@"剩余目标值"];
    [self setUpBarView];
    [self setUpSegmentPageView];
    [self setUpDayBarChatView];
    [self setUpWeekBarChatView];
    [self setUpBottomView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getDataFromService];
}

- (void)getDataFromService
{
 
    _weekDataArray = [NSMutableArray array];
    NSString *daStr = @"netWorkFinish";
    const char *queueName = [daStr UTF8String];
    dispatch_queue_t myQueue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(myQueue, ^{
        __weak HistoryDataController *blockSelf = self;
        NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
                                     };
        NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
        [[NMOANetWorking share] taskWithTag:ID_GET_RECORD urlString:URL_GET_RECORD httpHead:nil bodyString:bodyString objectTaskFinished:^(NSError *error, id obj) {
            
            if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
                NSArray *hlarray = [obj objectForKey:@"hlInfo"];
                NSLog(@"一周记录：%@",hlarray);
                if (hlarray) {
                    _loadRecordDataSucceed = YES;
                    for (NSDictionary *dict in hlarray) {
                        NSString *timeLong = [dict objectForKey:@"timeLong"];
                        NSString *goalLong = [dict objectForKey:@"goalLong"];
                        if([timeLong integerValue] > 180) {
                            timeLong = @"180";
                        }
                        if([goalLong integerValue] > 180) {
                            goalLong = @"180";
                        }
                        [blockSelf.weekDataArray addObject:timeLong];
                        _weekTarget = _weekTarget + [goalLong integerValue];
                        _weekTimeLong = _weekTimeLong + [timeLong integerValue];
                    }
                }
                
                // 更新周界面显示
                [self updateWeekBarView];
                [_bottomTableView reloadData];
                
                
                
            }else{
                _loadRecordDataSucceed = false;
                [MBProgressHUD showHUDByContent:[obj objectForKey:@"retMsg"] view:UI_Window afterDelay:2];
            }
        }];
        
    });

}

- (void)updateWeekBarView
{
    [_weekMinuteDataLabel removeFromSuperview];
    CGFloat labelY = 20;
    _weekMinuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelY, 60, 60)];
    _weekMinuteDataLabel.textColor = [UIColor whiteColor];
    _weekMinuteDataLabel.textAlignment = NSTextAlignmentRight;
    _weekMinuteDataLabel.font = [UIFont systemFontOfSize:35];
    _weekMinuteDataLabel.text = [NSString stringWithFormat:@"%ld", _weekTarget];
    [_weekMinuteDataLabel sizeToFit];
    [_weekView addSubview:_weekMinuteDataLabel];

    
    [_weekUnitLabel removeFromSuperview];
    CGFloat unitLabelX = CGRectGetMaxX(_weekMinuteDataLabel.frame) + 2;
    _weekUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(unitLabelX, labelY+10, 40, 30)];
    _weekUnitLabel.textColor = [UIColor whiteColor];
    _weekUnitLabel.text = @"分钟";
    [_weekView addSubview:_weekUnitLabel];
    
    NSInteger maxTimeLong = 0;
    NSInteger maxTimeLongIndex = 0;
    for (NSInteger i = 0; i < _weekDataArray.count; i++) {
        NSInteger timeLong = [_weekDataArray[i] integerValue];
        if(maxTimeLong < timeLong) {
            maxTimeLong = timeLong;
            maxTimeLongIndex = i;
        }
        
        CGRect frame = ((UIView *)_weekBarViewArray[i]).frame;
        frame.size.height = frame.size.height + timeLong*0.65;
        frame.origin.y =  frame.origin.y - timeLong*0.65;
        ((UIView *)_weekBarViewArray[i]).frame = frame;
    }
    
    
    // 在最大分钟数顶部添加label
    CGRect frame = ((UIView *)_weekBarViewArray[maxTimeLongIndex]).frame;
    frame.origin.y = frame.origin.y - 15;
    frame.size.height = 15;
    UILabel *secLabel = [[UILabel alloc] initWithFrame:frame];
    secLabel.text = [NSString stringWithFormat:@"%ld", maxTimeLong];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.font = [UIFont systemFontOfSize:10.0];
    [_weekView addSubview:secLabel];
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"今日一览" isShowRightButton:NO];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)setUpSegmentPageView
{
    _pageSegmente = [[UISegmentedControl alloc] initWithItems:@[@"日",@"周"]];
    [_pageSegmente setFrame:CGRectMake(15, 75, kScreenWidth - 30, 30)];
    [self.view addSubview:_pageSegmente];
    [_pageSegmente setTintColor:[UIColor whiteColor]];
    [_pageSegmente setBackgroundImage:[UIImage imageNamed:@"basicBackground"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    [_pageSegmente addTarget:self action:@selector(changeToDayOrWeek:) forControlEvents:UIControlEventValueChanged];
    [_pageSegmente setSelectedSegmentIndex:0];
}

- (void)setUpDayBarChatView
{
    
    UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth, 250)];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:chatView.bounds];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [chatView addSubview:backImageView];
    [self.view addSubview:chatView];
    
    _dayView = [[UIView alloc] initWithFrame:chatView.frame];
    _dayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dayView];
    
    CGFloat labelY = 20;
    _minuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelY, 60, 60)];
    _minuteDataLabel.textColor = [UIColor whiteColor];
    _minuteDataLabel.textAlignment = NSTextAlignmentRight;
    _minuteDataLabel.font = [UIFont systemFontOfSize:35];
     _minuteDataLabel.text = [UserInfo share].target ? [UserInfo share].target : @"--";
    [_minuteDataLabel sizeToFit];
   
    [_dayView addSubview:_minuteDataLabel];
    
    CGFloat unitLabelX = CGRectGetMaxX(_minuteDataLabel.frame) + 2;
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(unitLabelX, labelY+10, 40, 30)];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = @"分钟";
    [_dayView addSubview:unitLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, kScreenWidth - 120, 30)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy年MM月dd号"];
    NSString *dateStr = [fomatter stringFromDate:[NSDate date]];
    _dateLabel.text = dateStr;
    [_dayView addSubview:_dateLabel];
    
    CGFloat dayBarViewY = 210;
    CGFloat dayBarViewX = 10;
    CGFloat dayBarViewW = kScreenWidth - 20;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(dayBarViewX, dayBarViewY, dayBarViewW, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    [_dayView addSubview:lineView];
    
    CGFloat barX = (kScreenWidth - 20) / 24;
    CGFloat barW = barX/2;
    CGFloat mostBarH = dayBarViewY;
    NSDictionary *todatSecDict = [self getTodatSecDict];
    CGRect secLabelFame = CGRectMake(0, 0, 0, 0);
    NSInteger maxSec = 0;
    for (NSInteger i = 0; i < 24; i++) {
        NSString *hourKey = i+1 < 10 ? [NSString stringWithFormat:@"0%ld",i+1] : [NSString stringWithFormat:@"%ld",i+1];
        NSInteger sec = [[todatSecDict objectForKey:hourKey] integerValue];
        CGFloat h = sec*2.1 + 5;
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(barX * i+13, mostBarH - h, barW, h)];
        bar.backgroundColor = [UIColor whiteColor];
        bar.tag = 1000 + i;
        [_dayView addSubview:bar];
        
        // 保存最大分钟数时顶部label的frame
        if(sec > maxSec) {
            maxSec = sec;
            secLabelFame = CGRectMake(barX * i+13 - 3, mostBarH - h - 15 , barW + 7, 15.0);
        }
        
        if (i == 0 || i == 4 || i == 9 || i == 14 || i == 19 || i == 23 ) {
            UILabel *label = [self setUpLabelWithInteger:i];
            [_dayView addSubview:label];
        }
        
    }
    
    // 在最大分钟数顶部添加label
    UILabel *secLabel = [[UILabel alloc] initWithFrame:secLabelFame];
    secLabel.text = [NSString stringWithFormat:@"%ld", maxSec];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.font = [UIFont systemFontOfSize:10.0];
    [_dayView addSubview:secLabel];
}

- (UILabel *)setUpLabelWithInteger:(NSInteger)i
{
    CGFloat barLabelX = (kScreenWidth - 20) / 24;
    CGFloat addX = (i >= 9 ? 10 : 13);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(barLabelX * i + addX, 215, 30, 20)];
    label.text = (i == 23 ? [NSString stringWithFormat:@"%ld时",i+1] : [NSString stringWithFormat:@"%ld",i+1]);
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
//    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)setUpWeekBarChatView
{
    _weekView = [[UIView alloc] initWithFrame:_dayView.frame];
    _weekView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weekView];
    
    CGFloat labelY = 20;
    _weekMinuteDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelY, 60, 60)];
    _weekMinuteDataLabel.textColor = [UIColor whiteColor];
    _weekMinuteDataLabel.textAlignment = NSTextAlignmentRight;
    _weekMinuteDataLabel.font = [UIFont systemFontOfSize:35];
    _weekMinuteDataLabel.text = @"--";
    [_weekMinuteDataLabel sizeToFit];
    
    [_weekView addSubview:_weekMinuteDataLabel];
    
    CGFloat unitLabelX = CGRectGetMaxX(_weekMinuteDataLabel.frame) + 2;
    _weekUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(unitLabelX, labelY, 40, 30)];
    _weekUnitLabel.textColor = [UIColor whiteColor];
    _weekUnitLabel.text = @"分钟";
    [_weekView addSubview:_weekUnitLabel];
    
    _weekDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, kScreenWidth - 120, 30)];
    _weekDateLabel.textColor = [UIColor whiteColor];
    _weekDateLabel.textAlignment = NSTextAlignmentRight;
    _weekDateLabel.text = [self currentWeekFirstDayToLastDay];
    [_weekView addSubview:_weekDateLabel];
    
    CGFloat dayBarViewY = 210;
    CGFloat dayBarViewX = 10;
    CGFloat dayBarViewW = kScreenWidth - 20;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(dayBarViewX, dayBarViewY, dayBarViewW, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    [_weekView addSubview:lineView];
    
    CGFloat barX = 30/2;
    CGFloat barW = (kScreenWidth - 30) / (7 + 6);
    CGFloat mostBarH = dayBarViewY;
    for (NSInteger i = 0; i < 7; i++) {
        CGFloat h = 5;
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(barX, mostBarH - h, barW, h)];
        bar.backgroundColor = [UIColor whiteColor];
        bar.tag = 1000 + i;
        [_weekView addSubview:bar];
        
        // 保存每天的条状视图
        if(_weekBarViewArray == nil) {
            _weekBarViewArray = [NSMutableArray array];
        }
        [_weekBarViewArray addObject:bar];
        
        
        // 星期label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(barX, 215, barW, 20)];
        label.text = [kWeekFormatDict objectForKey:[NSString stringWithFormat:@"%ld" ,i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
        [_weekView addSubview:label];
    
        
        // 更新下一个条状视图水平位置
        barX = barX + 2*barW;
    }
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
    [_bottomTableView setBounces:NO];
    
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
        case 1:
        {
            backCount = 6;
            aheadCount = 0;
        }
            break;
            
        case 2:
        {
            backCount = 0;
            aheadCount = 5;
        }
            break;
            
        case 3:
        {
            backCount = 1;
            aheadCount = 5;
        }
            break;
            
        case 4:
        {
            backCount = 2;
            aheadCount = 4;
        }
            break;
            
        case 5:
        {
            backCount = 3;
            aheadCount = 3;
        }
            break;
            
        case 6:
        {
            backCount = 4;
            aheadCount = 2;
        }
            break;
        case 7:
        {
            backCount = 5;
            aheadCount = 1;
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
        [_barView setTitleLabelText:@"今日一览"];
    }else{
        _dayView.hidden = YES;
        _weekView.hidden = NO;
        _titleArray = @[@"本周目标",@"本周护养",@"剩余目标值",@"平均养护"];
        [_bottomTableView reloadData];
        [_barView setTitleLabelText:@"本周一阅"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *minuteCount = nil;
    switch (indexPath.row) {
        case 0:
        {
            minuteCount = _dayView.hidden == NO ? [UserInfo share].target : (_loadRecordDataSucceed ? [NSString stringWithFormat:@"%ld", _weekTarget] : nil);
 
        }
            break;
        case 1:
        {
            minuteCount = _dayView.hidden == NO ?  [self getTodaySecondsString] : (_loadRecordDataSucceed ? [NSString stringWithFormat:@"%ld", _weekTimeLong] : nil);
           
        }
            break;
        case 2:
        {
            minuteCount = _dayView.hidden == NO ?  [self getTodayResidueSecondsString] : (_weekTarget - _weekTimeLong > 0 ? [NSString stringWithFormat:@"%ld", _weekTarget - _weekTimeLong] : (_loadRecordDataSucceed ? @"0" : nil));
        }
            break;
            
        case 3:
        {
            minuteCount = _loadRecordDataSucceed ? [NSString stringWithFormat:@"%ld", _weekTimeLong/7] : nil;
        }
            break;
            
        default:
            break;
    }
    
    [cell setTitle:_titleArray[indexPath.row] minuteCount:minuteCount withIndexPath:indexPath];
    return cell;
}


// 获取今天养护分钟
- (NSString *)getTodaySecondsString
{
    NSDictionary *todatSecDict = [self getTodatSecDict];
    if(todatSecDict != nil && todatSecDict.count > 0) {
        NSInteger seconds = 0;
    
        for (NSString *key in todatSecDict.allKeys) {
            NSInteger sec = [[todatSecDict objectForKey:key] integerValue];
            if(sec > 180) {
                sec = 180;
            }
            seconds += sec;
        }

        return [NSString stringWithFormat:@"%ld",seconds];
    }
    
    return nil;
}

// 获取今天剩余养护分钟
- (NSString *)getTodayResidueSecondsString
{
    NSString *todaySecondString = [self getTodaySecondsString];
    if(todaySecondString == nil) {
        return [UserInfo share].target;
    }
    NSInteger todaySeconds = [todaySecondString integerValue];
    if(todaySeconds > 180) {
        todaySeconds = 180;
    }
    NSInteger target = [[UserInfo share].target integerValue];
    if(target > 180) {
        target = 180;
    }
    if(todaySeconds > target) {
        return @"0";
    }

    return [NSString stringWithFormat:@"%ld", target - todaySeconds];
}

// 获取今天各小时养护分钟字典（key：时， value：分中数）
-(NSDictionary *)getTodatSecDict
{
    NSMutableDictionary *hourResultDict = [NSMutableDictionary dictionary];
    NSArray *todayRecordArray = [DBManager selectTodayDatas: [UserInfo share].userId];
    if(todayRecordArray != nil && todayRecordArray.count > 0) {
        for (NSInteger i = 0; i < todayRecordArray.count; i++) {
            MassageRecordModel *model = todayRecordArray[i];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSArray *temp = [[dateFormatter stringFromDate:model.startTime] componentsSeparatedByString:@":"];
            NSLog(@"getTodaySecondsString ---> 开始 %@:%@", temp[0], temp[1]);
            NSInteger startDateInt = [temp[0] integerValue] * 60 + [temp[1] integerValue];
            temp = [[dateFormatter stringFromDate:model.endTime] componentsSeparatedByString:@":"];
            NSLog(@"getTodaySecondsString ---> 停止 %@:%@", temp[0], temp[1]);
            NSInteger endDateInt = [temp[0] integerValue] * 60 + [temp[1] integerValue];
            NSInteger sec = endDateInt - startDateInt;
            if(sec > 180) {
                sec = 180;
            }
            NSLog(@"getTodaySecondsString ----------> 分中数:%ld", sec);
            
            [hourResultDict setValue:[NSNumber numberWithInteger:sec] forKey:temp[0]];
        }
    }
    for (NSString *key in hourResultDict.allKeys) {
        NSLog(@"第 %@ 小时，养护 %ld 分钟", key, [[hourResultDict objectForKey:key] integerValue]);
    }
    
    return hourResultDict;
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
