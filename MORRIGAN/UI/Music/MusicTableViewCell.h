//
//  MusicTableViewCell.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewCell : UITableViewCell {
    NSMutableArray *_barArray;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UIView *animationImageView;
@property (strong, nonatomic) UILabel *timeLabel;


- (void)startAnimation;

- (void)stopAnimation;

- (void)resetBars;

@end
