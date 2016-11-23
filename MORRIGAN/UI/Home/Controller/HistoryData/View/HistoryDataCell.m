//
//  HistoryDataCell.m
//  MORRIGAN
//
//  Created by azz on 2016/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HistoryDataCell.h"

@implementation HistoryDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title minuteCount:(NSString *)minute withIndexPath:(NSIndexPath *)index
{
    _minuteLabel.textAlignment = NSTextAlignmentRight;
    if (minute) {
        _emptyImage.hidden = YES;
        _minuteLabel.hidden = NO;
        _minuteLabel.text = minute;
    }else{
        _emptyImage.hidden = NO;
        _minuteLabel.hidden = YES;
    }
    _titleLabel.text = title;
    _unitLabel.text = @"分钟";
    switch (index.row) {
        case 0:
        {
            _titleImage.image = [UIImage imageNamed:@"icon_targetGet"];
        }
            break;
        case 1:
        {
            _titleImage.image = [UIImage imageNamed:@"icon_done"];
        }
            break;
        case 2:
        {
            _titleImage.image = [UIImage imageNamed:@"icon_over"];
        }
            break;
        case 3:
        {
            _titleImage.image = [UIImage imageNamed:@"icon_average"];
            _unitLabel.text = @"分钟/日";
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
