//
//  LoginManager.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *authCode;
@property (nonatomic,strong)NSString *emotion;
@property (nonatomic,strong)NSString *high;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *target;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *weight;


+ (UserInfo *)share;


@end
