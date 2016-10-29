//
//  MusicManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusicManagerDelegate <NSObject>

//- (void)

@end


@interface MusicManager : NSObject

@property (nonatomic,assign)id delegate;
@property (nonatomic,strong)NSMutableArray *musics;

+ (MusicManager *)share;

- (void)playMusicByURL:(NSURL *)url;

- (NSArray *)musics;

- (BOOL)isPlaying;

- (void)play;

- (void)pause;

- (void)setCurrentTime:(NSTimeInterval)timeInterval;

- (NSTimeInterval)currentTime;

- (NSString *)currentTimeString;

@end
