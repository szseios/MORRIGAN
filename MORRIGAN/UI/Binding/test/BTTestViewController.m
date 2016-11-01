//
//  BTTestViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/31.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

/**
 
 蓝牙通讯测试
 
 **/

#import "BTTestViewController.h"
#import "BluetoothManager.h"
#import "BtSettingInfo.h"

@interface BTTestViewController ()
{
    NSInteger _currrentGear;
    NSInteger _currrentSwitch;
    
}

@end

@implementation BTTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    _currrentSwitch = 1;
    
    CGFloat h = 60;
    CGFloat y = 25;
    UIButton *buttonScan = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonScan setTitle:@"扫描" forState:UIControlStateNormal];
    buttonScan.backgroundColor = [UIColor orangeColor];
    [buttonScan addTarget:self action:@selector(buttonScanHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonScan];
    
    y = y + h+1;
    UIButton *buttonConnect = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonConnect setTitle:@"连接" forState:UIControlStateNormal];
    buttonConnect.backgroundColor = [UIColor orangeColor];
    [buttonConnect addTarget:self action:@selector(buttonConnectHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonConnect];
    
     y = y + h+1;
    UIButton *buttonUnConnect = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonUnConnect setTitle:@"断开连接" forState:UIControlStateNormal];
    buttonUnConnect.backgroundColor = [UIColor orangeColor];
    [buttonUnConnect addTarget:self action:@selector(buttonUnConnectHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonUnConnect];
    
    y = y + h+1;
    UIButton *buttonSwitch = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonSwitch setTitle:@"按摩开关" forState:UIControlStateNormal];
    buttonSwitch.backgroundColor = [UIColor orangeColor];
    [buttonSwitch addTarget:self action:@selector(buttonSwitchHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSwitch];
    
    y = y + h+1;
    UIButton *buttonHandKneek = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonHandKneek setTitle:@"手动模式" forState:UIControlStateNormal];
    buttonHandKneek.backgroundColor = [UIColor orangeColor];
    [buttonHandKneek addTarget:self action:@selector(buttonHandKneekHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonHandKneek];
    
     y = y + h+1;
    UIButton *buttonGearAddDes = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonGearAddDes setTitle:@"手动模式档位＋/-" forState:UIControlStateNormal];
    buttonGearAddDes.backgroundColor = [UIColor orangeColor];
    [buttonGearAddDes addTarget:self action:@selector(buttonGearAddDesHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGearAddDes];
    
     y = y + h+1;
    UIButton *buttonAutoKneek = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonAutoKneek setTitle:@"自动模式" forState:UIControlStateNormal];
    buttonAutoKneek.backgroundColor = [UIColor orangeColor];
    [buttonAutoKneek addTarget:self action:@selector(buttonAutoKneekHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAutoKneek];
    
    y = y + h+1;
    UIButton *buttonMusic = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonMusic setTitle:@"音乐模式" forState:UIControlStateNormal];
    buttonMusic.backgroundColor = [UIColor orangeColor];
    [buttonMusic addTarget:self action:@selector(buttonMusicHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonMusic];
    
    y = y + h+1;
    UIButton *buttonBattery = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonBattery setTitle:@"主动获取🔋" forState:UIControlStateNormal];
    buttonBattery.backgroundColor = [UIColor orangeColor];
    [buttonBattery addTarget:self action:@selector(buttonBatteryHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBattery];
    
    y = y + h+1;
    UIButton *buttonBtEnable = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonBtEnable setTitle:@"确认蓝牙可通讯" forState:UIControlStateNormal];
    buttonBtEnable.backgroundColor = [UIColor orangeColor];
    [buttonBtEnable addTarget:self action:@selector(buttonBtEnableHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBtEnable];

    
}

// 扫描
- (void)buttonScanHandle
{
     [[BluetoothManager share] scanTest];
}


// 连接
- (void)buttonConnectHandle
{
    [[BluetoothManager share] connectTest];

}

// 断开连接
- (void)buttonUnConnectHandle
{
    [[BluetoothManager share] unConnectTest];
}

// 按摩开关
- (void)buttonSwitchHandle
{
    if(_currrentSwitch == 0) {
        _currrentSwitch = 1;
    } else {
        _currrentSwitch = 0;
    }
    NSString *switchStr = [NSString stringWithFormat:@"0%ld", _currrentSwitch];
    
    
    
    // 修改开关值
    [[BtSettingInfo share] setSwitchHexString:switchStr];
    
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultData]];
}




// 手动模式
- (void)buttonHandKneekHandle
{
    // 设置为手动模式
    [[BtSettingInfo share] setModeHexString:@"01"];
    
    
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultData]];
}


// 手动档位＋/-
- (void)buttonGearAddDesHandle
{
    _currrentGear ++;
    if(_currrentGear > 3) {
        _currrentGear = 1;
    }
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currrentGear];
    
    
    // 设置档位值
    [[BtSettingInfo share] setGearHexString:gearStr];
    

    
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultData]];
}


// 自动模式
- (void)buttonAutoKneekHandle
{

    // 设置为自动模式
    [[BtSettingInfo share] setModeHexString:@"02"];
    // 设置自动组合
    [[BtSettingInfo share] setGroup1HexString:@"01"];
    [[BtSettingInfo share] setGroup2HexString:@"01"];
    [[BtSettingInfo share] setGroup3HexString:@"01"];
    [[BtSettingInfo share] setGroup4HexString:@"01"];
    [[BtSettingInfo share] setGroup5HexString:@"01"];
    
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultData]];
    
}

// 音乐模式
- (void)buttonMusicHandle
{
    // 设置为自动模式
    [[BtSettingInfo share] setModeHexString:@"03"];
    
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultData]];
}

// 主动获取电量
- (void)buttonBatteryHandle
{
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultDataOfBattery]];
}


// 确认蓝牙可通讯
- (void)buttonBtEnableHandle
{
    // 写数据
    [[BluetoothManager share] writeValue: [[BtSettingInfo share] getResultDataOfBtEnable]];
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
