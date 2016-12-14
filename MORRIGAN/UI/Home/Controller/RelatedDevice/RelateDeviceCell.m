//
//  RelateDeviceCell.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RelateDeviceCell.h"

@interface RelateDeviceCell ()

@property (nonatomic , strong) PeripheralModel *model;

@property (nonatomic , strong) NSIndexPath *index;

@end

@implementation RelateDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _countLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
    _macAddressLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
    _deviceIDLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
    _countLabel.font = [UIFont systemFontOfSize:18];
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modelEdit)];
    _editImageView.userInteractionEnabled = YES;
    [_editImageView addGestureRecognizer:editTap];
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modelDelete)];
    _deleteImageView.userInteractionEnabled = YES;
    [_deleteImageView addGestureRecognizer:deleteTap];
    _deviceIDLabel.numberOfLines = 0;
}

- (void)setDeviceModel:(PeripheralModel *)model withIndexPath:(NSIndexPath *)index
{
    _model = model;
    _index = index;
    if (index.row == 0) {
        _backgroundImageView.image = [UIImage imageNamed:@"addDevice"];
        _deviceIDLabel.hidden = YES;
        _countLabel.hidden = YES;
        _editImageView.hidden = YES;
        _deleteImageView.hidden = YES;
        _macAddressLabel.hidden = YES;
    }else{
        _backgroundImageView.image = [UIImage imageNamed:@"addDeviceBackgroud"];
        _deviceIDLabel.hidden = NO;
        _deviceIDLabel.text = model.name;
        _macAddressLabel.hidden = NO;
        CGFloat textWidth = [model.macAddress sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}].width;
        if (textWidth > self.width) {
            NSString *macAddress = model.macAddress;
            if (model.macAddress.length > 17) {
                macAddress = [model.macAddress substringWithRange:NSMakeRange(0,17)];
            }
            _macAddressLabel.text = macAddress;
        }else{
            _macAddressLabel.text = model.macAddress;
        }
        
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%ld",index.row];
        _editImageView.hidden = NO;
        _editImageView.image = [UIImage imageNamed:@"icon_passCode"];
        _deleteImageView.hidden = NO;
        _deleteImageView.image = [UIImage imageNamed:@"icon_delete"];
    }
}

- (void)modelEdit
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editDevice:withIndePath:)]) {
        [self.delegate editDevice:_model withIndePath:_index];
    }
}

- (void)modelDelete
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDevice:withIndePath:)]) {
        [self.delegate deleteDevice:_model withIndePath:_index];
    }
}

@end
