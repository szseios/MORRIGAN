//
//  MusicViewController.m
//  MORRIGAN
//
//  Created by snhuang on 2016/10/7.
//  Copyright © 2016年 mac-jhw. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicModel.h"
#import "MusicManager.h"
#import "MusicTableViewCell.h"
#import "PCSEQVisualizer.h"

@interface MusicViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    PCSEQVisualizer *_pcseView;
    NSTimer *_timer;
    MusicModel *_selectedMusicModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *musicTopBackgoundView;
@property (weak, nonatomic) IBOutlet UIView *musicView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *playingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_slider setThumbImage:[UIImage imageNamed:@"music_adjust_progress"]
                  forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"music_adjust_progress"]
                  forState:UIControlStateHighlighted];
    [_slider addTarget:self action:@selector(sliderValueChanged)
      forControlEvents:UIControlEventValueChanged];
    
    int count;
    if (kScreenHeight == 568) {
        count = 45;
    }
    else if (kScreenHeight == 667) {
        count = 55;
    }
    else if (kScreenHeight == 736) {
        count = 60;
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.view.frame.size.width,
                                                                           60)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    [_musicView addSubview:imageView];
    
    UITapGestureRecognizer *show = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMusicView)];
    [imageView addGestureRecognizer:show];
    
    UITapGestureRecognizer *hidde = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeMusicView)];
    _musicTopBackgoundView.userInteractionEnabled = YES;
    [_musicTopBackgoundView addGestureRecognizer:hidde];
    
    [hidde requireGestureRecognizerToFail:show];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               65,
                                                               kScreenWidth,
                                                               _musicView.frame.size.height - 65)
                                              style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_musicView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell"
                                           bundle:nil]
     forCellReuseIdentifier:@"CELL"];
    
    _pcseView = [[PCSEQVisualizer alloc] initWithNumberOfBars:count];
    _pcseView.userInteractionEnabled = YES;
    CGRect frame = _pcseView.frame;
    frame.origin.x = (kScreenWidth - _pcseView.frame.size.width) / 2;
    frame.origin.y = 160;
    _pcseView.frame = frame;
    [self.view addSubview:_pcseView];
    [self.view bringSubviewToFront:_musicView];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  _pcseView.frame.size.width,
                                                                  _pcseView.frame.size.height / 2)];
    shadowView.backgroundColor = [UIColor colorWithRed:158 / 255.0
                                                 green:95 / 255.0
                                                  blue:247 / 255.0
                                                 alpha:0.2];
    [_pcseView addSubview:shadowView];
    
//    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]
//                            animated:YES
//                      scrollPosition:UITableViewScrollPositionNone];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"
                                                               forIndexPath:indexPath];
    MusicModel *model = [_musics objectAtIndex:indexPath.row];

    NSString *title = [NSString stringWithFormat:@"%@ -%@",model.title,model.artist];
    cell.titleLabel.text = title;
    cell.timeLabel.text = @"time";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = [_musics objectAtIndex:indexPath.row];
    [[MusicManager share] playMusicByURL:model.url];
    _totalTimeLable.text = [model playBackDurationString];
    _selectedMusicModel = model;
    
    [_slider setValue:0.0f animated:YES];
    [self endTiming];
    [self startTiming];
    
    [_pcseView stop];
    [_pcseView start];
}


- (IBAction)startPlayMusic:(id)sender {
    [self startTiming];
}

- (void)startTiming {
    if (_timer) {
        [self endTiming];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(Timing)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}

- (void)endTiming {
    if (!_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)Timing {
    _playingTimeLabel.text = [[MusicManager share] currentTimeString];
    [_slider setValue:[MusicManager share].currentTime / _selectedMusicModel.playbackDuration
             animated:YES];
}

- (void)sliderValueChanged {
    NSTimeInterval interval = _selectedMusicModel.playbackDuration * _slider.value;
    [[MusicManager share] setCurrentTime:interval];
}

#pragma mark - MusicView Move

- (void)showMusicView {
    if ([self musicViewOnBottom]) {
        CGRect frame = _musicView.frame;
        frame.origin.y = kScreenHeight - _musicView.frame.size.height;
        [_musicView setFrame:frame];
    }
    NSLog(@"moveMusicView");
}


- (void)hiddeMusicView {
    if (![self musicViewOnBottom]) {
        CGRect frame = _musicView.frame;
        frame.origin.y = kScreenHeight - 65;
        [_musicView setFrame:frame];
    }
    NSLog(@"hiddeMusicView");
}

//判断是否在底部
- (BOOL)musicViewOnBottom {
    if (_musicView.frame.origin.y == (kScreenHeight - 65)) {
        return YES;
    }
    return NO;
}


@end
