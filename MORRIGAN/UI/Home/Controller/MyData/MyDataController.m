//
//  MyDataController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "MyDataController.h"
#import "myDataCell.h"
#import "ChooseDataView.h"
#import "NickNameController.h"
#import "BasicBarView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LoginViewController.h"

@interface MyDataController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,ChooseDataViewDelegate,BasicBarViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic , strong) ChooseDataView *chooseView;

@property (nonatomic , strong) myDataCell *selectCell;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) UIImagePickerController *imagePickerCtl;

@property (nonatomic , strong) myDataCell *headerViewCell;

@property (nonatomic , strong) NSString *imageStr;

@property (nonatomic , strong) UIView *pickerBackgroudView;

@property (nonatomic , strong) UIImage *selectedImage;

@property (nonatomic , strong) UIView *realPickerBackgroudView;

@end

@implementation MyDataController

- (ChooseDataView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[ChooseDataView alloc] initWithType:pickerViewTypeAge withFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 250)];
        _chooseView.delegate = self;
        [self.view addSubview:_chooseView];
    }
    return _chooseView;
}

static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNickName:) name:CHANGENICKNAME object:nil];
    
    [_dataTableView registerNib:[UINib nibWithNibName:@"myDataCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
//    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_logoutButton setBackgroundImage:[UIImage imageNamed:@"basicBackground"] forState:UIControlStateNormal];
//    [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//    _logoutButton.layer.cornerRadius = 5;
    _logoutButton.hidden = YES;
    
    [self setUpBarView];
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"我的资料" isShowRightButton:NO];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认退出登录" message:nil delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        // 注销／退出／修改密码
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:kUserDefaultIdKey];
        [defaults removeObjectForKey:kUserDefaultPasswordKey];
        [UserInfo share].mobile = @"";
        // 上传护理记录数据
        [[RecordManager share] uploadDBDatas:NO];
        //退出后直接断开蓝牙
        [[BluetoothManager share] unConnectingBlueTooth];
        [self.navigationController pushViewController:loginViewController animated:NO];
    }
}

#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [[NMOANetWorking share] removeTaskByTag:ID_UPLOAD_HEADER];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBingdingDevice
{
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myDataCell *cell = (myDataCell *)[_dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[myDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setTitle:nil content:@"请选择" withIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                _headerViewCell = [tableView cellForRowAtIndexPath:indexPath];
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
                [sheet showInView:self.view];
            }
                break;
            case 1:
            {
                NickNameController *nickNameCtl = [[NickNameController alloc] init];
                [self.navigationController pushViewController:nickNameCtl animated:YES];
            }
                break;
                

                
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
        _selectCell = [tableView cellForRowAtIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
            {
                [self setUpChooseViewWithType:pickerViewTypeAge];
                
            }
                break;
            case 1:
            {
                 [self setUpChooseViewWithType:pickerViewTypeFeeling];
            }
                break;
            case 2:
            {
                 [self setUpChooseViewWithType:pickerViewTypeHeight];
                
            }
                break;
                
            case 3:
            {
                 [self setUpChooseViewWithType:pickerViewTypeWeight];
                
            }
                break;

                
                
            default:
                break;
        }
        
    }else{
        [self logout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - ChooseDataViewDelegate

- (void)setUpChooseViewWithType:(pickerViewType)type
{
    _realPickerBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    _realPickerBackgroudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:_realPickerBackgroudView];
    _pickerBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-64)];
    _pickerBackgroudView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pickerBackgroudView];
    switch (type) {
        case pickerViewTypeAge:
        {
            _chooseView = [[ChooseDataView alloc] initWithType:pickerViewTypeAge withFrame:CGRectMake(0, kScreenHeight - 250-64, kScreenWidth, 250)];
        }
            break;
        case pickerViewTypeHeight:
        {
            _chooseView = [[ChooseDataView alloc] initWithType:pickerViewTypeHeight withFrame:CGRectMake(0, kScreenHeight - 250-64, kScreenWidth, 250)];
        }
            break;
        case pickerViewTypeWeight:
        {
            _chooseView = [[ChooseDataView alloc] initWithType:pickerViewTypeWeight withFrame:CGRectMake(0, kScreenHeight - 250-64, kScreenWidth, 250)];
            
        }
            break;
        case pickerViewTypeFeeling:
        {
            _chooseView = [[ChooseDataView alloc] initWithType:pickerViewTypeFeeling withFrame:CGRectMake(0, kScreenHeight - 250-64, kScreenWidth, 250)];
         
        }
            break;
            
        default:
            break;
    }
    
    _chooseView.delegate = self;
    [_pickerBackgroudView addSubview:_chooseView];
    [UIView animateWithDuration:0.2 animations:^{
        _pickerBackgroudView.y = 64;
    }];

}

