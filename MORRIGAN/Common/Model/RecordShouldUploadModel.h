//
//  PeripheralModel.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/8.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordShouldUploadModel : NSObject

@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *dateString;
@property (nonatomic,copy) NSString *timeLongString;

@end
