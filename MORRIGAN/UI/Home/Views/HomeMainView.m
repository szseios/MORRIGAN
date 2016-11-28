//
//  HomeMainView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HomeMainView.h"
#import "PNChart.h"
#import "MassageRecordModel.h"
#import "CircleChartView.h"

@interface HomeMainView ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView *circleImageView;

@property (nonatomic , strong) UIScrollView *scrollView;   //中间scrollview

@property (nonatomic , strong) UIView *centerView;   //中间view

@property (nonatomic , strong) UILabel *timeLabel;  //目标时间

@property (nonatomic , strong) UIView *upView;

@property (nonatomic , strong) UIView *downView;

@property (nonatomic , assign) CGFloat viewWidth;

@property (nonatomic , assign) CGFloat viewHeight;

@property (nonatomic , strong) UIImageView *upBackgroundView;

@property (nonatomic , strong) PNCircleChart *circleChart;  //时间划线

@property (nonatomic , strong) NSArray *AMMorriganArray;   //上午按摩时间数组

@property (nonatomic , strong) NSArray *PMMorriganArray;   //下午按摩时间数组

@property (nonatomic , strong) NSArray *haveEmptyArray;   //空闲时间数组，里面是字典，key:startTime,endTime Value:

@property (nonatomic , strong) UILabel *electricityLabel;  //电量

@property (nonatomic , strong) UILabel *starLabel;  //星星

@property (nonatomic , strong) UILabel *dateLabel;   //日期

@property (nonatomic , strong) UILabel *APMLabel;   //上下午

@property (nonatomic , strong) UIImageView *lefthorizImageView; //日期下面的左横杆

@property (nonatomic , strong) UIImageView *righthorizImageView; //日期下面的右横杆

@property (nonatomic , strong) UIView *horizView;

@property (nonatomic , strong) UIView *waveView;

@property (nonatomic , strong) CAShapeLayer *waveLayer;

@property (nonatomic , assign) CGFloat waveOffsetX;

@property (nonatomic , strong) CADisplayLink *waveDisplayLink;

@property (nonatomic , strong) UIImageView *starImage;

@property (nonatomic , assign) NSInteger didMorriganTime;

@property (nonatomic , assign) NSInteger electricityPercent;

@property (nonatomic , strong) NSString *starCount;

@end

@implementation HomeMainView

- (instancetype)initWithAMMorriganArray:(NSArray *)AMArray PMMorriganTime:(NSArray *)PMArray withFarme:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _AMMorriganArray = AMArray;
        _PMMorriganArray = PMArray;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:TARGETCHANGENOTIFICATION object:nil];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _viewWidth = rect.size.width;
    _viewHeight = rect.size.height;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:@"homePageBackgroud"];
    [self addSubview:imageView];
    
    CGFloat circleX = _viewWidth * 11.5 / 312.0;
    CGFloat circleY = _viewHeight * 129.5 / 860.0;
    CGFloat circleW = _viewWidth * 261/312.0;
    _circleImageView = [[UIImageView alloc] init];
    [_circleImageView setFrame:CGRectMake(circleX, circleY, circleW, circleW)];
    _circleImageView.backgroundColor = [UIColor clearColor];
    _circleImageView.image = [UIImage imageNamed:@"round_scale_all"];
    [self addSubview:_circleImageView];
    [self refreshLatestDataForAMMorrigan:_AMMorriganArray PMMorrigan:_PMMorriganArray];
    
    [self setUpWaveView];
    [self setUpCenterView];
    [self setUpUpView];
    [self setUpDownView];
    
    [self setUpSrollView];
    
}

- (void)setUpWaveView
{
    CGFloat waveX = _viewWidth * 23 / 312.0;
    CGFloat waveY = _viewHeight * 150.5 / 860;
    CGFloat waveW = _viewWidth * 238 / 312;
    _waveView = [[UIView alloc] initWithFrame:CGRectMake(waveX, waveY, waveW, waveW)];
    _waveView.clipsToBounds = YES;
    _waveView.layer.cornerRadius = waveW / 2;
    _waveView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_waveView];
    
    self.waveLayer = [CAShapeLayer layer];
    self.waveLayer.fillColor = [UIColor colorWithRed:188/255.0 green:139/255.0 blue:238/255.0 alpha:0.5].CGColor;
    self.waveOffsetX = 0;
    /*
     *CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
     */
