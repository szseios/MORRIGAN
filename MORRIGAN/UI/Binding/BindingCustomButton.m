//
//  NMOAMailToolbarButton.m
//  NMOA
//
//  Created by snhuang on 16/8/30.
//  Copyright © 2016年 snhuang. All rights reserved.
//

#import "BindingCustomButton.h"

@implementation BindingCustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self setTitleColor:[UIColor colorWithRed:139 / 255.0
                                            green:83 / 255.0
                                             blue:221 / 255.0
                                            alpha:0.8]
                   forState:UIControlStateNormal];
    }
    return self;
}


//根据button的rect设定并返回UIImageView的rect

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageW = 41;
    CGFloat imageH = 26;
    CGFloat imageX = contentRect.size.width / 2 - 55;
    CGFloat imageY = contentRect.size.height / 2 - 13;
    contentRect = (CGRect){{imageX,imageY},{imageW,imageH}};
    
    return contentRect;
}



//根据button的rect设定并返回文本label的rect
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleW = contentRect.size.width / 2 - 5;
    CGFloat titleH = 26;
    CGFloat titleX = contentRect.size.width / 2 + 4;
    CGFloat titleY = contentRect.size.height / 2 - 13;
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    
    return contentRect;
}



@end
