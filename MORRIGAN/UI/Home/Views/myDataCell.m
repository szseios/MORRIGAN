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
                _headerImageView.layer.cornerRadius = 23;
//                _headerImageView.image = [UIImage imageNamed:@"defaultHeaderView"];
                [SDWebImageManager sharedManager];
                [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].imgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeaderView"] options:SDWebImageHandleCookies | SDWebImageRetryFailed | SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
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
    else if (index.section == 1){
        switch (index.row) {
            case 0:
            {
                _titleLabel.text = @"年龄";
                NSString *temp = [UserInfo share].age;
                if (temp.length > 0 && temp.integerValue != 0) {
                    _contentLabel.text = [NSString stringWithFormat:@"%@岁",temp];
                }else{
                  _contentLabel.text = @"请输入";
                }
                
            }
                break;
            case 1:
            {
                _titleLabel.text = @"情感";
                NSString *temp = [UserInfo share].emotionStr;
                if (temp.length > 0 && temp) {
                    _contentLabel.text = temp;
                }else{
                    _contentLabel.text = @"请输入";
                }
            }
                break;
                
            case 2:
            {
                _titleLabel.text = @"身高";
                NSString *temp = [UserInfo share].high;
                if (temp.length > 0 && temp) {
                    _contentLabel.text = [NSString stringWithFormat:@"%@cm",temp];
                }else{
                    _contentLabel.text = @"请输入";
                }
                
            }
                break;
                
            case 3:
            {
                _titleLabel.text = @"体重";
                NSString *temp = [UserInfo share].weight;
                if (temp.length > 0 && temp) {
                    _contentLabel.text = [NSString stringWithFormat:@"%@kg",temp];
                }else{
                    _contentLabel.text = @"请输入";
                }
                
            }
                break;
                
            default:
                break;
        }
    }else{
        _titleLabel.text = @"退出当前账户";
        _contentLabel.hidden = YES;
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