//    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
//    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self getCurrentWave];
    [_waveView.layer addSublayer:_waveLayer];
    
}

//CADispayLink相当于一个定时器 会一直绘制曲线波纹 看似在运动，其实是一直在绘画不同位置点的余弦函数曲线
- (void)getCurrentWave {
    //offsetX决定x位置，如果想搞明白可以多试几次
    self.waveOffsetX += 6;
    //声明第一条波曲线的路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始点
    CGFloat waveW = _viewWidth * 238 / 312;
    CGPathMoveToPoint(path, nil, 0, waveW / 3 * 2);
    
    CGFloat y = 0.f;
    //第一个波纹的公式
    for (float x = 0.f; x <= waveW ; x++) {
        y = 16*sin((250 / waveW) * (x * M_PI / 140) - self.waveOffsetX * M_PI / 140) + waveW * 0.7;
        CGPathAddLineToPoint(path, nil, x, y);
        x++;
    }
    //把绘图信息添加到路径里
    CGPathAddLineToPoint(path, nil, waveW, 1000);
    //结束绘图信息
    CGPathCloseSubpath(path);
    
    self.waveLayer.path = path;
    //释放绘图路径
    CGPathRelease(path);
    
    /*
     *  第二个
     */
//    self.offsetXT += self.waveSpeed;
//    CGMutablePathRef pathT = CGPathCreateMutable();
//    CGPathMoveToPoint(pathT, nil, 0, self.waveHeight+100);
//    
//    CGFloat yT = 0.f;
//    for (float x = 0.f; x <= self.waveWidth ; x++) {
//        yT = self.waveAmplitude*1.6 * sin((260 / self.waveWidth) * (x * M_PI / 180) - self.offsetXT * M_PI / 180) + self.waveHeight;
//        CGPathAddLineToPoint(pathT, nil, x, yT-10);
//    }
//    CGPathAddLineToPoint(pathT, nil, self.waveWidth, self.frame.size.height);
//    CGPathAddLineToPoint(pathT, nil, 0, self.frame.size.height);
//    CGPathCloseSubpath(pathT);
//    self.waveShapeLayerT.path = pathT;
//    CGPathRelease(pathT);
}


- (void)setUpCenterView
{
    _centerView = [[UIView alloc] initWithFrame:_circleImageView.frame];
    _centerView.clipsToBounds = YES;
    _centerView.layer.cornerRadius = _centerView.frame.size.width / 2;
    _centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_centerView];
    
    CGFloat timeLabelY = (_centerView.frame.size.width / 2) - 50;
    CGFloat timeLabelW = CGRectGetWidth(_centerView.frame);
    CGFloat timeLabelH = 100;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeLabelY, timeLabelW, timeLabelH)];
    NSString *time = [UserInfo share].target;
    if (!time) {
        time = @"60";
    }else{
        if (_didMorriganTime && _didMorriganTime > 0) {
            NSInteger tempTime = (time.integerValue - _didMorriganTime) > 0 ? (time.integerValue - _didMorriganTime) : 0;
            time = [NSString stringWithFormat:@"%ld",tempTime];
        }
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@min",time]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:60]} range:NSMakeRange(0, time.length)];
    _timeLabel.attributedText = attributeString;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_centerView addSubview:_timeLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    CGFloat dateLabelY = CGRectGetMaxY(_timeLabel.frame);
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabelY, timeLabelW- 50, 25)];
    _dateLabel.text = dateStr;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.alpha = 0.5;
    
    _dateLabel.font = [UIFont systemFontOfSize:(kScreenWidth > 320 ? 15 : 12)];
    [_dateLabel sizeToFit];
    _dateLabel.center = CGPointMake(_centerView.width / 2 -15, dateLabelY + 25/2);
    [_centerView addSubview:_dateLabel];
    
    CGFloat APMLabelX = CGRectGetMaxX(_dateLabel.frame)+5;
    _APMLabel = [[UILabel alloc] initWithFrame:CGRectMake(APMLabelX, dateLabelY-3, 50, 25)];
    _APMLabel.text = [self isAMOrPM] ? @"AM" : @"PM";
    _APMLabel.textColor = [UIColor whiteColor];
    _APMLabel.textAlignment = NSTextAlignmentLeft;
    _APMLabel.font = [UIFont systemFontOfSize:(kScreenWidth > 320 ? 24 : 20)];
    [_centerView addSubview:_APMLabel];
    
    CGFloat horizY = CGRectGetMaxY(_dateLabel.frame);
    _horizView = [[UIView alloc] initWithFrame:CGRectMake(20,horizY , 65, 4)];
    _horizView.backgroundColor = [UIColor clearColor];
    _horizView.center = CGPointMake(_centerView.width / 2, horizY + 15);
    [_centerView addSubview:_horizView];
    
    NSString *leftImageName = [self isAMOrPM] ? @"full_rect" : @"empty_rect";
    NSString *rightImageName = [self isAMOrPM] ? @"empty_rect" : @"full_rect";
    
    _lefthorizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 25, 4)];
    _lefthorizImageView.image = [UIImage imageNamed:leftImageName];
    [_horizView addSubview:_lefthorizImageView];
    
    _righthorizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 25, 4)];
    _righthorizImageView.image = [UIImage imageNamed:rightImageName];
    [_horizView addSubview:_righthorizImageView];
    
}

