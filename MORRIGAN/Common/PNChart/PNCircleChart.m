//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"

@interface PNCircleChart ()
@end

@implementation PNCircleChart

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:NO
                   shadowColor:[UIColor clearColor]
          displayCountingLabel:YES
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise shadow:(BOOL)hasBackgroundShadow shadowColor:(UIColor *)backgroundShadowColor {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:shadow
                   shadowColor:backgroundShadowColor
          displayCountingLabel:YES
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame total:(NSNumber *)total current:(NSNumber *)current clockwise:(BOOL)clockwise shadow:(BOOL)hasBackgroundShadow shadowColor:(UIColor *)backgroundShadowColor displayCountingLabel:(BOOL)displayCountingLabel {
    
    return [self initWithFrame:frame
                         total:total
                       current:current
                     clockwise:clockwise
                        shadow:shadow
                   shadowColor:backgroundShadowColor
          displayCountingLabel:displayCountingLabel
             overrideLineWidth:@8.0f];
    
}

- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
             shadow:(BOOL)hasBackgroundShadow
        shadowColor:(UIColor *)backgroundShadowColor
displayCountingLabel:(BOOL)displayCountingLabel
  overrideLineWidth:(NSNumber *)overrideLineWidth
{
    self = [super initWithFrame:frame];

    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        _duration = 1.0;
        _chartType = PNChartFormatTypePercent;
        _displayAnimated = YES;
        
        _displayCountingLabel = displayCountingLabel;

        CGFloat startAngle = clockwise ? -90.0f : 270.0f;
        CGFloat endAngle = clockwise ? -90.01f : 270.01f;

        _lineWidth = overrideLineWidth;
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:(self.frame.size.height * 0.5) - ([_lineWidth floatValue]/2.0f)
                                                              startAngle:DEGREES_TO_RADIANS(startAngle)
                                                                endAngle:DEGREES_TO_RADIANS(endAngle)
                                                               clockwise:clockwise];

        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;

        _circleBackground             = [CAShapeLayer layer];
        _circleBackground.path        = circlePath.CGPath;
        _circleBackground.lineCap     = kCALineCapRound;
        _circleBackground.fillColor   = [UIColor clearColor].CGColor;
        _circleBackground.lineWidth   = [_lineWidth floatValue];
        _circleBackground.strokeColor = (hasBackgroundShadow ? backgroundShadowColor.CGColor : [UIColor clearColor].CGColor);
        _circleBackground.strokeEnd   = 1.0;
        _circleBackground.zPosition   = -1;

        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBackground];

        _countingLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 50.0)];
        [_countingLabel setTextAlignment:NSTextAlignmentCenter];
        [_countingLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_countingLabel setTextColor:[UIColor grayColor]];
        [_countingLabel setBackgroundColor:[UIColor clearColor]];
        [_countingLabel setCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)];
        _countingLabel.method = UILabelCountingMethodEaseInOut;
        if (_displayCountingLabel) {
            [self addSubview:_countingLabel];
        }
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
         startAngle:(CGFloat)startAngle
           endAngle:(CGFloat)endAngle
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = @72;
        _current = @((NSInteger)(endAngle - startAngle) / 10);
        _strokeColor = PNRed;
        _duration = 1.0;
        _chartType = PNChartFormatTypePercent;
        _displayAnimated = NO;
        
        _displayCountingLabel = NO;
        
//        CGFloat startAngle = clockwise ? -90.0f : 270.0f;
//        CGFloat endAngle = clockwise ? -90.01f : 270.01f;
        
        _lineWidth = @10;
        
        CGFloat temp = DEGREES_TO_RADIANS(endAngle);
        NSLog(@"%lf",temp);
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:(self.frame.size.height * 0.5) - ([_lineWidth floatValue]/2.0f)
                                                              startAngle:DEGREES_TO_RADIANS(startAngle - 90.0)
                                                                endAngle:DEGREES_TO_RADIANS(startAngle + 269.9)
                                                               clockwise:clockwise];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:(self.frame.size.height * 0.5) - ([_lineWidth floatValue]/2.0f)
                                                              startAngle:DEGREES_TO_RADIANS(startAngle - 90.0)
                                                                endAngle:DEGREES_TO_RADIANS(startAngle + 269.9)
                                                               clockwise:clockwise];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
