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

@property (nonatomic , weak) id<BasicBarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withType:(superBarType)type withTitle:(NSString *)title;

@end