- (void)setUpSrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_centerView.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(_centerView.width * 2, _centerView.height);
    NSLog(@"%lf",_scrollView.contentSize.width);
    _scrollView.clipsToBounds = YES;
    _scrollView.layer.cornerRadius = _scrollView.width / 2;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    if (![self isAMOrPM]) {
        _scrollView.contentOffset = CGPointMake(_centerView.width/2+30, 0);
    }
    [self addSubview:_scrollView];
    [self bringSubviewToFront:_scrollView];
}

- (void)setUpUpView
{
    _upView = [[UIView alloc] init];
    CGFloat upViewX = _viewWidth * 478 / 623.0;
    CGFloat upViewY = _viewHeight * 31.5 / 860.0;
    CGFloat upViewW = _viewWidth * 112.5 / 623.0;
    [_upView setFrame:CGRectMake(upViewX, upViewY, upViewW, upViewW)];
    _upView.clipsToBounds = YES;
    _upView.layer.cornerRadius = upViewW / 2;
    _upView.backgroundColor = [UIColor clearColor];
    [self addSubview:_upView];
    
    _upBackgroundView = [[UIImageView alloc] initWithFrame:_upView.bounds];
    _upBackgroundView.image =  [self createImageWithColor:[Utils stringTOColor:@"#a743c7"]];
    NSInteger percent = _electricityPercent > 0 ?  _electricityPercent : 0;
    _upBackgroundView.height = _upView.height * percent;
    _upBackgroundView.y = _upView.height - _upBackgroundView.height;
    [_upView addSubview:_upBackgroundView];
    
    CGFloat persentLabelX = 0;
    CGFloat persentLabelY = _upView.height / 2 - 15;
    CGFloat persentLabelW = _upView.width;
    CGFloat persentLabelH = 20;
    
    _electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(persentLabelX, persentLabelY, persentLabelW, persentLabelH)];
    _electricityLabel.textColor = [UIColor whiteColor];
    _electricityLabel.textAlignment = NSTextAlignmentCenter;
    _electricityLabel.font = [UIFont systemFontOfSize:10];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",percent]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, attributeString.length - 1)];
    _electricityLabel.attributedText = attributeString;
    [_upView addSubview:_electricityLabel];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_electricityLabel.frame), persentLabelW, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font  = [UIFont systemFontOfSize:12];
    label.text = @"电量";
    [_upView addSubview:label];
    
}

