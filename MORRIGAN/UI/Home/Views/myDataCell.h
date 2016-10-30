//
//  myDataCell.h
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDataCell : UITableViewCell

- (void)setTitle:(NSString *)title content:(NSString *)content withIndexPath:(NSIndexPath *)index;

@property (nonatomic , strong) NSString *content;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end
