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
                _contentLabel.text = [UserInfo share].age;
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
                _contentLabel.text = [UserInfo share].high;
            }
                break;
                
            case 3:
            {
                _titleLabel.text = @"体重";
                _contentLabel.text = [UserInfo share].weight;
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
