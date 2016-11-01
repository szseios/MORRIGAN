//
//  myDataCell.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "myDataCell.h"

@interface myDataCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




@end

@implementation myDataCell

- (void)setTitle:(NSString *)title content:(NSString *)content withIndexPath:(NSIndexPath *)index
{
    _headerImageView.hidden = YES;
    if (index.section == 0) {
        switch (index.row) {
            case 0:
            {
                _headerImageView.hidden = NO;
                _headerImageView.layer.cornerRadius = 20;
                _headerImageView.image = [UIImage imageNamed:@"defaultHeaderView"];
                _titleLabel.text = @"更换头像";
                _contentLabel.text = @"";
                _contentLabel.hidden = YES;
            }
                break;
            case 1:
            {
                _titleLabel.text = @"修改昵称";
                _contentLabel.text = [UserInfo share].nickName;
            }
                break;
                
            default:
                break;
        }
    }
    else{
        switch (index.row) {
            case 0:
            {
                _titleLabel.text = @"年龄";
                NSString *temp = [UserInfo share].age;
                _contentLabel.text = temp;
            }
                break;
            case 1:
            {
                _titleLabel.text = @"情感";
                _contentLabel.text = [UserInfo share].emotion;
            }
                break;
                
            case 2:
            {
                _titleLabel.text = @"身高";
                if (![[UserInfo share].high isKindOfClass:[NSNull class]]) {
                    _contentLabel.text = [UserInfo share].high;
                }else{
                    _contentLabel.text = @"170";
                }
                
            }
                break;
                
            case 3:
            {
                _titleLabel.text = @"体重";
                if (![[UserInfo share].weight isKindOfClass:[NSNull class]]) {
                    _contentLabel.text = [UserInfo share].weight;
                }else{
                    _contentLabel.text = @"50";
                }
                
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
