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

@interface MusicManager () {
    NSTimer *_timer;
}

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
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            MPMediaQuery *everything = [MPMediaQuery songsQuery];
            NSArray *itemsFromGenericQuery = [everything items];
            
            for (MPMediaItem *item in itemsFromGenericQuery) {
                MusicModel *model = [[MusicModel alloc] initWithItem:item];
                [_musics addObject:model];
            }
        });
        
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
        _player.meteringEnabled = YES;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_player play];
    });
    [self startGetPeakPower];
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
    [self startGetPeakPower];
}

- (void)pause {
    [_player pause];
    [self pauseGetPeakPower];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:@"00" index:3];
    [operation setValue:@"03" index:4];
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (void)startGetPeakPower {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getPeakPower) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)pauseGetPeakPower {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)getPeakPower {
    [_player updateMeters];
    int16_t peakPower = [_player peakPowerForChannel:0] + 160;
    NSLog(@"getPeakPower : %@   , chanels : %@",@(peakPower).stringValue,@(peakPower).stringValue);
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    [operation setValue:@"01" index:2];
    [operation setValue:@"01" index:3];
    [operation setValue:@"03" index:4];
    [operation setNumber:peakPower index:12];
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSString *)currentTimeString {
    NSInteger duration = (NSInteger)_player.currentTime;
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld",(long)duration / 60,(long)duration % 60];
    return string;
}

#pragma mark - AVAudioPlayerDelegate
// 播放完成时调用   只有当播放结束时才会调用，循环播放时不会调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayerDidFinish)]) {
        [_delegate audioPlayerDidFinish];
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {

}

@end
