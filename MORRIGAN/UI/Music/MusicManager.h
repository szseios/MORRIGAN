//
//  MusicManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusicManagerDelegate <NSObject>

- (void)audioPlayerDidFinish;

@end


@interface MusicManager : NSObject

@property (nonatomic,assign)id<MusicManagerDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *musics;
@property (nonatomic,assign)NSInteger currentSelectedIndex;         //当前选中的歌曲下标

+ (MusicManager *)share;

- (void)playMusicByURL:(NSURL *)url;

- (void)prepareMusicByURL:(NSURL *)url;

- (NSArray *)musics;

- (BOOL)isPlaying;

- (BOOL)prepareToPlay;

- (void)play;

- (void)pause;

- (void)stop;

- (void)setCurrentTime:(NSTimeInterval)timeInterval;

- (NSTimeInterval)currentTime;

- (NSString *)currentTimeString;

- (void)playSilenceMusicBackground;

@end
