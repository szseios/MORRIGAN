//
//  MusicManager.h
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject

@property (nonatomic,strong)NSMutableArray *musics;

+ (MusicManager *)share;

@end
