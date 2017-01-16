//
//  HistoryDataCell.m
//  MORRIGAN
//
//  Created by azz on 2016/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "HistoryDataCell.h"

@interface HistoryDataCell()
{
    CGRect _unitLabelFrameShort;
    CGRect _unitLabelFrameLong;
    
    CGRect _minuteLabelFrameShort;
    CGRect _minuteLabelFrameLong;
    
    
    CGRect _emptyImageFrameShort;
    CGRect _emptyImageFrameLong;
}

@end


@implementation HistoryDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45, self.height / 2-8, 30, 30)];
    _unitLabelFrameShort = _unitLabel.frame;
    _unitLabelFrameLong = CGRectMake(kScreenWidth - 58, self.height / 2-8, 40, 30);
    _unitLabel.font = [UIFont systemFontOfSize:12];
    _unitLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _unitLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:_unitLabel];
    
    _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 245, self.height / 2 - 15, 200, 30)];
    _minuteLabelFrameShort = _minuteLabel.frame;
    _minuteLabelFrameLong = CGRectMake(kScreenWidth - 258, self.height / 2 - 15, 200, 30);
    _minuteLabel.font = [UIFont systemFontOfSize:15];
    _minuteLabel.textAlignment = NSTextAlignmentRight;
    _minuteLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:_minuteLabel];
    _emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80, self.height / 2 - 2, 30, 2)];
    _emptyImageFrameShort = CGRectMake(kScreenWidth - 80, self.height / 2 - 2, 30, 2);
    _emptyImageFrameLong = CGRectMake(kScreenWidth - 92, self.height / 2 - 2, 30, 2);
    _emptyImage.image = [UIImage imageNamed:@"icon_noRecord"];
    [self addSubview:_emptyImage];
}

- (void)setTitle:(NSString *)title minuteCount:(NSString *)minute withIndexPath:(NSIndexPath *)index
{
    _minuteLabel.textAlignment = NSTextAlignmentRight;
    //minute = @"180"; // 测试
    _emptyImage.frame = _emptyImageFrameShort;
    if (minute) {
        _emptyImage.hidden = YES;
        _minuteLabel.hidden = NO;
        _minuteLabel.text = minute;
    }else{
        _emptyImage.hidden = NO;
        _minuteLabel.hidden = YES;
        if(index.row == 3) {
            _emptyImage.frame = _emptyImageFrameLong;
        }
        
    }
    _titleLabel.text = title;
    _unitLabel.text = @"分钟";
    _unitLabel.frame = _unitLabelFrameShort;
    _minuteLabel.frame = _minuteLabelFrameShort;
    
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
            _unitLabel.frame = _unitLabelFrameLong;
            _minuteLabel.frame = _minuteLabelFrameLong;
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
