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

- (instancetype)initWithFrame:(CGRect)frame withType:(superBarType)type withTitle:(NSString *)title isShowRightButton:(BOOL)showRightButton
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _title = title;
        _showRightButton = showRightButton;
        self.backgroundColor = [UIColor clearColor];
        [self setUpBasicBarView];
    }
    return self;
}

- (void)setUpBasicBarView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopFlashing)
                                                 name:ConnectPeripheralSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFlashing)
                                                 name:DisconnectPeripheral
                                               object:nil];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _title;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_titleLabel];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 40, self.height)];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 55, 0, 40, self.height)];
    if (_showRightButton) {
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }
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
        }
            break;
            
        case superBarTypeLeftItemCancel:
        {
            [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
            [_backButton setTitle:@"取消" forState:UIControlStateNormal];
            
            [_rightButton addTarget:self action:@selector(ensureClick) forControlEvents:UIControlEventTouchUpInside];
            [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        }
            break;
            
        case superBarTypeLeftItemBackAndRightItemBinding:
        {
            [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
            [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            
            [_rightButton addTarget:self action:@selector(bindingDevice) forControlEvents:UIControlEventTouchUpInside];
            [_rightButton setImage:[UIImage imageNamed:@"icon_rightItem_link"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    
    [self addSubview:_backButton];
    [self addSubview:_rightButton];
    
    //如果没有连上蓝牙设备,开始执行动画
    if (![UserInfo share].isConnected) {
        if (_type == superBarTypeLeftItemBackAndRightItemBinding) {
            [self startFlashing];
        }
    }
}

- (void)stopFlashing
{
    [_rightButton.layer removeAllAnimations];
}

- (void)startFlashing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.repeatCount = NSIntegerMax;
    animation.fromValue = @(1);
    animation.toValue = @(0.3);
    animation.autoreverses = YES;
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    [_rightButton.layer addAnimation:animation forKey:nil];
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
}

- (void)setTitleLabelText:(NSString *)title
{
    _titleLabel.text = title;
    [self setNeedsDisplay];
}


- (void)showCenterView
{
    _titleLabel.hidden = YES;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, (self.height - 30)*0.5, kScreenWidth - 120, 30)];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoImageView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
