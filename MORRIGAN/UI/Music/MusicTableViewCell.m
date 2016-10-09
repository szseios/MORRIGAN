//
//  MusicTableViewCell.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _animationImageView = [[UIImageView alloc] init];
    [_animationImageView setFrame:CGRectMake(kScreenWidth - 100,
                                             12,
                                             40,
                                             28)];
    _animationImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_animationImageView];
    
    _timeLabel = [[UILabel alloc] init];
    [_timeLabel setFrame:CGRectMake(kScreenWidth - 50,
                                    16,
                                    40,
                                    20)];
    [self.contentView addSubview:_timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
