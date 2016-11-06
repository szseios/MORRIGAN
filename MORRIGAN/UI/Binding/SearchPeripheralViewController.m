//
//  SearchPeripheralViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "SearchPeripheralViewController.h"
#import "PeripheralListViewController.h"

@interface SearchPeripheralViewController ()

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@end

@implementation SearchPeripheralViewController

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
    
    [[BluetoothManager share] start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BluetoothManager share] stop];
        PeripheralListViewController *ctl = [[PeripheralListViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickStopButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
