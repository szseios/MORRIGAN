//
//  BasicBarView.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BasicBarView.h"

@interface BasicBarView ()

@property (nonatomic , assign) superBarType type;

@property (nonatomic , strong) UILabel *titleLabel;

@end

@implementation BasicBarView

- (instancetype)initWithFrame:(CGRect)frame withType:(superBarType)type withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _title = title;
        self.backgroundColor = [UIColor clearColor];
        [self setUpBasicBarView];
    }
    return self;
}

- (void)setUpBasicBarView
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _title;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_titleLabel];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, self.height)];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 60, 0, 40, self.height)];
    
    switch (_type) {
        case superBarTypeNormal:
        {
            
        }
            break;
            
        case superBarTypeleftItemMove:
        {
            [_backButton addTarget:self action:@selector(moveToLeft) forControlEvents:UIControlEventTouchUpInside];
            [_backButton setImage:[UIImage imageNamed:@"Menu_icon"] forState:UIControlStateNormal];
            
            [_rightButton addTarget:self action:@selector(bindingDevice) forControlEvents:UIControlEventTouchUpInside];
            [_rightButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
            
            [self addSubview:_backButton];
            [self addSubview:_rightButton];
        }
            break;
            
        case superBarTypeLeftItemCancel:
        {
            [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
            [_backButton setTitle:@"取消" forState:UIControlStateNormal];
            
            [_rightButton addTarget:self action:@selector(ensureClick) forControlEvents:UIControlEventTouchUpInside];
            [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
            
            [self addSubview:_backButton];
            [self addSubview:_rightButton];
        }
            break;
            
        case superBarTypeLeftItemBackAndRightItemBinding:
        {
            [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
            [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            
            [_rightButton addTarget:self action:@selector(bindingDevice) forControlEvents:UIControlEventTouchUpInside];
            [_rightButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
            
            [self addSubview:_backButton];
            [self addSubview:_rightButton];
        }
            break;
            
        default:
            break;
    }
}

- (void)backClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBack)]) {
        [self.delegate clickBack];
    }
}

- (void)ensureClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEnsure)]) {
        [self.delegate clickEnsure];
    }
}

- (void)moveToLeft
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMoveToLeft)]) {
        [self.delegate clickMoveToLeft];
    }
}

- (void)bindingDevice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBingdingDevice)]) {
        [self.delegate clickBingdingDevice];
    }
}

- (void)setRightButtonEnable:(BOOL)enable
{
    if (!enable) {
        [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    _rightButton.enabled = enable;
//    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