//        _circle.lineCap       = kCALineCapSquare;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;
        
        _circleBackground             = [CAShapeLayer layer];
        _circleBackground.path        = circlePath.CGPath;
//        _circleBackground.lineCap     = kCALineCapSquare;
        _circleBackground.fillColor   = [UIColor clearColor].CGColor;
        _circleBackground.lineWidth   = [_lineWidth floatValue];
        _circleBackground.strokeColor = [UIColor whiteColor].CGColor;
        _circleBackground.strokeEnd   = _current.floatValue / _total.floatValue;
        _circleBackground.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBackground];
    }
    
    return self;

}


- (void)strokeChart
{
    // Add circle params

    _circle.lineWidth   = [_lineWidth floatValue];
    _circleBackground.lineWidth = [_lineWidth floatValue];
    _circleBackground.strokeEnd = [_current floatValue] / [_total floatValue];
    _circle.strokeColor = _strokeColor.CGColor;
    _circle.strokeEnd   = [_current floatValue] / [_total floatValue];

    // Check if user wants to add a gradient from the start color to the bar color
    if (_strokeColorGradientStart) {

        // Add gradient
        self.gradientMask = [CAShapeLayer layer];
        self.gradientMask.fillColor = [[UIColor clearColor] CGColor];
        self.gradientMask.strokeColor = [[UIColor whiteColor] CGColor];
        self.gradientMask.lineWidth = _circle.lineWidth;
//        self.gradientMask.lineCap = kCALineCapRound;
        CGRect gradientFrame = CGRectMake(0, 0, 2*self.bounds.size.width, 2*self.bounds.size.height);
        self.gradientMask.frame = gradientFrame;
        self.gradientMask.path = _circle.path;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5,1.0);
        gradientLayer.endPoint = CGPointMake(0.5,0.0);
        gradientLayer.frame = gradientFrame;
        UIColor *endColor = (_strokeColor ? _strokeColor : [UIColor clearColor]);
        NSArray *colors = @[
                            (id)endColor.CGColor,
                            (id)_strokeColorGradientStart.CGColor
                            ];
        gradientLayer.colors = colors;

        [gradientLayer setMask:self.gradientMask];

        [_circle addSublayer:gradientLayer];

        self.gradientMask.strokeEnd = [_current floatValue] / [_total floatValue];
    }
    
    [self addAnimationIfNeeded];
}



- (void)growChartByAmount:(NSNumber *)growAmount
{
    NSNumber *updatedValue = [NSNumber numberWithFloat:[_current floatValue] + [growAmount floatValue]];

    // Add animation
    [self updateChartByCurrent:updatedValue];
}


-(void)updateChartByCurrent:(NSNumber *)current{
    
    [self updateChartByCurrent:current
                       byTotal:_total];
    
}

-(void)updateChartByCurrent:(NSNumber *)current byTotal:(NSNumber *)total {
    double totalPercentageValue = [current floatValue]/([total floatValue]/100.0);
    
    if (_strokeColorGradientStart) {
        self.gradientMask.strokeEnd = _circle.strokeEnd;
    }
    
    // Add animation
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @([_current floatValue] / [_total floatValue]);
        pathAnimation.toValue = @([current floatValue] / [total floatValue]);
        
        if (_strokeColorGradientStart) {
            [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        if (_displayCountingLabel) {
            [self.countingLabel countFrom:fmin([_current floatValue], [_total floatValue]) to:totalPercentageValue withDuration:self.duration];
        }
        
    }
    else if (_displayCountingLabel) {
        [self.countingLabel countFrom:totalPercentageValue to:totalPercentageValue withDuration:self.duration];
    }
    
    _circle.strokeEnd   = [current floatValue] / [total floatValue];
    _current = current;
    _total = total;
}

- (void)addAnimationIfNeeded
{
    double percentageValue = [_current floatValue]/([_total floatValue]/100.0);
    
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @([_current floatValue] / [_total floatValue]);
        [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        [_countingLabel countFrom:0 to:percentageValue withDuration:self.duration];
        
        if (self.gradientMask && _strokeColorGradientStart) {
            [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
    }
    else {
        [_countingLabel countFrom:percentageValue to:percentageValue withDuration:self.duration];
    }
}

@end
