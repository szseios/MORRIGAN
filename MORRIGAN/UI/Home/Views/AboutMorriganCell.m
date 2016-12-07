//
//  AboutMorriganCell.m
//  MORRIGAN
//
//  Created by azz on 2016/11/17.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "AboutMorriganCell.h"

@implementation AboutMorriganCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
