//
//  LoginBaseController.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginBaseController : UIViewController

@property(nonatomic, strong) UIScrollView   *rootScroolView;
@property(nonatomic, strong) UIView         *rootView;
@property(nonatomic, strong) UIToolbar      *keyboardTopView;


- (void)initView;

@end
