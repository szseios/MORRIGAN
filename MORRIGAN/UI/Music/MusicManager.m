//
//  MusicManager.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "MusicManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"

static MusicManager *manager = nil;

@interface MusicManager ()

@property (nonatomic,strong)AVAudioPlayer *player;

@end

@implementation MusicManager

+ (MusicManager *)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MusicManager alloc] init];
    });
    
    return manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _musics = [[NSMutableArray alloc] init];
        
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            MPMediaQuery *everything = [MPMediaQuery songsQuery];
            NSArray *itemsFromGenericQuery = [everything items];
            
            for (MPMediaItem *item in itemsFromGenericQuery) {
                MusicModel *model = [[MusicModel alloc] initWithItem:item];
                [_musics addObject:model];
            }
//        });
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MusicList" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    }
    return self;
}

- (void)playMusicByURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_player) {
            [_player stop];
            _player = nil;
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_player play];
    });
}

- (NSArray *)musics {
    return _musics;
}

- (void)setCurrentTime:(NSTimeInterval)timeInterval {
    [_player setCurrentTime:timeInterval];
}

- (BOOL)isPlaying {
    return _player.isPlaying;
}

- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSString *)currentTimeString {
    NSInteger duration = (NSInteger)_player.currentTime;
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld",duration / 60,duration % 60];
    return string;
}

#pragma mark - AVAudioPlayerDelegate
// 播放完成时调用   只有当播放结束时才会调用，循环播放时不会调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {

}

@end
