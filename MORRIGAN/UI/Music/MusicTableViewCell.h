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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *time;


- (void)selectedStatus;

- (void)unselectStatus;


- (void)startAnimation;

- (void)stopAnimation;

- (void)resetBars;

@end
