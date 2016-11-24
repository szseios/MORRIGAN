//
//  BasicBarView.h
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasicBarViewDelegate <NSObject>

@optional

- (void)clickBack;

- (void)clickEnsure;

- (void)clickBingdingDevice;

- (void)clickMoveToLeft;

@end

typedef enum : NSUInteger {
    superBarTypeNormal = 0,
    superBarTypeLeftItemBackAndRightItemBinding,
    superBarTypeleftItemMove,
    superBarTypeLeftItemCancel
} superBarType;

@interface BasicBarView : UIView

@property (nonatomic , strong) NSString *title;
@property (nonatomic,assign)BOOL showBackButton;
@property (nonatomic,assign)BOOL showRightButton;
@property (nonatomic , assign) BOOL showRightButtonView;

@property (nonatomic , strong) UIButton *backButton;

@property (nonatomic , strong) UIButton *rightButton;

@property (nonatomic , weak) id<BasicBarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withType:(superBarType)type withTitle:(NSString *)title isShowRightButton:(BOOL)showRightButton;

- (void)setRightButtonEnable:(BOOL)enable;

- (void)setTitleLabelText:(NSString *)title;

- (void)startFlashing;

- (void)stopFlashing;

@end
