//
//  FuntionButton.h
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/25.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuntionButton : UIButton

@property(nonatomic,strong)UIImage *buttonImage;             // 按钮的图标
@property(nonatomic,assign)CGFloat distanceFromDragButton;   // 计算的与拖动按钮的距离
@property(nonatomic,assign)NSInteger arrayIndex;             // 所在数组下标
@property(nonatomic,strong)NSString *funCodeString;           // 对应的指令串


-(instancetype)initWithFrame:(CGRect)frame;


@end
