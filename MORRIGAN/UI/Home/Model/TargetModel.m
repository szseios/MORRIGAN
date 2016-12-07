//
//  TargetModel.m
//  MORRIGAN
//
//  Created by azz on 2016/12/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "TargetModel.h"

@implementation TargetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _target = @"";
        _isUpload = 0;
    }
    return self;
}

@end