- (void)setUpDownView
{
    _downView = [[UIView alloc] init];
    CGFloat downViewX = _viewWidth * 360 / 624.0;
    CGFloat downViewY = _viewHeight * 686 / 860.0;
    CGFloat downViewW = _viewWidth * 140 / 624.0;
    [_downView setFrame:CGRectMake(downViewX, downViewY, downViewW, downViewW)];
    _downView.clipsToBounds = YES;
    _downView.layer.cornerRadius = downViewW / 2;
    _downView.backgroundColor = [UIColor clearColor];
    [self addSubview:_downView];
    
    CGFloat starX = 0;
    CGFloat starY = _downView.height / 2 - 26;
    CGFloat starW = _downView.width;
    CGFloat starH = 30;
    
    _starLabel = [[UILabel alloc] initWithFrame:CGRectMake(starX, starY, starW, starH)];
    _starLabel.textColor = [UIColor whiteColor];
    _starLabel.textAlignment = NSTextAlignmentCenter;
    NSString *starCount = _starCount ? _starCount : @"0";
    _starLabel.font = [UIFont systemFontOfSize:10];
    [self starLabelAttributeStr:starCount];
    [_downView addSubview:_starLabel];
    
    CGFloat starImageY = CGRectGetMaxY(_starLabel.frame);
    CGFloat starImageX = 12;
    CGFloat starImageW = _downView.width - 24;
    CGFloat starImageH = kScreenHeight > 568 ? 14 : 10;
    _starImage = [[UIImageView alloc] initWithFrame:CGRectMake(starImageX, starImageY, starImageW, starImageH)];
    _starImage.backgroundColor = [UIColor clearColor];
    if (_starCount) {
        NSString *imageName;
        NSString *starStr;
        switch (_starCount.integerValue) {
            case -1:
            {
                imageName = @"icon_star_0";
                starStr = @"0";
            }
                break;
            case 0:
            {
                imageName = @"icon_star_5";
                starStr = @"0.5";
            }
                break;
            case 1:
            {
                imageName = @"icon_star_10";
                starStr = @"1";
            }
                break;
                
            case 2:
            {
                imageName = @"icon_star_15";
                starStr = @"1.5";
            }
                break;
                
            case 3:
            {
                imageName = @"icon_star_20";
                starStr = @"2";
            }
                break;
                
            case 4:
            {
                imageName = @"icon_star_25";
                starStr = @"2.5";
            }
                break;
                
            case 5:
            {
                imageName = @"icon_star_30";
                starStr = @"3";
            }
                break;
                
                
            default:
                break;
        }
        [_starImage setImage:[UIImage imageNamed:imageName]];
    }else{
        _starImage.image = [UIImage imageNamed:@"icon_star_0"];
    }
    [_downView addSubview:_starImage];
    
}

- (void)morriganStartTime:(NSDate *)startTime toEndTime:(NSDate *)endTime
{
    CGFloat startAngle = [self getAngleFromDate:startTime isStart:YES];
    CGFloat endAngle = [self getAngleFromDate:endTime isStart:NO];
    if (endAngle >= 720) {
        endAngle -= 720;
        startAngle -= 720;
    }
    CircleChartView *circleChart = [[CircleChartView alloc] initWithFrame:CGRectMake(_circleImageView.x,_circleImageView.y, _circleImageView.width, _circleImageView.height) startAngle:startAngle endAngle:endAngle isEmpty:NO];
    
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.lineWidth = 10;
    [circleChart setStrokeColor:[Utils stringTOColor:@"#E1418A"]];
    [circleChart strokeChart];
    
    [self addSubview:circleChart];
    
}

- (CGFloat)getAngleFromDate:(NSDate *)date isStart:(BOOL)isStart
{
    CGFloat angle = 0;
    if (date) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
        comps = [calendar components:unitFlags fromDate:date];
        NSInteger hour = comps.hour;
        NSInteger minute = comps.minute;
        NSInteger count = minute % 10;
        if (count != 0) {
            if (isStart) {
                minute -= count;
            }else{
                minute += (10-count);
            }
        }
        angle = (CGFloat)(hour * 60 + minute);
    }
    return angle;

}

- (NSInteger)getDidMorriganTime:(MassageRecordModel *)model
{
    NSInteger time = 0;
    if (model) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
        comps = [calendar components:unitFlags fromDate:model.startTime];
        NSInteger hour = comps.hour;
        NSInteger minute = comps.minute;
        
        NSDateComponents *comps1 = [[NSDateComponents alloc] init];
        comps1 = [calendar components:unitFlags fromDate:model.endTime];
        NSInteger hour1 = comps1.hour;
        NSInteger minute1 = comps1.minute;
        
        time = (hour1 - hour) * 60 + (minute1 - minute);
    }
    return time;
}


