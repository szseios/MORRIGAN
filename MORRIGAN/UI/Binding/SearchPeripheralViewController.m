//
//  SearchPeripheralViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "SearchPeripheralViewController.h"
#import "PeripheralListViewController.h"
#import "RootViewController.h"

@interface SearchPeripheralViewController ()

@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIImageView *round;

@end

@implementation SearchPeripheralViewController

- (void)viewWillDisappear:(BOOL)animated {
    [self stopSearchPeripheral];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _stopButton.layer.cornerRadius = 5;
    _stopButton.layer.borderColor = [UIColor colorWithRed:139 / 255.0
                                                    green:83 / 255.0
                                                     blue:221 / 255.0
                                                    alpha:1].CGColor;
    _stopButton.layer.borderWidth = 1;
    [_stopButton setTitleColor:[UIColor colorWithRed:139 / 255.0
                                               green:83 / 255.0
                                                blue:221 / 255.0
                                               alpha:1]
                      forState:UIControlStateNormal];
    [self startSearchPeripheral];
}

- (void)startSearchPeripheral {
    [[BluetoothManager share] start];
    [self startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PeripheralListViewController *ctl = [[PeripheralListViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    });
}

- (void)stopSearchPeripheral {
    [[BluetoothManager share] stop];
    [self stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickStopButton:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    for (UIViewController *ctl in array) {
        if ([ctl isKindOfClass:[RootViewController class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            break;
        }
    }
}


- (void)startAnimating {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [_round.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopAnimating {
    [_round.layer removeAllAnimations];
}

@end