- (void)cancelSelectData
{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.chooseView.y = kScreenHeight;
//        }];
    [UIView animateWithDuration:0.2 animations:^{
        _pickerBackgroudView.y = kScreenHeight;
    }];
    [_pickerBackgroudView removeFromSuperview];
    _pickerBackgroudView = nil;
    
    [_realPickerBackgroudView removeFromSuperview];
    _realPickerBackgroudView = nil;
}

- (void)sureToSelectData:(NSString *)selectData
{
    
    [_realPickerBackgroudView removeFromSuperview];
    _realPickerBackgroudView = nil;
    if(selectData == nil || selectData.length == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerBackgroudView.y = kScreenHeight;
        }];
        [self.pickerBackgroudView removeFromSuperview];
        _pickerBackgroudView = nil;
        return;
    }
    NSString *showData;
    
    switch (self.chooseView.pickerType) {
        case pickerViewTypeWeight:
        {
           
            showData = [NSString stringWithFormat:@"%@kg",selectData];
             [UserInfo share].weight = selectData;
        }
            break;
        case pickerViewTypeAge:
        {
            
            NSArray *dateArray = [selectData componentsSeparatedByString:@"-"];
            NSInteger year = [dateArray[0] integerValue];
            NSInteger month = [dateArray[1] integerValue];
            NSInteger day = [dateArray[2] integerValue];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *curDateStr = [formatter stringFromDate:[NSDate date]];
            NSArray *curDateArray = [curDateStr componentsSeparatedByString:@"-"];
            NSInteger curYear = [curDateArray[0] integerValue];
            NSInteger curmonth = [curDateArray[1] integerValue];
            NSInteger curDay = [curDateArray[2] integerValue];
            
            NSInteger age = 0;
            
            if(curmonth > month) {
                age = curYear - year;
            } else if(curmonth == month && curDay >= day) {
                age = curYear - year;
            } else {
                age = curYear - year -1;
            }
            
            if(age == 0) {
                age = 1;
            }
            
            [UserInfo share].age = [NSString stringWithFormat:@"%ld", age];
            showData = [NSString stringWithFormat:@"%@岁",[UserInfo share].age];
            
           
        }
            break;
            
        case pickerViewTypeHeight:
        {
            
            showData = [NSString stringWithFormat:@"%@cm",selectData];
            [UserInfo share].high = selectData;
        }
            break;
            
        case pickerViewTypeFeeling:
        {
            [UserInfo share].emotionStr = selectData;
            showData = selectData;
        }
            break;
            
            
        default:
            break;
    }
    _selectCell.content = showData;
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackgroudView.y = kScreenHeight;
    }];
    [self.pickerBackgroudView removeFromSuperview];
    _pickerBackgroudView = nil;
    [self uploadPersonalData];
}

