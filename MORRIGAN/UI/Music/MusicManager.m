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

@interface MusicManager () <AVAudioPlayerDelegate> {
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
        _currentSelectedIndex = 0;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MusicList" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
            for (NSDictionary *dictionary in array) {
                NSString *name = [dictionary objectForKey:@"fileName"];
                NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"mp3"];
                MusicModel *model = [[MusicModel alloc] initWithDictionary:dictionary url:url];
                [_musics addObject:model];
            }
            
            MPMediaQuery *everything = [MPMediaQuery songsQuery];
            NSArray *itemsFromGenericQuery = [everything items];
            
            for (MPMediaItem *item in itemsFromGenericQuery) {
                MusicModel *model = [[MusicModel alloc] initWithItem:item];
                [_musics addObject:model];
            }
        });
    }
    return self;
}

- (void)playMusicByURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_player) {
            [_player stop];
            _player = nil;
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        _player.meteringEnabled = YES;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [_player play];
    });
    [self start];
}

- (void)prepareMusicByURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_player) {
            [_player stop];
            _player = nil;
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        _player.meteringEnabled = YES;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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

- (BOOL)prepareToPlay {
    return [_player prepareToPlay];
}


- (void)play {
    [_player play];
//    [self startGetPeakPower];
    [self start];
}

- (void)start {
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    operation.tag = MUSIC_PEAKPOWER_TAG;
    [operation setValue:@"01" index:2];
    [operation setValue:@"01" index:3];
    [operation setValue:@"04" index:4];
    
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (void)stop {
    [_player stop];
    _player = nil;
//    [self pauseGetPeakPower];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    operation.tag = MUSIC_STOP_TAG;
    [operation setValue:@"01" index:2];
    [operation setValue:@"00" index:3];
    [operation setValue:@"04" index:4];
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (void)pause {
    [_player pause];
//    [self pauseGetPeakPower];
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    operation.tag = MUSIC_STOP_TAG;
    [operation setValue:@"01" index:2];
    [operation setValue:@"00" index:3];
    [operation setValue:@"04" index:4];
    [[BluetoothManager share] writeValueByOperation:operation];
}

- (void)startGetPeakPower {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(getPeakPower)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}

- (void)pauseGetPeakPower {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)getPeakPower {
    
    if (![UserInfo share].isConnected) {
        return;
    }
    
    [_player updateMeters];                                                                      
    int16_t peakPower = [_player peakPowerForChannel:0] + 160;
    int16_t peakPower2 = [_player peakPowerForChannel:1] + 160;
    NSLog(@"getPeakPower 1 : %@   , 2 : %@",@(peakPower).stringValue,@(peakPower2).stringValue);
    
    BluetoothOperation *operation = [[BluetoothOperation alloc] init];
    operation.tag = MUSIC_PEAKPOWER_TAG;
    [operation setValue:@"01" index:2];
    [operation setValue:@"01" index:3];
    [operation setValue:@"04" index:4];
    if (peakPower > 127) {
        [operation setNumber:127 index:12];
        [operation setNumber:peakPower % 127 index:13];
    }
    else {
        [operation setNumber:peakPower index:12];
    }
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
