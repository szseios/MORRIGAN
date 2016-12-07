//
//  CircleChartView.h
//  MORRIGAN
//
//  Created by azz on 2016/11/22.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleChartView : UIView

- (id)initWithFrame:(CGRect)frame
         startAngle:(CGFloat)startAngle
           endAngle:(CGFloat)endAngle
            isEmpty:(BOOL)isEmpty;

- (void)strokeChart;

@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) UIColor *strokeColor;

@end
