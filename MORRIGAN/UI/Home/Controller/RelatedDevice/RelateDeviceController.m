//
//  RelateDeviceController.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RelateDeviceController.h"
#import "RelateDeviceCell.h"
#import "EditDeviceNameController.h"

#define RelateDeviceCellID @"RelateDeviceCellID"

@interface RelateDeviceController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BasicBarViewDelegate,RelateDeviceCellDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) NSMutableArray *deviceArray;

@property (nonatomic , strong) NSIndexPath *editIndex;

@property (nonatomic , strong) PeripheralModel *model;

@end

@implementation RelateDeviceController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDeviceName:) name:CHANGEDEVICENAMENOTIFICATION object:nil];
    
    _deviceArray = [[NSMutableArray alloc] initWithObjects:[[PeripheralModel alloc] init], nil];
    NSArray *peripherals = [DBManager selectPeripherals];
    if (peripherals) {
        [_deviceArray addObjectsFromArray:peripherals];
    }
    
//    for (NSInteger i = 0; i< 5; i++) {
//        PeripheralModel *model = [[PeripheralModel alloc] init];
//        model.name = [NSString stringWithFormat:@"model%ld",i];
//        model.uuid = @"njvjklnsjnl";
//        [_deviceArray addObject:model];
//    }
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    [self setUpBarView];
    
    [self setUpCollectionView];
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
    
    
}

- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreenWidth - 30) / 2;
    
    layout.itemSize = CGSizeMake(itemW, itemW);
    CGFloat paddingX = 10;
    layout.sectionInset = UIEdgeInsetsMake(paddingX, paddingX, paddingX, paddingX);
    layout.minimumLineSpacing = paddingX;
    
    CGFloat collectionViewY = 64;
    CGFloat collectionViewHeight = kScreenHeight - 64;
    UICollectionView *CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,collectionViewY, kScreenWidth, collectionViewHeight) collectionViewLayout:layout];
    [CollectionView registerNib:[UINib nibWithNibName:@"RelateDeviceCell" bundle:nil] forCellWithReuseIdentifier:RelateDeviceCellID];
    CollectionView.backgroundColor = [UIColor whiteColor];
    CollectionView.scrollEnabled = YES;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CollectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = CollectionView;
    [self.view addSubview:CollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"关联设备"];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}


#pragma mark - BasicBarViewDelegate
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBingdingDevice
{
    SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelateDeviceCell *cell = (RelateDeviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RelateDeviceCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell setDeviceModel:self.deviceArray[indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SearchPeripheralViewController *search = [[SearchPeripheralViewController alloc] init];
        [self.navigationController pushViewController:search animated:YES];
    }else{
        return;
    }
}

#pragma mark - RelateDeviceCellDelegate

- (void)editDevice:(PeripheralModel *)model withIndePath:(NSIndexPath *)index
{
    _editIndex = index;
    EditDeviceNameController *ctl = [[EditDeviceNameController alloc] initWithDeviceModel:model];
    [self.navigationController pushViewController:ctl animated:YES];
    NSLog(@"编辑第%ld个设备",index.row);
}

- (void)deleteDevice:(PeripheralModel *)model withIndePath:(NSIndexPath *)index
{
    _model = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否删除绑定设备" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
    [alert show];
    NSLog(@"删除第%ld个设备",index.row);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self removeBindDevice];
    }
}

- (void)removeBindDevice
{
    NSDictionary *dictionary = @{
                                 @"userId":[UserInfo share].userId,
                                 @"mac":_model.uuid
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_UNBINGDING_DEVICE
                              urlString:URL_UNBINGDING_DEVICE
                               httpHead:nil
                             bodyString:bodyString
                     objectTaskFinished:^(NSError *error, id obj)
     {
         if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
             [MBProgressHUD showHUDByContent:@"解除绑定成功！" view:UI_Window afterDelay:2];
             [_deviceArray removeObject:_model];
             [self.collectionView reloadData];
             [DBManager deletePeripheral:_model.uuid];
             NSLog(@"解除绑定成功！");
         }else{
             [MBProgressHUD showHUDByContent:@"解除绑定失败！" view:UI_Window afterDelay:2];
         }
         
         
     }];
    
}

- (void)editDeviceName:(NSNotification*)notice
{
    RelateDeviceCell *cell = (RelateDeviceCell *)[_collectionView cellForItemAtIndexPath:_editIndex];
    cell.deviceIDLabel.text = notice.object;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc:RelateDeviceController");
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
