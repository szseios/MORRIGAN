//
//  RelateDeviceCell.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RelateDeviceCell.h"

@interface RelateDeviceCell ()

@property (nonatomic , strong) relateDeviceModel *model;

@property (nonatomic , strong) NSIndexPath *index;

@end

@implementation RelateDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modelEdit)];
    _editImageView.userInteractionEnabled = YES;
    [_editImageView addGestureRecognizer:editTap];
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modelDelete)];
    _deleteImageView.userInteractionEnabled = YES;
    [_deleteImageView addGestureRecognizer:deleteTap];
    _deviceIDLabel.numberOfLines = 0;
}

- (void)setDeviceModel:(relateDeviceModel *)model withIndexPath:(NSIndexPath *)index
{
    _model = model;
    _index = index;
    if (index.row == 0) {
        _backgroundImageView.image = [UIImage imageNamed:@"addDevice"];
        _deviceIDLabel.hidden = YES;
        _countLabel.hidden = YES;
        _editImageView.hidden = YES;
        _deleteImageView.hidden = YES;
    }else{
        _backgroundImageView.image = [UIImage imageNamed:@"addDeviceBackgroud"];
        _deviceIDLabel.hidden = NO;
        _deviceIDLabel.text = model.deviceID;
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
