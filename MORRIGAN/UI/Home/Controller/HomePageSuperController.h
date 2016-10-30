//
//  HomePageSuperController.h
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

typedef enum : NSUInteger {
    superNavigationBarTypeNormal = 0,
    superNavigationBarTypeLeftItemBackAndRightItemBinding,
    superNavigationBarTypeleftItemMove,
    superNavigationBarTypeLeftItemCancel
} superNavigationBarType;

@interface HomePageSuperController : UIViewController <UIGestureRecognizerDelegate>


@property (nonatomic,strong)NSString *barTitle;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,assign)BOOL showBackButton;
@property (nonatomic,assign)BOOL showRightButton;
@property (nonatomic , assign) BOOL showRightButtonView;  //如果右边按钮文字较多，用这个防止显示不全
@property (nonatomic , strong) UIView *TopBarView;

/**
 *  初始化方法,设置title,不显示返回按钮
 *
 *  @param title title
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 *  初始化方法,设置title,根据isShow参数判断是否显示返回按钮
 *
 *  @param title  title
 *  @param isShow YES显示返回按钮
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
                   backButton:(BOOL)isShow;

/**
 *  初始化方法,设置title,根据isShow参数判断是否显示返回按钮/右边按钮
 *
 *  @param title  title
 *  @param showBackButton  YES显示返回按钮
 *  @param showRightButton YES显示右边按钮
 *  @param rightButtonText YES显示返回按钮
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
              showRightButton:(BOOL)showRightButton
              rightButtonText:(NSString *)rightButtonText;


/**
 *  初始化方法,设置title,根据isShow参数判断是否显示返回按钮/右边按钮
 *
 *  @param title  title
 *  @param showBackButton  YES显示返回按钮
 *  @param showRightButton YES显示右边按钮
 *  @param rightButtonText 右边按钮文字
 *  @param backButtonText  返回按钮文字
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
              showRightButton:(BOOL)showRightButton
              rightButtonText:(NSString *)rightButtonText
               backButtonText:(NSString *)backButtonText;

/**
 *  初始化方法,设置title,根据isShow参数判断是否显示返回按钮/右边按钮
 *
 *  @param title  title
 *  @param showBackButton  YES显示返回按钮
 *  @param showRightButtonView YES显示右边按钮的View(预防右边按钮文字显示不全)
 *  @param rightButtonText 右边按钮文字
 *  @param backButtonText  返回按钮文字
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
          showRightButtonView:(BOOL)showRightButtonView
              rightButtonText:(NSString *)rightButtonText
               backButtonText:(NSString *)backButtonText;

/**
 *  初始化方法,设置title,根据isShow参数判断是否显示返回按钮/右边按钮
 *
 *  @param title  title
 *  @param showBackButton  YES显示返回按钮
 *  @param showRightButton YES显示右边按钮的View(预防右边按钮文字显示不全)
 *  @param rightButtonImageName 右边按钮图片名字
 *  @param backButtonImageName  返回按钮图片名字
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
          showRightButton:(BOOL)showRightButton
              rightButtonImageName:(NSString *)rightButtonImageName
               backButtonImageName:(NSString *)backButtonImageName;



- (void)hiddenNavigationBar;

- (void)setTitle:(NSString *)title;

- (void)setRightBtnText:(NSString *)text;

- (void)clickBack;

- (void)rightBarButtonClick;

- (void)rightBarButtonHide:(BOOL)hide;

- (void)rightBarButtonEnable:(BOOL)enable;

- (void)setRightBarButtonTextColor:(UIColor *)color;


@end
