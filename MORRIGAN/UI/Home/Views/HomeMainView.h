//
//  HomeMainView.h
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMainView : UIView

- (instancetype)initWithAMMorriganArray:(NSArray *)AMArray PMMorriganTime:(NSArray *)PMArray withFarme:(CGRect)frame;

- (void)morriganStartTime:(NSDate *)startTime toEndTime:(NSDate *)endTime;

- (void)emptyStartTime:(NSDate*)startTime toEndTime:(NSDate*)endTime;

- (void)setStarLabelAndImage:(NSString *)star;

- (void)setElectricityPersent:(CGFloat)persent;

- (void)refreshLatestDataForAMMorrigan:(NSArray *)AMMorriganArray PMMorrigan:(NSArray *)PMMorriganArray;

@end