- (void)uploadPersonalData
{
    if ([[UserInfo share].emotionStr isEqualToString:@"恋爱"]) {
        [UserInfo share].emotion = @"B";
    }
    else if ([[UserInfo share].emotionStr isEqualToString:@"已婚"]) {
        [UserInfo share].emotion = @"M";
    }
    else if ([[UserInfo share].emotionStr isEqualToString:@"未婚"]) {
        [UserInfo share].emotion = @"S";
    }
    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
                                     @"high": [UserInfo share].high ? [UserInfo share].high : @"",
                                     @"weight":[UserInfo share].weight ? [UserInfo share].weight : @"",
                                     @"age":[UserInfo share].age ? [UserInfo share].age : @"",
                                     @"nickName":[UserInfo share].nickName ? [UserInfo share].nickName : @"",
                                     @"target":[UserInfo share].target ? [UserInfo share].target : @"",
                                     @"emotion":[UserInfo share].emotion ? [UserInfo share].emotion : @"",
                                     };
        NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
        [[NMOANetWorking share] taskWithTag:ID_EDIT_USERINFO
                                  urlString:URL_EDIT_USERINFO
                                   httpHead:nil
                                 bodyString:bodyString
                         objectTaskFinished:^(NSError *error, id obj)
         {
             if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
                 [MBProgressHUD showHUDByContent:@"修改个人信息成功！" view:UI_Window afterDelay:2];
                 NSLog(@"修改个人信息成功！");
             }else{
                [MBProgressHUD showHUDByContent:@"修改个人信息失败！" view:UI_Window afterDelay:2];
             }
             
             
         }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex != 2) {
        _imagePickerCtl = [[UIImagePickerController alloc] init];
        _imagePickerCtl.delegate = self;
        _imagePickerCtl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerCtl.allowsEditing = YES;
        if (buttonIndex == 0) {
            [self selectImageFromCamera];
        }else{
            [self selectImageFromAlbum];
        }
    }
}

//拍照
- (void)selectImageFromCamera
{
    _imagePickerCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerCtl.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    //设置摄像头模式拍照模式
    _imagePickerCtl.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self presentViewController:_imagePickerCtl animated:YES completion:nil];
}

//从相册中选择
- (void)selectImageFromAlbum
{
    _imagePickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerCtl animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        _headerViewCell.headerImageView.image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(_headerViewCell.headerImageView.image, 0.5);
//        _headerViewCell.headerImageView.image = [avatar imageWithImageSimple:avatar scaledToSize:EZSIZE(320, 320)];
        _selectedImage = [UIImage imageWithData:fileData];
        _imageStr = [fileData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self uploadheaderImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)uploadheaderImage
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak MyDataController *weakSelf = self;
        NSDictionary *dictionary = @{
                                     @"userId":[UserInfo share].userId ? [UserInfo share].userId : @"",
                                     @"img":_imageStr
                                     };
        NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
        [[NMOANetWorking share] taskWithTag:ID_UPLOAD_HEADER
                                  urlString:URL_UPLOAD_HEADER
                                   httpHead:nil
                                 bodyString:bodyString
                         objectTaskFinished:^(NSError *error, id obj)
         {
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
                 [MBProgressHUD showHUDByContent:@"上传头像成功！" view:UI_Window afterDelay:2];
                 NSLog(@"修改个人信息成功！");
                 [[SDImageCache sharedImageCache] clearMemory];
                 [[SDImageCache sharedImageCache] cleanDisk];
                 [[SDImageCache sharedImageCache] storeImage:weakSelf.selectedImage
                                                      forKey:[UserInfo share].imgUrl
                                                      toDisk:YES];
             }else{
                 [MBProgressHUD showHUDByContent:@"上传头像失败！" view:UI_Window afterDelay:2];
             }
             
             
         }];
    }
    

#pragma mark - notification

- (void)changeNickName:(NSNotification *)notice
{
    myDataCell *cell = [_dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.content = notice.object;
    [UserInfo share].nickName = notice.object;
//    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
//                                 @"nickName": [UserInfo share].nickName ? [UserInfo share].nickName : @"",
//                                 };
//    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
//    [[NMOANetWorking share] taskWithTag:ID_EDIT_USERINFO urlString:URL_EDIT_USERINFO httpHead:nil bodyString:bodyString objectTaskFinished:^(NSError *error, id obj) {
//        
//        if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
//            [MBProgressHUD showHUDByContent:@"修改昵称成功！" view:UI_Window afterDelay:2];
//            NSLog(@"修改昵称成功！");
//        }else{
//            [MBProgressHUD showHUDByContent:@"修改昵称失败！" view:UI_Window afterDelay:2];
//        }
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_pickerBackgroudView removeFromSuperview];
    _pickerBackgroudView = nil;
    [_realPickerBackgroudView removeFromSuperview];
    _realPickerBackgroudView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:MyDataController");
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
