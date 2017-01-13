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
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45, self.height / 2-8, 30, 30)];
    _unitLabel.font = [UIFont systemFontOfSize:12];
    _unitLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _unitLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:_unitLabel];
    
    _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 245, self.height / 2 - 15, 200, 30)];
    _minuteLabel.font = [UIFont systemFontOfSize:15];
    _minuteLabel.textAlignment = NSTextAlignmentRight;
    _minuteLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:_minuteLabel];
    _emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80, self.height / 2 - 2, 30, 4)];
    _emptyImage.image = [UIImage imageNamed:@"icon_noRecord"];
    [self addSubview:_emptyImage];
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
    [_unitLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
