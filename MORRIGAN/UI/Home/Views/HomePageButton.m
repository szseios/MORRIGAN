//
//  HomePageButton.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageButton.h"

@interface HomePageButton ()

@property (nonatomic , strong) NSString *imageName;

@end

@implementation HomePageButton

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName
{
    _imageName = imageName;
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.width / 2;
        
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    return self;
}

//- (void)layoutSubviews
//{
//    for( UIView *subview in self.subviews ) {
//        if( [subview class] == [UIImageView class] ) {
//            UIImageView *image = (UIImageView *)subview;
//            image.image = [UIImage imageNamed:_imageName];
//        }
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
