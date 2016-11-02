//
//  SearchPeripheralTableViewCell.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "SearchPeripheralTableViewCell.h"

@implementation SearchPeripheralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,
                                                                           0,
                                                                           68,
                                                                           70)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.06].CGColor;
    layer.path = path.CGPath;
    [_nameView.layer addSublayer:layer];
    _nameView.clipsToBounds = YES;

    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                                0,
                                                                                self.frame.size.width - 60,
                                                                                49)
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *rectLayer = [CAShapeLayer layer];
    rectLayer.fillColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.06].CGColor;
    rectLayer.path = rectPath.CGPath;
    [_uuidView.layer addSublayer:rectLayer];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameView.x,
                                                           _nameView.y + 5,
                                                           _nameView.width,
                                                           _nameView.height)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                           green:83 / 255.0
                                            blue:221 / 255.0
                                           alpha:0.7];
    [self.contentView addSubview:_nameLabel];
    
    _uuidLabel = [[UILabel alloc] initWithFrame:CGRectMake(_uuidView.x + 16,
                                                           _uuidView.y,
                                                           _uuidView.width - 32,
                                                           _uuidView.height)];
    _uuidLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_uuidLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
