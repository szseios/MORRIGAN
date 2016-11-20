//
//  HomeMainView.h
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMainView : UIView

- (instancetype)initWithMorriganArray:(NSArray *)array withFarme:(CGRect)frame;

- (void)morriganStartTime:(NSDate *)startTime toEndTime:(NSDate *)endTime;

- (void)emptyStartTime:(NSDate*)startTime toEndTime:(NSDate*)endTime;

- (void)setStarLabelAndImage:(NSString *)star;

- (void)setElectricityPersent:(CGFloat)persent;

@end
