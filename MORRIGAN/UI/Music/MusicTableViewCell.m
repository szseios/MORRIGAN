//
//  MusicTableViewCell.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/9.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "UIImage+Color.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _animationImageView = [[UIView alloc] init];
    self.backgroundColor = [UIColor colorWithRed:232 / 255.0
                                           green:223 / 255.0
                                            blue:250 / 255.0
                                           alpha:1];
    [_animationImageView setFrame:CGRectMake(kScreenWidth - 100,
                                             12,
                                             40,
                                             28)];
    [self.contentView addSubview:_animationImageView];
    
    _timeLabel = [[UILabel alloc] init];
    [_timeLabel setFrame:CGRectMake(kScreenWidth - 50,
                                    16,
                                    40,
                                    20)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    CGFloat width = 3;
    CGFloat padding = 3;
    
    _barArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 4; i++){
        UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*width+i*padding, 3, width, 1)];
        bar.userInteractionEnabled = YES;
        bar.image = [UIImage imageWithColor:[UIColor colorWithRed:157 / 255.0
                                                            green:96 / 255.0
                                                             blue:246 / 255.0
                                                            alpha:1]];
        
        [_animationImageView addSubview:bar];
        [_barArray addObject:bar];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*2);
    _animationImageView.transform = transform;
    [self hideBars];
}

-(void)ticker{
    
    [UIView animateWithDuration:.2 animations:^{
        for(UIImageView* bar in _barArray){
            CGRect rect = bar.frame;
            rect.size.height = arc4random() % 20 + 10;
            rect.origin.y = 3;
            bar.frame = rect;
        }
    }];
}

- (void)startAnimation {
    [self showBars];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(ticker) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
    [self hideBars];
}

- (void)hideBars {
    for (UIImageView* bar in _barArray) {
        bar.hidden = YES;
    }
}

- (void)showBars {
    for (UIImageView* bar in _barArray) {
        bar.hidden = NO;
    }
}

- (void)resetBars {
    for(UIImageView* bar in _barArray){
        CGRect rect = bar.frame;
        rect.size.height = 1;
        rect.origin.y = 3;
        bar.frame = rect;
        bar.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
