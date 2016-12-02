//
//  CircleChartView.m
//  MORRIGAN
//
//  Created by azz on 2016/11/22.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "CircleChartView.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CircleChartView ()

@property (nonatomic , strong) CAShapeLayer *circle;

@property (nonatomic , strong) CAShapeLayer *circleBackground;

@property (nonatomic , assign) BOOL isEmpty;

@end

@implementation CircleChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (id)initWithFrame:(CGRect)frame
         startAngle:(CGFloat)startAngle
           endAngle:(CGFloat)endAngle
            isEmpty:(BOOL)isEmpty
{
    self = [super initWithFrame:frame];
    if (self) {
        _isEmpty = isEmpty;
        CGFloat start = startAngle / 2;
        CGFloat end = endAngle / 2;
        CGFloat surplus = 0;
        if (kScreenWidth == 320) {
            surplus = 1.1;
        }
        else if (kScreenWidth == 414) {
            surplus = -0.2;
        }
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                                  radius:((self.frame.size.height * 0.5) - (10/2.0f)-(0.7 - surplus))
                                                              startAngle:DEGREES_TO_RADIANS(start - 90.0)
                                                                endAngle:DEGREES_TO_RADIANS(end - 90.0)
                                                               clockwise:YES];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        //        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = kScreenWidth == 320 ? 8 : 10;
        _circle.zPosition     = 1;
        
        _circleBackground             = [CAShapeLayer layer];
        _circleBackground.path        = circlePath.CGPath;
        //        _circleBackground.lineCap     = kCALineCapRound;
        _circleBackground.fillColor   = [UIColor clearColor].CGColor;
        _circleBackground.lineWidth   = 10;
        _circleBackground.strokeColor = [UIColor whiteColor].CGColor;
        _circleBackground.strokeEnd   = 1.0;
        _circleBackground.zPosition   = -1;
        
        [self.layer addSublayer:_circleBackground];
        [self.layer addSublayer:_circle];
    }
    return self;
}

- (void)strokeChart
{
    // Add circle params
    
    _circle.lineWidth   = _lineWidth ? _lineWidth : 10;
    _circleBackground.lineWidth = kScreenWidth == 320 ? 9.5 : 11;;
    _circleBackground.strokeEnd = 1.0;
    _circleBackground.strokeColor = [UIColor whiteColor].CGColor;
    _circle.strokeColor = (_strokeColor ? _strokeColor : [UIColor redColor]).CGColor;
    _circle.strokeEnd   = 1.0;
    if (!_isEmpty) {
        _circle.lineCap = kCALineCapRound;
    }
    
}

@end
