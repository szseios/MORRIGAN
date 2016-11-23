//
//  ReconnectView.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/22.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "ReconnectView.h"

@implementation ReconnectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0
                                               green:0 / 255.0
                                                blue:0 / 255.0
                                               alpha:0.85];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   frame.size.height / 2 - 10,
                                                                   frame.size.width,
                                                                   20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"蓝牙已断开,正在重连...";
        [self addSubview:label];
    }
    return self;
}

@end
