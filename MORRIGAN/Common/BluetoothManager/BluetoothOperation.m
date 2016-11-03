//
//  BluetoothOperation.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BluetoothOperation.h"

static NSInteger staticTag = 0;
static NSString * const BluetoothHead0 = @"AA";
static NSString * const BluetoothHead1 = @"55";


@implementation BluetoothOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tag = staticTag ++;
        _datas = [[NSMutableArray alloc] initWithCapacity:20];
        _datas[0] = BluetoothHead0;
        _datas[1] = BluetoothHead1;
        for (NSInteger i = 2; i < 20; i++) {
            _datas[i] = @"00";
        }
    }
    return self;
}

- (void)setNumber:(int16_t)number index:(NSInteger)index {
    _datas[index] = [Utils intToHex:number];
}

- (void)setValue:(NSString *)value index:(NSInteger)index {
    _datas[index] = value;
}

- (NSData *)getData {
    NSInteger result = 0;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:20];
    for (NSInteger i = 0; i < 20; i++) {
        if (i == 19) {
            NSString *resultString = [Utils intToHex:result % 256 ];
            [data appendData:[Utils dataForHexString:resultString]];
            break;
        }
        [data appendData:[Utils dataForHexString:_datas[i]]];
        result += [Utils hexToInt:_datas[i]];
    }
    return data;
}


@end
