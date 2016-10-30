//
//  ChooseDataView.h
//  MORRIGAN
//
//  Created by azz on 2016/10/16.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    pickerViewTypeAge = 0,    //年龄
    pickerViewTypeFeeling,  //情感
    pickerViewTypeHeight,   //身高
    pickerViewTypeWeight    //体重
} pickerViewType;

@protocol ChooseDataViewDelegate <NSObject>

- (void)cancelSelectData;
- (void)sureToSelectData:(NSString *)selectData;

@end

@interface ChooseDataView : UIView

@property (nonatomic , assign) pickerViewType pickerType;

@property (nonatomic , assign) id<ChooseDataViewDelegate> delegate;

- (instancetype)initWithType:(pickerViewType)type withFrame:(CGRect)frame;

- (void)setCurrentAge:(NSString *)age;

@end
