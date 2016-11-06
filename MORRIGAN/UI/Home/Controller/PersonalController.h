//
//  PersonalController.h
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"

#define MOVETOHOMEPAGENOTIFICATION @"MOVETOHOMEPAGENOTIFICATION"

@protocol PersonalControllerDelegate <NSObject>

- (void)didSelectCellWithIndexPath:(NSIndexPath *)index;

@end

@interface PersonalController : UIViewController

@property (nonatomic , strong) UIImage *rightImage;

@property (nonatomic , assign) id<PersonalControllerDelegate> delegate;

@end
