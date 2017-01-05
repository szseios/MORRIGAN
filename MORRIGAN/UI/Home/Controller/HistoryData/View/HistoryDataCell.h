//
//  HistoryDataCell.h
//  MORRIGAN
//
//  Created by azz on 2016/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic , strong) UILabel *minuteLabel;
@property (nonatomic , strong) UIImageView *emptyImage;
@property (nonatomic , strong) UILabel *unitLabel;

- (void)setTitle:(NSString *)title minuteCount:(NSString *)minute withIndexPath:(NSIndexPath *)index;

@end
