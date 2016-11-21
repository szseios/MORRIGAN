//
//  PersonalCell.m
//  MORRIGAN
//
//  Created by azz on 2016/11/16.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "PersonalCell.h"

@implementation PersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
