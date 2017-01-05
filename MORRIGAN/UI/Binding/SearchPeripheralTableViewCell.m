//
//  SearchPeripheralTableViewCell.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "SearchPeripheralTableViewCell.h"

@interface SearchPeripheralTableViewCell() {
    CAShapeLayer *_rectLayer;
    CAShapeLayer *_layer;
}

@end

@implementation SearchPeripheralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,
                                                                           0,
                                                                           68,
                                                                           70)];
    _layer = [CAShapeLayer layer];
    _layer.fillColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.06].CGColor;
    _layer.path = path.CGPath;
    [_numberView.layer addSublayer:_layer];
    _numberView.clipsToBounds = YES;

    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                                0,
                                                                                kScreenWidth - 60,
                                                                                49)
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    _rectLayer = [CAShapeLayer layer];
    _rectLayer.fillColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.06].CGColor;
    _rectLayer.path = rectPath.CGPath;
    [_nameView.layer addSublayer:_rectLayer];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_numberView.x,
                                                             _numberView.y + 5,
                                                             _numberView.width,
                                                             _numberView.height)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                           green:83 / 255.0
                                            blue:221 / 255.0
                                           alpha:0.7];
    [self.contentView addSubview:_numberLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameView.x + 16,
                                                           _nameView.y,
                                                           _nameView.width - 32,
                                                           _nameView.height)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    UIColor *fillColor;
    
    if (highlighted) {
        fillColor =  [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.2];
    }
    else {
        fillColor =  [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.06];
    }
    
    [_rectLayer removeFromSuperlayer];
    _rectLayer = nil;
//    [_layer removeFromSuperlayer];
//    _layer = nil;
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,
//                                                                           0,
//                                                                           68,
//                                                                           70)];
//    _layer = [CAShapeLayer layer];
//    _layer.fillColor = fillColor.CGColor;
//    _layer.path = path.CGPath;
//    [_numberView.layer addSublayer:_layer];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                                0,
                                                                                kScreenWidth - 60,
                                                                                49)
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    _rectLayer = [CAShapeLayer layer];
    _rectLayer.fillColor = fillColor.CGColor;
    _rectLayer.path = rectPath.CGPath;
    [_nameView.layer addSublayer:_rectLayer];
    
}

@end
