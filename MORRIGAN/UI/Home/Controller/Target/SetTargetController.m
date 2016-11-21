//
//  SetTargetController.m
//  MOLIPageDemo
//
//  Created by azz on 16/10/9.
//  Copyright © 2016年 azz. All rights reserved.
//

#import "SetTargetController.h"
#import "ZHRulerView.h"

@interface SetTargetController ()<BasicBarViewDelegate,ZHRulerViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *achieveButton;

@property (nonatomic , strong) BasicBarView *barView;

@property (nonatomic , strong) ZHRulerView *rulerView;

@property (nonatomic , strong) UIScrollView *rulerScrollView;

@end

@implementation SetTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backImageView.image = [UIImage imageWithColor:[Utils stringTOColor:@"#8c39e5"]];
    [self.view addSubview:backImageView];
    // Do any additional setup after loading the view from its nib.
    _achieveButton.clipsToBounds = YES;
    _achieveButton.layer.cornerRadius = 5;
    _achieveButton.backgroundColor = [Utils stringTOColor:@"#8c39e5"];
    [_achieveButton addTarget:self action:@selector(clickEnsure) forControlEvents:UIControlEventTouchUpInside];
    _countLabel.text = [UserInfo share].target ? [UserInfo share].target : @"60";
    
    [self setUpBarView];
    
    [self setUpRulerView];
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
        [self.view bringSubviewToFront:_achieveButton];
    }
}

- (void)setUpBarView
{
    _barView = [[BasicBarView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44) withType:superBarTypeLeftItemBackAndRightItemBinding withTitle:@"设定目标" isShowRightButton:NO];
    [self.view addSubview:_barView];
    _barView.delegate = self;
}

- (void)targetAchieve
{
    NSDictionary *dictionary = @{@"userId": [UserInfo share].userId ? [UserInfo share].userId : @"",
                                 @"target": [UserInfo share].target ? [UserInfo share].target : @"",
                                 };
    NSString *bodyString = [NMOANetWorking handleHTTPBodyParams:dictionary];
    [[NMOANetWorking share] taskWithTag:ID_EDIT_USERINFO urlString:URL_EDIT_USERINFO httpHead:nil bodyString:bodyString objectTaskFinished:^(NSError *error, id obj) {
        
        if ([[obj objectForKey:HTTP_KEY_RESULTCODE] isEqualToString:HTTP_RESULTCODE_SUCCESS]) {
            [MBProgressHUD showHUDByContent:@"修改目标成功！" view:UI_Window afterDelay:2];
            NSLog(@"修改目标成功！");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showHUDByContent:@"修改目标失败！" view:UI_Window afterDelay:2];
        }
    }];
}

- (void)setUpRulerView
{
    CGFloat rulerX = 0;
    CGFloat tempY = kScreenHeight > 480 ? 20 : 10;
    CGFloat rulerY = 235 + tempY;
    CGFloat rulerWidth = kScreenWidth;
    CGFloat rulerHeight = 235;
//
    CGRect rulerFrame = CGRectMake(rulerX, rulerY, rulerWidth, rulerHeight);
    
//    ZHRulerView *rulerView = [[ZHRulerView alloc] initWithMixNuber:5 maxNuber:180 showType:rulerViewshowHorizontalType rulerMultiple:10];
//    _rulerView = rulerView;
//    rulerView.round = YES;
//    rulerView.defaultVaule = [UserInfo share].target ? [[UserInfo share].target integerValue] : 60;
//    rulerView.delegate = self;
//    rulerView.frame = rulerFrame;
//    
//    [self.view addSubview:rulerView];
    _rulerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(rulerX, rulerY, rulerWidth, rulerHeight)];
    _rulerScrollView.delegate = self;
    _rulerScrollView.backgroundColor = [UIColor clearColor];
    _rulerScrollView.contentSize = CGSizeMake(180*15, rulerHeight);
    _rulerScrollView.showsHorizontalScrollIndicator = NO;
    _rulerScrollView.contentInset = UIEdgeInsetsMake(0, kScreenWidth/2, 0, kScreenWidth/2);
    
    [self.view addSubview:_rulerScrollView];
    CGFloat viewW = 1;
    CGFloat viewH = 30;
    CGFloat viewH1 = 40;
    CGFloat viewX = 16;
    CGFloat viewY = 20;
    CGFloat viewY1 = 30;
    
    for (NSInteger i = 0; i <= 180; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX * i, i%5 == 0 ? viewY : viewY1, viewW, i%5 == 0 ?viewH1 : viewH)];
        view.alpha = 0.4;
        view.backgroundColor = [UIColor blackColor];
        if (i %5 == 0) {
            view.backgroundColor = [UIColor blackColor];
            if (i % 10 == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.x-20, view.y + view.height + 20, 40, 25)];
                label.text = [NSString stringWithFormat:@"%ld",i];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor blackColor];
                [_rulerScrollView addSubview:label];
                
            }
        }
        [_rulerScrollView addSubview:view];
        
    }
    //添加指针view
    UIView *pointerView=[[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 0.8, rulerY + viewY, 1.6, 40)];
    pointerView.backgroundColor=[UIColor purpleColor];
    pointerView.alpha = 0.7;
    [self.view addSubview:pointerView];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 3, rulerY + viewY + 43, 6, 4)];
    arrowImageView.image = [UIImage imageNamed:@"arrowUp"];
    [self.view addSubview:arrowImageView];
    
    
}

#pragma mark - BasicBarViewDelegate

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEnsure
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TARGETCHANGENOTIFICATION object:nil];
    [self targetAchieve];
}

#pragma mark - ZHRulerViewDelegate

-(void)getRulerValue:(CGFloat)rulerValue withScrollRulerView:(ZHRulerView *)rulerView
{
    _countLabel.text = [NSString stringWithFormat:@"%.0lf",rulerValue];
    [UserInfo share].target = _countLabel.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self scrollViewWillEndDragging:scrollView withVelocity:CGPointZero targetContentOffset:scrollView.contentOffset];
   
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

    CGPoint orifinalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    CGFloat offSetX = (orifinalTargetContentOffset.x + kScreenWidth /2) * 100;
    NSInteger count = (NSInteger)offSetX % 1400 ;
    if (count > 700) {
        offSetX += 1400 - count;
    }else{
        offSetX -= count;
    }
    NSInteger number = (NSInteger)offSetX / 1400;
    _countLabel.text = [NSString stringWithFormat:@"%.0ld",number];
    scrollView.contentOffset = CGPointMake((number * 1400 - kScreenWidth /2 * 100) / 100.0, scrollView.contentOffset.y);
    NSLog(@"scrollViewWillEndDragging:%lf",orifinalTargetContentOffset.x);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    CGFloat offSetX = scrollView.contentOffset.x + kScreenWidth /2;
//    NSInteger count = (NSInteger)offSetX / 15.25 ;
//    _countLabel.text = [NSString stringWithFormat:@"%.0ld",count];
//    scrollView.contentOffset = CGPointMake(count * 15.25, scrollView.contentOffset.y);
     NSLog(@"scrollViewDidEndDecelerating:%lf",scrollView.contentOffset.x);
}



- (void)dealloc
{
    NSLog(@"dealloc:SetTargetController");
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
