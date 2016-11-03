//
//  HomeMainView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HomeMainView.h"
#import "PNChart.h"

@interface HomeMainView ()

@property (nonatomic , strong) UIImageView *circleImageView;

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) UIView *upView;

@property (nonatomic , strong) UIView *downView;

@property (nonatomic , assign) CGFloat viewWidth;

@property (nonatomic , assign) CGFloat viewHeight;

@property (nonatomic , strong) UIImageView *upBackgroundView;

@property (nonatomic , strong) UIBezierPath *path;

@property (nonatomic , strong) PNCircleChart *circleChart;

@property (nonatomic , strong) NSArray *haveMorriganArray;

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
    _viewWidth = rect.size.width;
    _viewHeight = rect.size.height;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:@"homePageBackgroud"];
    [self addSubview:imageView];
    
    CGFloat circleX = _viewWidth * 12 / 312.0;
    CGFloat circleY = _viewHeight * 128 / 860.0;
    CGFloat circleW = _viewWidth * 261/312.0;
    _circleImageView = [[UIImageView alloc] init];
    [_circleImageView setFrame:CGRectMake(circleX, circleY, circleW, circleW)];
    _circleImageView.backgroundColor = [UIColor clearColor];
    _circleImageView.image = [UIImage imageNamed:@"round_scale_all"];
    [self addSubview:_circleImageView];
    
    [self setUpSrollView];
    [self setUpUpView];
    [self setUpDownView];
    
    if (_haveMorriganArray) {
        for (NSDictionary *haveDict in _haveMorriganArray) {
            CGFloat startTime = [[haveDict objectForKey:@"startTime"] floatValue];
            CGFloat endTime = [[haveDict objectForKey:@"endTime"] floatValue];
            [self emptyStartTime:startTime toEndTime:endTime];
        }
    }
    
}


- (void)setUpSrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_circleImageView.frame];
    _scrollView.clipsToBounds = YES;
    _scrollView.layer.cornerRadius = _scrollView.frame.size.width / 2;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    CGFloat timeLabelY = (_scrollView.frame.size.width / 2) - 80;
    CGFloat timeLabelW = CGRectGetWidth(_scrollView.frame);
    CGFloat timeLabelH = 100;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeLabelY, timeLabelW, timeLabelH)];
    NSInteger time = 60;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldmin",time]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:60]} range:NSMakeRange(0, 2)];
    _timeLabel.attributedText = attributeString;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_timeLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    CGFloat dateLabelY = CGRectGetMaxY(_timeLabel.frame);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabelY, timeLabelW, 25)];
    dateLabel.text = dateStr;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:dateLabel];
    
    //
    [formatter setDateFormat:@"aa HH:mm"];
    NSString *timeSStr = [formatter stringFromDate:[NSDate date]];
    CGFloat timeSLabelY = CGRectGetMaxY(dateLabel.frame);
    UILabel *timeSLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeSLabelY, timeLabelW, 25)];
    timeSLabel.text = timeSStr;
    timeSLabel.textColor = [UIColor whiteColor];
    timeSLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:timeSLabel];
    
    
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
    _upBackgroundView.image = [UIImage imageNamed:@"auto_downBackgrround"];
    _upBackgroundView.height = _upView.height * 0.2;
    _upBackgroundView.y = _upView.height - _upBackgroundView.height;
    [_upView addSubview:_upBackgroundView];
    
    CGFloat persentLabelX = 0;
    CGFloat persentLabelY = _upView.height / 2 - 15;
    CGFloat persentLabelW = _upView.width;
    CGFloat persentLabelH = 20;
    
    UILabel *electricityLabel = [[UILabel alloc] initWithFrame:CGRectMake(persentLabelX, persentLabelY, persentLabelW, persentLabelH)];
    electricityLabel.textColor = [UIColor whiteColor];
    electricityLabel.textAlignment = NSTextAlignmentCenter;
    NSInteger persent = 20;
    electricityLabel.font = [UIFont systemFontOfSize:10];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",persent]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 2)];
    electricityLabel.attributedText = attributeString;
    [_upView addSubview:electricityLabel];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(electricityLabel.frame), persentLabelW, 20)];
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
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(starX, starY, starW, starH)];
    starLabel.textColor = [UIColor whiteColor];
    starLabel.textAlignment = NSTextAlignmentCenter;
    NSInteger starCount = 88;
    starLabel.font = [UIFont systemFontOfSize:10];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldstar",starCount]];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, 2)];
    starLabel.attributedText = attributeString;
    [_downView addSubview:starLabel];
    
    CGFloat starImageY = CGRectGetMaxY(starLabel.frame);
    CGFloat starImageX = 12;
    CGFloat starImageW = _downView.width - 24;
    CGFloat starImageH = 14;
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
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(_circleImageView.x+2,_circleImageView.y+2, _circleImageView.width-4, _circleImageView.height-4) startAngle:startTime endAngle:endTime total:@360 current:@(180) clockwise:YES];
    
    circleChart.backgroundColor = [UIColor clearColor];
    circleChart.lineWidth = @2;
    [circleChart setStrokeColor:[UIColor whiteColor]];
    [circleChart setStrokeColorGradientStart:[UIColor redColor]];
    [circleChart strokeChart];
    
    [self addSubview:circleChart];
}

@end
