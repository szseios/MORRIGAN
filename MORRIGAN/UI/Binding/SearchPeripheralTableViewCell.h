//
//  SearchPeripheralTableViewCell.h
//  MORRIGAN
//
//  Created by snhuang on 2016/11/2.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPeripheralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *uuidView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *uuidLabel;

@end
