//
//  MusicTableViewCell.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *animationImageView;
@property (strong, nonatomic) UILabel *timeLabel;


@end
