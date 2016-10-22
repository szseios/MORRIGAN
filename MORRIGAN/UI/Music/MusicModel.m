//
//  MusicModel.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel


- (instancetype)initWithItem:(MPMediaItem *)item
{
    self = [super init];
    if (self) {
        _title = item.title;
        _playbackDuration = item.playbackDuration;
        _artist = item.artist;
        _url = item.assetURL;
    }
    return self;
}

- (NSString *)playBackDurationString {
    NSInteger duration = (NSInteger)_playbackDuration;
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld",duration / 60,duration % 60];
    
    return string;
}

@end