- (void)emptyStartTime:(NSDate *)startTime toEndTime:(NSDate *)endTime
{
    CGFloat startAngle = [self getAngleFromDate:startTime isStart:YES];
    CGFloat endAngle = [self getAngleFromDate:endTime isStart:NO];
    if (endAngle >= 720) {
        endAngle -= 720;
    }
    CircleChartView *circleChart = [[CircleChartView alloc] initWithFrame:CGRectMake(_circleImageView.x,_circleImageView.y, _circleImageView.width, _circleImageView.height) startAngle:startAngle endAngle:endAngle isEmpty:NO];
    
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.lineWidth = 2;
    [circleChart setStrokeColor:[Utils stringTOColor:@"#E1418A"]];
    [circleChart strokeChart];
    
    [self addSubview:circleChart];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX =  _centerView.width;
    CGFloat offsetXX = scrollView.contentOffset.x;
    if ( offsetXX >= offsetX / 2) {
        _APMLabel.text = @"AM";
        _righthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
        _lefthorizImageView.image = [UIImage imageNamed:@"full_rect"];
        [self showCircleWithAM:YES];
        
    }else{
        _APMLabel.text = @"PM";
        _righthorizImageView.image = [UIImage imageNamed:@"full_rect"];
        _lefthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
        [self showCircleWithAM:NO];
    }
    [self bringSubviewToFront:_scrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - other

//目标变化通知
- (void)refreshData:(NSNotification *)notification
{
//    [self displayView];
}

- (BOOL)isAMOrPM
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *compt = [calendar components:NSCalendarUnitHour
                                          fromDate:[NSDate date]];
    NSInteger hour = compt.hour;
    return hour < 12 ? YES : NO;
}

- (void)showRightTime
{
    if ([self isAMOrPM]) {
        _APMLabel.text = @"AM";
        _righthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
        _lefthorizImageView.image = [UIImage imageNamed:@"full_rect"];
        [self showCircleWithAM:YES];
    }else{
        _APMLabel.text = @"PM";
        _righthorizImageView.image = [UIImage imageNamed:@"full_rect"];
        _lefthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
        [self showCircleWithAM:NO];
    }
}

//星级评定
- (void)setStarLabelAndImage:(NSString *)star
{
    _starCount = star;
}

//设置电量变化
- (void)setElectricityPersent:(CGFloat)persent
{
    _electricityPercent = (NSInteger)(persent*100);
}

- (void)starLabelAttributeStr:(NSString *)starStr
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@star",starStr]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, starStr.length)];
    
    _starLabel.attributedText = attributeString;
}

- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)refreshLatestDataForAMMorrigan:(NSArray *)AMMorriganArray PMMorrigan:(NSArray *)PMMorriganArray
{
    _AMMorriganArray = AMMorriganArray;
    _PMMorriganArray = PMMorriganArray;
    if ([self isAMOrPM]) {
        [self showCircleWithAM:YES];
    }else{
       [self showCircleWithAM:NO];
    }
    
}

- (void)showCircleWithAM:(BOOL)isAM
{
    _didMorriganTime = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[CircleChartView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (isAM) {
        
        if (_AMMorriganArray && _AMMorriganArray.count > 0) {
            MassageRecordModel *firstModel = _AMMorriganArray.firstObject;
            MassageRecordModel *model = _AMMorriganArray.lastObject;
            [self emptyStartTime:firstModel.startTime toEndTime:model.endTime];
            
            for (MassageRecordModel *model in _AMMorriganArray) {
                [self morriganStartTime:model.startTime toEndTime:model.endTime];
                NSInteger time = [self getDidMorriganTime:model];
                _didMorriganTime += time;
            }
        }
        if (_PMMorriganArray && _PMMorriganArray.count > 0) {
            for (MassageRecordModel *model in _PMMorriganArray) {
                NSInteger time = [self getDidMorriganTime:model];
                _didMorriganTime += time;
            }
        }

    }else{
        if (_AMMorriganArray) {
            for (MassageRecordModel *model in _AMMorriganArray) {
                NSInteger time = [self getDidMorriganTime:model];
                _didMorriganTime += time;
            }
        }
        if (_PMMorriganArray) {
            MassageRecordModel *firstModel = _PMMorriganArray.firstObject;
            MassageRecordModel *model = _PMMorriganArray.lastObject;
            [self emptyStartTime:firstModel.startTime toEndTime:model.endTime];
            for (MassageRecordModel *model in _PMMorriganArray) {
                [self morriganStartTime:model.startTime toEndTime:model.endTime];
                NSInteger time = [self getDidMorriganTime:model];
                _didMorriganTime += time;
            }
        }
    }
}

- (void)displayView
{
    [self bringSubviewToFront:_scrollView];
    [self setNeedsDisplay];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
