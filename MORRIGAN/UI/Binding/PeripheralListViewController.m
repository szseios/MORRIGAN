//
//  PeripheralListViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/30.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "PeripheralListViewController.h"
#import "SearchPeripheralTableViewCell.h"


#define Identifier @"CellIdentifier"

@interface PeripheralListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@end

@implementation PeripheralListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _chooseLabel.textColor = [UIColor colorWithRed:139 / 255.0
                                             green:83 / 255.0
                                              blue:221 / 255.0
                                             alpha:0.8];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SearchPeripheralTableViewCell" bundle:nil]
     forCellReuseIdentifier:Identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [BluetoothManager share].scannedPeripherals.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchPeripheralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@"设备%@",@(indexPath.row).stringValue];
    cell.uuidLabel.text = @"Morrigan";
    return cell;
}


@end
