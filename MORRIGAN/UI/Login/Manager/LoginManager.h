//
//  LoginManager.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

@property (nonatomic,assign)BOOL autoLogin;

+ (LoginManager *)share;


@end
