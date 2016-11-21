//
//  HomePageController.h
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"

@protocol HomePageControllerDelegate <NSObject>

- (void)leftClick;

- (void)rightClick;

@end

@interface HomePageController : HomePageSuperController

@property (nonatomic , weak) id<HomePageControllerDelegate> delegate;

@property (nonatomic , assign) BOOL isLeft;

@end
