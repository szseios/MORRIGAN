//
//  HomeMainView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HomeMainView.h"
#import "PNChart.h"

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

@property (nonatomic , strong) NSArray *haveMorriganArray;   //按摩时间数组，里面是字典，key:startTime,endTime Value:

@property (nonatomic , strong) UILabel *electricityLabel;  //电量

@property (nonatomic , strong) UILabel *starLabel;  //星星

@property (nonatomic , strong) UILabel *dateLabel;   //日期

@property (nonatomic , strong) UILabel *APMLabel;   //上下午

@property (nonatomic , strong) UIImageView *lefthorizImageView; //日期下面的左横杆

@property (nonatomic , strong) UIImageView *righthorizImageView; //日期下面的右横杆

@property (nonatomic , strong) UIView *horizView;

@property (nonatomic , strong) UIView *waveView;

@end

@implementation HomeMainView

- (instancetype)initWithMorriganArray:(NSArray *)array withFarme:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        _haveMorriganArray = array;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:TARGETCHANGENOTIFICATION object:nil];
    
    _viewWidth = rect.size.width;
    _viewHeight = rect.size.height;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:@"homePageBackgroud"];
    [self addSubview:imageView];
    
    CGFloat circleX = _viewWidth * 11.5 / 312.0;
    CGFloat circleY = _viewHeight * 127.5 / 860.0;
    CGFloat circleW = _viewWidth * 261/312.0;
    _circleImageView = [[UIImageView alloc] init];
    [_circleImageView setFrame:CGRectMake(circleX, circleY, circleW, circleW)];
    _circleImageView.backgroundColor = [UIColor clearColor];
    _circleImageView.image = [UIImage imageNamed:@"round_scale_all"];
    [self addSubview:_circleImageView];
    [self setUpWaveView];
    [self setUpCenterView];
    [self setUpUpView];
    [self setUpDownView];
    
    if (_haveMorriganArray) {
        for (NSDictionary *haveDict in _haveMorriganArray) {
            CGFloat startTime = [[haveDict objectForKey:@"startTime"] floatValue];
            CGFloat endTime = [[haveDict objectForKey:@"endTime"] floatValue];
            [self emptyStartTime:startTime toEndTime:endTime];
        }
    }
    
    [self setUpSrollView];
    
}

- (void)setUpWaveView
{
    CGFloat waveX = _viewWidth * 23.5 / 312.0;
    CGFloat waveY = _viewHeight * 150.5 / 860;
    CGFloat waveW = _viewWidth * 238 / 312;
    _waveView = [[UIView alloc] initWithFrame:CGRectMake(waveX, waveY, waveW, waveW)];
    _waveView.clipsToBounds = YES;
    _waveView.layer.cornerRadius = waveW / 2;
    _waveView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_waveView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:_waveView.center radius:waveW startAngle:M_PI / 6 endAngle:M_PI * 5 / 6 clockwise:YES];
//    path addCurveToPoint:CGPointMake(<#CGFloat x#>, <#CGFloat y#>) controlPoint1:<#(CGPoint)#> controlPoint2:<#(CGPoint)#>
    
}


- (void)setUpCenterView
{
    _centerView = [[UIView alloc] initWithFrame:_circleImageView.frame];
    _centerView.clipsToBounds = YES;
    _centerView.layer.cornerRadius = _centerView.frame.size.width / 2;
    _centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_centerView];
    
    CGFloat timeLabelY = (_centerView.frame.size.width / 2) - 70;
    CGFloat timeLabelW = CGRectGetWidth(_centerView.frame);
    CGFloat timeLabelH = 100;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeLabelY, timeLabelW, timeLabelH)];
    NSString *time = [UserInfo share].target;
    if (!time) {
        time = @"60";
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
    
    _dateLabel.font = [UIFont systemFontOfSize:(kScreenWidth > 320 ? 17 : 15)];
    [_dateLabel sizeToFit];
    _dateLabel.center = CGPointMake(_centerView.width / 2 -15, dateLabelY + 25/2);
    [_centerView addSubview:_dateLabel];
    
    CGFloat APMLabelX = CGRectGetMaxX(_dateLabel.frame);
    _APMLabel = [[UILabel alloc] initWithFrame:CGRectMake(APMLabelX + 10, dateLabelY, 50, 25)];
    _APMLabel.text = @"AM";
    _APMLabel.textColor = [UIColor whiteColor];
    _APMLabel.textAlignment = NSTextAlignmentLeft;
    _APMLabel.font = [UIFont systemFontOfSize:(kScreenWidth > 320 ? 17 : 15)];
    [_centerView addSubview:_APMLabel];
    
    CGFloat horizY = CGRectGetMaxY(_dateLabel.frame) + 10;
    _horizView = [[UIView alloc] initWithFrame:CGRectMake(20,horizY , 60, 4)];
    _horizView.backgroundColor = [UIColor clearColor];
    _horizView.center = CGPointMake(_centerView.width / 2, horizY + 15);
    [_centerView addSubview:_horizView];
    
    _lefthorizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 25, 4)];
    _lefthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
