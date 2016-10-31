//
//  BTTestViewController.m
//  MORRIGAN
//
//  Created by mac-jhw on 16/10/31.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "BTTestViewController.h"
#import "BluetoothManager.h"

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
    UIButton *buttonGearAddDes = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonGearAddDes setTitle:@"手动按摩档位＋/-" forState:UIControlStateNormal];
    buttonGearAddDes.backgroundColor = [UIColor orangeColor];
    [buttonGearAddDes addTarget:self action:@selector(buttonGearAddDesHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGearAddDes];
    
     y = y + h+1;
    UIButton *buttonAutoKneek = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonAutoKneek setTitle:@"自动按摩" forState:UIControlStateNormal];
    buttonAutoKneek.backgroundColor = [UIColor orangeColor];
    [buttonAutoKneek addTarget:self action:@selector(buttonAutoKneekHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAutoKneek];

    
    y = y + h+1;
    UIButton *buttonSwitch = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h)];
    [buttonSwitch setTitle:@"开关" forState:UIControlStateNormal];
    buttonSwitch.backgroundColor = [UIColor orangeColor];
    [buttonSwitch addTarget:self action:@selector(buttonSwitchHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSwitch];
    
    
    
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

// 手动按摩档位＋/-
- (void)buttonGearAddDesHandle
{
    _currrentGear ++;
    if(_currrentGear > 3) {
        _currrentGear = 1;
    }
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currrentGear];
    
    // 测试发送数据
    NSData *head1Data = [Utils dataForHexString:@"AA"];      // 帧头
    NSData *head2Data = [Utils dataForHexString:@"55"];      // 帧头
    NSData *cmdNumData = [Utils dataForHexString:@"01"];     // 数据命令号
    NSData *switchData = [Utils dataForHexString:@"01"];     // 开关（01：开  00:关）
    NSData *modeData = [Utils dataForHexString:@"01"];       // 模式（0x01~0x03，0x01:手动模式  0x02:自动模式  0x03:音乐模式）
    NSData *gearData = [Utils dataForHexString:gearStr];       // 档位（0x01~0x03，手动模式有效）
    NSData *leftRightData = [Utils dataForHexString:@"00"];  // 左右（0x00:左右同时  0x01:左  0x02:右， 手动模式有效）
    NSData *group1Data = [Utils dataForHexString:@"01"];     // 组合单位1（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group2Data = [Utils dataForHexString:@"01"];     // 组合单位2（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group3Data = [Utils dataForHexString:@"01"];     // 组合单位3（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group4Data = [Utils dataForHexString:@"01"];     // 组合单位4（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group5Data = [Utils dataForHexString:@"01"];     // 组合单位5（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *dbData = [Utils dataForHexString:@"01"];         // 音频分贝值（0x00~0xA0，0：没声  160：音最高）
    NSData *retain1Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain2Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain3Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain4Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain5Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *verifyData = [Utils dataForHexString:@"00"];     // 校验和（0x00~0xff，前面19个无符号数字相加的和，其和对256取余数）
    NSMutableData *mutableData = [NSMutableData data];
    [mutableData appendData:head1Data];
    [mutableData appendData:head2Data];
    [mutableData appendData:cmdNumData];
    [mutableData appendData:switchData];
    [mutableData appendData:modeData];
    [mutableData appendData:gearData];
    [mutableData appendData:leftRightData];
    [mutableData appendData:group1Data];
    [mutableData appendData:group2Data];
    [mutableData appendData:group3Data];
    [mutableData appendData:group4Data];
    [mutableData appendData:group5Data];
    [mutableData appendData:dbData];
    [mutableData appendData:retain1Data];
    [mutableData appendData:retain2Data];
    [mutableData appendData:retain3Data];
    [mutableData appendData:retain4Data];
    [mutableData appendData:retain5Data];
    [mutableData appendData:verifyData];

    [[BluetoothManager share] writeValue:mutableData];
}


