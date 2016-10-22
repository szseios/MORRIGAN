//
//  MusicModel.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *artist;
@property (nonatomic,assign) NSTimeInterval playbackDuration;

@property (nonatomic,strong) NSURL *url;



- (instancetype)initWithItem:(MPMediaItem *)item;

- (NSString *)playBackDurationString;


@end
