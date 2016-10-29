//
//  RelateDeviceController.m
//  MORRIGAN
//
//  Created by azz on 2016/10/23.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "RelateDeviceController.h"
#import "RelateDeviceCell.h"

#define RelateDeviceCellID @"RelateDeviceCellID"

@interface RelateDeviceController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BasicBarViewDelegate,RelateDeviceCellDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) NSMutableArray *deviceArray;

@end

@implementation RelateDeviceController

- (NSMutableArray *)deviceArray
{
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            relateDeviceModel *model = [[relateDeviceModel alloc] init];
            [_deviceArray addObject:model];
        }
    }
     return _deviceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageNamed:@"basicBackground"];
    [self.view addSubview:backImageView];
    [self setUpBarView];
    
    [self setUpCollectionView];
    
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
    NSLog(@"绑定设备");
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deviceArray.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelateDeviceCell *cell = (RelateDeviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RelateDeviceCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell setDeviceModel:self.deviceArray[indexPath.row] withIndexPath:indexPath];
    return cell;
}

#pragma mark - RelateDeviceCellDelegate

- (void)editDevice:(relateDeviceModel *)model withIndePath:(NSIndexPath *)index
{
    NSLog(@"编辑第%ld个设备",index.row);
}

- (void)deleteDevice:(relateDeviceModel *)model withIndePath:(NSIndexPath *)index
{
    NSLog(@"删除第%ld个设备",index.row);
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
