//
//  EditDeviceNameController.m
//  MORRIGAN
//
//  Created by azz on 2016/11/15.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "EditDeviceNameController.h"
#import "PeripheralModel.h"

@interface EditDeviceNameController ()<BasicBarViewDelegate>

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) PeripheralModel *model;

@end

@implementation EditDeviceNameController

- (instancetype)initWithDeviceModel:(PeripheralModel *)model
{
    if (self = [super init]) {
        if (model) {
            _model = model;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    
    if (_model) {
        _textField.text = _model.name;
    }
    
    [self setUpBarView];
}


- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemCancel withTitle:@"修改设备名称"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEnsure
{
    if (_textField.text.length > 0) {
        _model.name = _textField.text;
        [self uploadDeviceNameData];
    }
    
}


- (void)uploadDeviceNameData
{
    NSDictionary *dictionary = @{
                                 @"userId":[UserInfo share].userId,
                                 @"deviceName":_textField.text,
                                 @"mac":_model.uuid
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_EDIT_DEVICENAME
                              urlString:URL_EDIT_DEVICENAME
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             [MBProgressHUD showHUDByContent:@"修改设备信息成功！" view:UI_Window afterDelay:2];
             [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEDEVICENAMENOTIFICATION object:_textField.text];
             [self.navigationController popViewControllerAnimated:YES];
             NSLog(@"修改设备信息成功！");
         }else{
             [MBProgressHUD showHUDByContent:@"修改设备信息失败！" view:UI_Window afterDelay:2];
         }
         
         
     }];
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