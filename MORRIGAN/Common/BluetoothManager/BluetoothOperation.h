//
//  BluetoothOperation.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^BluetoothOperationResponse)(NSString *response,long tag,NSError *error,BOOL success);


@interface BluetoothOperation : NSObject

@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,copy) BluetoothOperationResponse response;


- (void)setNumber:(int16_t)number index:(NSInteger)index;
- (void)setValue:(NSString *)value index:(NSInteger)index;

- (NSData *)getData;

@end
