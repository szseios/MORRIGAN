//
//  MassageRecordModel.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/14.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MassageType) {
    MassageTypeAuto = 0,                //自动按摩
    MassageTypeManual,                  //手动按摩
    MassageTypeMusic                    //音乐随动
};

@interface MassageRecordModel : NSObject

@property (nonatomic,copy) NSString *userID;

@property (nonatomic,copy) NSDate *startTime;
@property (nonatomic,copy) NSDate *endTime;

@property (nonatomic,assign) MassageType type;

@end
