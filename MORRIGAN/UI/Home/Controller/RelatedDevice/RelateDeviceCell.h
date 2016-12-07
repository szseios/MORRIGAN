//
//  RelateDeviceCell.h
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeripheralModel.h"

@protocol RelateDeviceCellDelegate <NSObject>

- (void)editDevice:(PeripheralModel *)model withIndePath:(NSIndexPath *)index;

- (void)deleteDevice:(PeripheralModel *)model withIndePath:(NSIndexPath *)index;

@end

@interface RelateDeviceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;

@property (nonatomic , assign) id<RelateDeviceCellDelegate> delegate;

- (void)setDeviceModel:(PeripheralModel *)model withIndexPath:(NSIndexPath *)index;

@end
