//
//  PeripheralBindingFinishedViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/11/6.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "PeripheralBindingFinishedViewController.h"
#import "BindingCustomButton.h"

@interface PeripheralBindingFinishedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topIcon;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (nonatomic, strong) BindingCustomButton *button;



@end

@implementation PeripheralBindingFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_connectSuccess) {
        _topIcon.image = [UIImage imageNamed:@"linkLost"];
        _middleLabel.text = @"未连接到设备";
        _middleLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                                 green:83 / 255.0
                                                  blue:221 / 255.0
                                                 alpha:0.8];

        _bottomButton.hidden = YES;
        _button = [[BindingCustomButton alloc] initWithFrame:CGRectMake(30,
                                                                        kScreenWidth - 96,
                                                                        kScreenWidth - 60,
                                                                        _bottomButton.height - 20)];
        _button.layer.cornerRadius = 5;
        _button.layer.borderColor = [UIColor colorWithRed:139 / 255.0
                                                    green:83 / 255.0
                                                     blue:221 / 255.0
                                                    alpha:0.8].CGColor;
        _button.layer.borderWidth = 1;

        [_button setImage:[UIImage imageNamed:@"icon_relink"]
                 forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"icon_relink"]
                 forState:UIControlStateHighlighted];
        [_button setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(searchAgain)
          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];

        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
}

//点击开始养护
- (IBAction)startConserve:(id)sender {
    
}

//点击重新搜索
- (void)searchAgain {
    
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