//    _lefthorizImageView.contentMode = UIViewContentModeCenter;
    [_horizView addSubview:_lefthorizImageView];
    
    _righthorizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 25, 4)];
    _righthorizImageView.image = [UIImage imageNamed:@"full_rect"];
//    _righthorizImageView.contentMode = UIViewContentModeCenter;
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
    [self addSubview:_scrollView];
    [self bringSubviewToFront:_scrollView];
}

- (void)setUpUpView
{
    _upView = [[UIView alloc] init];
    CGFloat upViewX = _viewWidth * 476 / 624.0;
    CGFloat upViewY = _viewHeight * 26 / 860.0;
    CGFloat upViewW = _viewWidth * 118 / 624.0;
    [_upView setFrame:CGRectMake(upViewX, upViewY, upViewW, upViewW)];
    _upView.clipsToBounds = YES;
    _upView.layer.cornerRadius = upViewW / 2;
    _upView.backgroundColor = [UIColor clearColor];
    [self addSubview:_upView];
    
    _upBackgroundView = [[UIImageView alloc] initWithFrame:_upView.bounds];
    _upBackgroundView.image = [UIImage imageNamed:@"elctricity"];
    _upBackgroundView.height = _upView.height * 0.2;
    _upBackgroundView.y = _upView.height - _upBackgroundView.height;
    [_upView addSubview:_upBackgroundView];
    
    CGFloat persentLabelX = 0;
    CGFloat persentLabelY = _upView.height / 2 - 15;
    CGFloat persentLabelW = _upView.width;
    CGFloat persentLabelH = 20;
    
    _electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(persentLabelX, persentLabelY, persentLabelW, persentLabelH)];
    _electricityLabel.textColor = [UIColor whiteColor];
    _electricityLabel.textAlignment = NSTextAlignmentCenter;
    NSInteger persent = 20;
    _electricityLabel.font = [UIFont systemFontOfSize:10];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",persent]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 2)];
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
    NSInteger starCount = 88;
    _starLabel.font = [UIFont systemFontOfSize:10];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldstar",starCount]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, 2)];
    _starLabel.attributedText = attributeString;
    [_downView addSubview:_starLabel];
    
    CGFloat starImageY = CGRectGetMaxY(_starLabel.frame);
    CGFloat starImageX = 12;
    CGFloat starImageW = _downView.width - 24;
    CGFloat starImageH = kScreenHeight > 568 ? 14 : 10;
    UIImageView *starImage = [[UIImageView alloc] initWithFrame:CGRectMake(starImageX, starImageY, starImageW, starImageH)];
    starImage.backgroundColor = [UIColor clearColor];
    starImage.image = [UIImage imageNamed:@"icon_star_25"];
    [_downView addSubview:starImage];
    
}

- (void)morriganStartTime:(CGFloat)startTime toEndTime:(CGFloat)endTime
{
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(_circleImageView.x+2,_circleImageView.y+4, _circleImageView.width-4, _circleImageView.height-4) startAngle:startTime endAngle:endTime total:@360 current:@(360) clockwise:YES];
    
    circleChart.backgroundColor = [UIColor clearColor];
    
    [circleChart setStrokeColor:[UIColor whiteColor]];
    [circleChart setStrokeColorGradientStart:[UIColor redColor]];
    [circleChart strokeChart];
    
    [self addSubview:circleChart];
    
}


- (void)emptyStartTime:(CGFloat)startTime toEndTime:(CGFloat)endTime
{
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(_circleImageView.x,_circleImageView.y, _circleImageView.width, _circleImageView.height) startAngle:startTime endAngle:endTime total:@360 current:@(360) clockwise:YES];
    
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.lineWidth = @2;
    [circleChart setStrokeColor:[UIColor whiteColor]];
    [circleChart setStrokeColorGradientStart:[UIColor redColor]];
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
        
    }else{
        _APMLabel.text = @"PM";
        _righthorizImageView.image = [UIImage imageNamed:@"full_rect"];
        _lefthorizImageView.image = [UIImage imageNamed:@"empty_rect"];
    }
}

- (void)refreshData:(NSNotification *)notification
{
    NSString *time = [UserInfo share].target;
    if (!time) {
        time = @"60";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@min",time]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:60]} range:NSMakeRange(0, time.length)];
    _timeLabel.attributedText = attributeString;
    [self setNeedsDisplay];
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
