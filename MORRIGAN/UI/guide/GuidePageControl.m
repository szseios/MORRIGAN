//
//  GuidePageControl.m
//  MORRIGAN
//
//  Created by azz on 2016/12/5.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "GuidePageControl.h"

#define IMAGEEMPTY @"pagecontroll_empty"
#define IMAGEFULL  @"pageControll_full"

@interface GuidePageControl ()

@property (nonatomic , strong) NSMutableArray *pageArray;

@end

@implementation GuidePageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageArray = [NSMutableArray array];
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    CGFloat fullW = 50;
    CGFloat fullH = 4;
    CGFloat emptyW = 24;
    CGFloat imageX = (self.width - fullW - 3*emptyW - 24 ) / 2;
    CGFloat imageY = 10;
    
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView;
        if (i == 0) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, fullW, fullH)];
            imageView.image = [UIImage imageNamed:IMAGEFULL];
        }else{
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, emptyW, fullH)];
            imageView.image = [UIImage imageNamed:IMAGEEMPTY];
        }
        imageView.tag = 1000 + i;
        [_pageArray addObject:imageView];
        [self addSubview:imageView];
        imageX = CGRectGetMaxX(imageView.frame) + 8;
    }  
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    CGFloat fullW = 50;
    CGFloat fullH = 4;
    CGFloat emptyW = 24;
    CGFloat imageX = (self.width - fullW - 3*emptyW - 24 ) / 2;
    CGFloat imageY = 10;
    
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [self viewWithTag:1000 + i];
        if (i == currentPage) {
            imageView.frame = CGRectMake(imageX, imageY, fullW, fullH);
            imageView.image = [UIImage imageNamed:IMAGEFULL];
        }else{
            imageView.frame = CGRectMake(imageX, imageY, emptyW, fullH);
            imageView.image = [UIImage imageNamed:IMAGEEMPTY];
        }
//        imageView.tag = 1000 + i;
//        [_pageArray addObject:imageView];
//        [self addSubview:imageView];
        imageX = CGRectGetMaxX(imageView.frame) + 8;
    }
}

@end
