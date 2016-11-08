//
//  PeripheralListViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "PeripheralListViewController.h"
#import "SearchPeripheralTableViewCell.h"
#import "PeripheralBindingFinishedViewController.h"
#import "RootViewController.h"
#import "PeripheralModel.h"


#define Identifier @"CellIdentifier"

@interface PeripheralListViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSDictionary *_linkedPeripherals;            //已绑定的设备
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet UIView *squareView;
@property (weak, nonatomic) IBOutlet UILabel *connectingLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *runloopImageView;

@end

@implementation PeripheralListViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectPeripheralSuccess)
                                                 name:ConnectPeripheralSuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectPeripheralError)
                                                 name:ConnectPeripheralError
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectPeripheralError)
                                                 name:DisconnectPeripheral
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _linkedPeripherals = [DBManager selectLinkedPeripherals];
    
    _chooseLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                             green:83 / 255.0
                                              blue:221 / 255.0
                                             alpha:0.8];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SearchPeripheralTableViewCell" bundle:nil]
     forCellReuseIdentifier:Identifier];
    
    _connectingLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                                 green:83 / 255.0
                                                  blue:221 / 255.0
                                                 alpha:0.8];
    
    _squareView.layer.cornerRadius = 5;
    _squareView.layer.borderColor = [UIColor colorWithRed:139 / 255.0
                                                    green:83 / 255.0
                                                     blue:221 / 255.0
                                                    alpha:0.8].CGColor;
    _squareView.layer.borderWidth = 1;
    _squareView.hidden = YES;
    _bottomView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    for (UIViewController *ctl in array) {
        if ([ctl isKindOfClass:[RootViewController class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BluetoothManager share].scannedPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchPeripheralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.linkedIcon.hidden = YES;
    
    CBPeripheral *peripheral = [BluetoothManager share].scannedPeripherals[indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat:@"设备%@",@(indexPath.row + 1).stringValue];
    cell.nameLabel.text = peripheral.name;
    PeripheralModel *model = [_linkedPeripherals objectForKey:peripheral.identifier.UUIDString];
    if (model) {
        cell.linkedIcon.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = [BluetoothManager share].scannedPeripherals[indexPath.row];
    [[BluetoothManager share] connectingBlueTooth:peripheral];
    _bottomView.hidden = NO;
    _squareView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    [self startAnimating];
}

- (void)connectPeripheralSuccess {
    PeripheralBindingFinishedViewController *ctl = [[PeripheralBindingFinishedViewController alloc] init];
    ctl.connectSuccess = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)connectPeripheralError {
    PeripheralBindingFinishedViewController *ctl = [[PeripheralBindingFinishedViewController alloc] init];
    ctl.connectSuccess = NO;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)startAnimating {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.75;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [_runloopImageView.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopAnimating {
    [_runloopImageView.layer removeAllAnimations];
}


@end