// 自动按摩
- (void)buttonAutoKneekHandle
{

    NSString *switchStr = [NSString stringWithFormat:@"0%ld", _currrentSwitch];
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currrentGear];
    
    // 测试发送数据
    NSData *head1Data = [Utils dataForHexString:@"AA"];      // 帧头
    NSData *head2Data = [Utils dataForHexString:@"55"];      // 帧头
    NSData *cmdNumData = [Utils dataForHexString:@"01"];     // 数据命令号
    NSData *switchData = [Utils dataForHexString:switchStr];     // 开关（01：开  00:关）
    NSData *modeData = [Utils dataForHexString:@"01"];       // 模式（0x01~0x03，0x01:手动模式  0x02:自动模式  0x03:音乐模式）
    NSData *gearData = [Utils dataForHexString:gearStr];       // 档位（0x01~0x03，手动模式有效）
    NSData *leftRightData = [Utils dataForHexString:@"00"];  // 左右（0x00:左右同时  0x01:左  0x02:右， 手动模式有效）
    NSData *group1Data = [Utils dataForHexString:@"01"];     // 组合单位1（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group2Data = [Utils dataForHexString:@"02"];     // 组合单位2（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group3Data = [Utils dataForHexString:@"03"];     // 组合单位3（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group4Data = [Utils dataForHexString:@"04"];     // 组合单位4（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group5Data = [Utils dataForHexString:@"05"];     // 组合单位5（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *dbData = [Utils dataForHexString:@"A0"];         // 音频分贝值（0x00~0xA0，0：没声  160：音最高）
    NSData *retain1Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain2Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain3Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain4Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain5Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *verifyData = [Utils dataForHexString:@"00"];     // 校验和（0x00~0xff，前面19个无符号数字相加的和，其和对256取余数）
    NSMutableData *mutableData = [NSMutableData data];
    [mutableData appendData:head1Data];
    [mutableData appendData:head2Data];
    [mutableData appendData:cmdNumData];
    [mutableData appendData:switchData];
    [mutableData appendData:modeData];
    [mutableData appendData:gearData];
    [mutableData appendData:leftRightData];
    [mutableData appendData:group1Data];
    [mutableData appendData:group2Data];
    [mutableData appendData:group3Data];
    [mutableData appendData:group4Data];
    [mutableData appendData:group5Data];
    [mutableData appendData:dbData];
    [mutableData appendData:retain1Data];
    [mutableData appendData:retain2Data];
    [mutableData appendData:retain3Data];
    [mutableData appendData:retain4Data];
    [mutableData appendData:retain5Data];
    [mutableData appendData:verifyData];
    
    [[BluetoothManager share] writeValue:mutableData];
}

// 开关
- (void)buttonSwitchHandle
{
    if(_currrentSwitch == 0) {
        _currrentSwitch = 1;
    } else {
        _currrentSwitch = 0;
    }
    NSString *switchStr = [NSString stringWithFormat:@"0%ld", _currrentSwitch];
    NSString *gearStr = [NSString stringWithFormat:@"0%ld", _currrentGear];
    
    // 测试发送数据
    NSData *head1Data = [Utils dataForHexString:@"AA"];      // 帧头
    NSData *head2Data = [Utils dataForHexString:@"55"];      // 帧头
    NSData *cmdNumData = [Utils dataForHexString:@"01"];     // 数据命令号
    NSData *switchData = [Utils dataForHexString:switchStr];     // 开关（01：开  00:关）
    NSData *modeData = [Utils dataForHexString:@"01"];       // 模式（0x01~0x03，0x01:手动模式  0x02:自动模式  0x03:音乐模式）
    NSData *gearData = [Utils dataForHexString:gearStr];       // 档位（0x01~0x03，手动模式有效）
    NSData *leftRightData = [Utils dataForHexString:@"00"];  // 左右（0x00:左右同时  0x01:左  0x02:右， 手动模式有效）
    NSData *group1Data = [Utils dataForHexString:@"01"];     // 组合单位1（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group2Data = [Utils dataForHexString:@"01"];     // 组合单位2（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group3Data = [Utils dataForHexString:@"01"];     // 组合单位3（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group4Data = [Utils dataForHexString:@"01"];     // 组合单位4（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *group5Data = [Utils dataForHexString:@"01"];     // 组合单位5（0x01~0x05，轻柔:0x01  水波:0x02 微按:0x03 强振:0x04，自动模式有效）
    NSData *dbData = [Utils dataForHexString:@"01"];         // 音频分贝值（0x00~0xA0，0：没声  160：音最高）
    NSData *retain1Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain2Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain3Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain4Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *retain5Data = [Utils dataForHexString:@"00"];    // 保留
    NSData *verifyData = [Utils dataForHexString:@"00"];     // 校验和（0x00~0xff，前面19个无符号数字相加的和，其和对256取余数）
    NSMutableData *mutableData = [NSMutableData data];
    [mutableData appendData:head1Data];
    [mutableData appendData:head2Data];
    [mutableData appendData:cmdNumData];
    [mutableData appendData:switchData];
    [mutableData appendData:modeData];
    [mutableData appendData:gearData];
    [mutableData appendData:leftRightData];
    [mutableData appendData:group1Data];
    [mutableData appendData:group2Data];
    [mutableData appendData:group3Data];
    [mutableData appendData:group4Data];
    [mutableData appendData:group5Data];
    [mutableData appendData:dbData];
    [mutableData appendData:retain1Data];
    [mutableData appendData:retain2Data];
    [mutableData appendData:retain3Data];
    [mutableData appendData:retain4Data];
    [mutableData appendData:retain5Data];
    [mutableData appendData:verifyData];
    
    [[BluetoothManager share] writeValue:mutableData];
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
