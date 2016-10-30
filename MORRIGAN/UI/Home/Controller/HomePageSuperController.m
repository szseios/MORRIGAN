//
//  HomePageSuperController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/3.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "HomePageSuperController.h"

@interface HomePageSuperController () {
    
    UINavigationBar *_navigationBar;
    UILabel *_titleLabel;
    UIButton *_backButton;
    UIButton *_rightButton;
    NSString *_rightText;
    NSString *_backText;
    UIView *_rightButtonView;
}

@property (nonatomic , strong) NSString *leftButtonImageName;

@property (nonatomic , strong) NSString *rightButtonImageName;



@end

@implementation HomePageSuperController

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title backButton:NO];
}

- (instancetype)initWithTitle:(NSString *)title backButton:(BOOL)isShow
{
    self = [super init];
    if (self) {
        _barTitle = title;
        _showBackButton = isShow;
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
              showRightButton:(BOOL)showRightButton
              rightButtonText:(NSString *)rightButtonText
{
    self = [super init];
    if (self) {
        _barTitle = title;
        _showBackButton = showBackButton;
        _showRightButton = showRightButton;
        _rightText = rightButtonText;
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
              showRightButton:(BOOL)showRightButton
              rightButtonText:(NSString *)rightButtonText
               backButtonText:(NSString *)backButtonText
{
    self = [super init];
    if (self) {
        _barTitle = title;
        _showBackButton = showBackButton;
        _showRightButton = showRightButton;
        _rightText = rightButtonText;
        _backText = backButtonText;
    }
    return self;
    
}

- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
          showRightButtonView:(BOOL)showRightButtonView
              rightButtonText:(NSString *)rightButtonText
               backButtonText:(NSString *)backButtonText
{
    self = [super init];
    if (self) {
        _barTitle = title;
        _showBackButton = showBackButton;
        _showRightButtonView = showRightButtonView;
        _rightText = rightButtonText;
        _backText = backButtonText;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
               showBackButton:(BOOL)showBackButton
          showRightButton:(BOOL)showRightButton
         rightButtonImageName:(NSString *)rightButtonImageName
          backButtonImageName:(NSString *)backButtonImageName
{
    self = [super init];
    if (self) {
        _barTitle = title;
        _showBackButton = showBackButton;
        _showRightButton = showRightButton;
        _leftButtonImageName = backButtonImageName;
        _rightButtonImageName = rightButtonImageName;
        
    }
    return self;
}

- (void)hiddenNavigationBar {
    _navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    _TopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    UIImageView *barImage = [[UIImageView alloc] initWithFrame:_TopBarView.bounds];
//    barImage.image = [UIImage imageNamed:@"addDeviceBackgroud"];
//    [_TopBarView addSubview:barImage];
//    _TopBarView.backgroundColor = [UIColor clearColor];
    
    if (_showBackButton) {
        
        if(_backText == nil || _backText.length == 0) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                          20,
                                                                          44,
                                                                          44)];
            [button setTitle:nil forState:UIControlStateNormal];
            if (_leftButtonImageName == nil || _leftButtonImageName.length == 0) {
                
                [button setImage:[UIImage imageNamed:@"common_btn_back_nor"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"common_btn_back_pre"] forState:UIControlStateHighlighted];
                
            }else{
                [button setImage:[UIImage imageNamed:_leftButtonImageName] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:_leftButtonImageName] forState:UIControlStateHighlighted];
            }
            
            [button addTarget:self
                       action:@selector(clickBack)
             forControlEvents:UIControlEventTouchUpInside];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.accessibilityLabel = @"返回";
            _backButton = button;
            
        } else {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          20,
                                                                          50,
                                                                          44)];
            [button setTitle:_backText forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(clickBack)
             forControlEvents:UIControlEventTouchUpInside];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            _backButton = button;
            
        }
        
        [_TopBarView addSubview:_backButton];
    }
    
    if (_showRightButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 54,
                                                                      20,
                                                                      44,
                                                                      44)];
        _rightButton = button;
        if (_rightButtonImageName == nil || _rightButtonImageName.length == 0) {
            [button setTitle:_rightText forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }else{
            [button setImage:[UIImage imageNamed:_rightButtonImageName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:_rightButtonImageName] forState:UIControlStateHighlighted];
        }
        
        [button addTarget:self
                   action:@selector(rightBarButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
        
        [_TopBarView addSubview:_rightButton];
    }
    
    if (_showRightButtonView) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 20, 80, 44)];
        _rightButtonView = rightView;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 44)];
        [button setTitle:_rightText forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(rightBarButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _rightButton = button;
        [_rightButtonView addSubview:_rightButton];
        [_TopBarView addSubview:_rightButtonView];
        
    }
    if (_barTitle) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        _titleLabel.text = _barTitle;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_TopBarView addSubview:_titleLabel];
    }
    [self.view addSubview:_TopBarView];
    
}
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick {
    
}

- (void)rightBarButtonHide:(BOOL)hide {
    [_rightButton setHidden:hide];
}

- (void)rightBarButtonEnable:(BOOL)enable {
    _rightButton.enabled = enable;
}
- (void)setRightBarButtonTextColor:(UIColor *)color {
    
    if([_rightButton isEnabled]) {
        [_rightButton setTitleColor:color forState:UIControlStateNormal];
    }
}


- (void)setRightBtnText:(NSString *)text
{
    [_rightButton setTitle:text forState:UIControlStateNormal];
    [self.view setNeedsDisplay];
}

- (void)setTitle:(NSString *)title
{
    [_titleLabel setText:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
