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
#import "Utils.h"

@interface MusicViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MusicManagerDelegate> {
    PCSEQVisualizer *_pcseView;
    NSTimer *_timer;
    NSIndexPath *_selectedIndexPath;
}
@property (weak, nonatomic) IBOutlet UIImageView *musicTopBackgoundView;
@property (weak, nonatomic) IBOutlet UIView *musicView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *playingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *closeButton;

@end

@implementation MusicViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _musics = [NSMutableArray arrayWithArray:[MusicManager share].musics];
        [MusicManager share].delegate = self;
    }
    return self;
}

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
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMusicView:)];
    [_musicView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *show = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMusicView)];
    [imageView addGestureRecognizer:show];
    
    UITapGestureRecognizer *hidde = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeMusicView)];
    _musicTopBackgoundView.userInteractionEnabled = YES;
    [_musicTopBackgoundView addGestureRecognizer:hidde];
    
    [hidde requireGestureRecognizerToFail:show];
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              _musicView.height - 54,
                                                              kScreenWidth,
                                                              54)];
    [_closeButton setTitle:@"关闭"
                  forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor colorWithRed:0 / 255.0
                                                green:0 / 255.0
                                                 blue:0 / 255.0
                                                alpha:0.7]
                       forState:UIControlStateNormal];
    _closeButton.backgroundColor = [UIColor colorWithRed:232 / 255.0
                                                   green:223 / 255.0
                                                    blue:250 / 255.0
                                                   alpha:1];
    [_closeButton addTarget:self action:@selector(hiddeMusicView)
           forControlEvents:UIControlEventTouchUpInside];
    [_musicView addSubview:_closeButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               63,
                                                               kScreenWidth,
                                                               _musicView.frame.size.height - 63 - _closeButton.height)
                                              style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         _tableView.width,
                                                                         _tableView.height)];
    _tableView.backgroundView.backgroundColor = [UIColor colorWithRed:232 / 255.0
                                                                green:223 / 255.0
                                                                 blue:250 / 255.0
                                                                alpha:1];
    
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
    
    UITapGestureRecognizer *hiddenTableView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeMusicView)];
    [_pcseView addGestureRecognizer:hiddenTableView];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  _pcseView.frame.size.width,
                                                                  _pcseView.frame.size.height / 2)];
    shadowView.backgroundColor = [UIColor colorWithRed:158 / 255.0
                                                 green:95 / 255.0
                                                  blue:247 / 255.0
                                                 alpha:0.2];
    [_pcseView addSubview:shadowView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"
                                                               forIndexPath:indexPath];
    MusicModel *model = [_musics objectAtIndex:indexPath.row];

    [cell stopAnimation];
    cell.title = model.title;
    cell.artist = model.artist;
    cell.time = [model playBackDurationString];
    
    if (_selectedIndexPath &&
        indexPath.row == _selectedIndexPath.row &&
        [MusicManager share].isPlaying) {
        [cell startAnimation];
        [cell selectedStatus];
    }
    else if (_selectedIndexPath &&
             indexPath.row == _selectedIndexPath.row &&
             ![MusicManager share].isPlaying) {
        [cell resetBars];
        [cell selectedStatus];
    }
    else {
        [cell unselectStatus];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    [self playMusicByIndexPath:indexPath];
}


- (IBAction)startPlayMusic:(id)sender {
    if (!_selectedIndexPath) {
        return;
    }
    if ([[MusicManager share] isPlaying]) {
        [[MusicManager share] pause];
        [_pcseView stop];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_play"]
                                forState:UIControlStateNormal];
    } else {
        [[MusicManager share] play];
        [self startTiming];
        [_pcseView start];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                                forState:UIControlStateNormal];
    }
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
    MusicModel *model = [_musics objectAtIndex:_selectedIndexPath.row];
    [_slider setValue:[MusicManager share].currentTime / model.playbackDuration
             animated:YES];
}

- (void)sliderValueChanged {
    MusicModel *model = [_musics objectAtIndex:_selectedIndexPath.row];
    NSTimeInterval interval = model.playbackDuration * _slider.value;
    [[MusicManager share] setCurrentTime:interval];
}
- (IBAction)previousMusic:(id)sender {
    if (_selectedIndexPath.row - 1 >= 0) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndexPath.row - 1
                                                inSection:0];
        [self playMusicByIndexPath:_selectedIndexPath];
    }
}

- (IBAction)nextMusic:(id)sender {
    if (_selectedIndexPath.row + 1 < _musics.count) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndexPath.row + 1
                                                inSection:0];
        
        [self playMusicByIndexPath:_selectedIndexPath];
    }
}

- (void)playMusicByIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = [_musics objectAtIndex:indexPath.row];
    [[MusicManager share] playMusicByURL:model.url];
    _musicNameLabel.text = model.title;
    _singerLabel.text = model.artist;
    _totalTimeLable.text = [model playBackDurationString];
    
    [_slider setValue:0.0f animated:YES];
    
    NSArray *cells = [_tableView visibleCells];
    for (MusicTableViewCell *cell in cells) {
        [cell stopAnimation];
        [cell unselectStatus];
    }
    MusicTableViewCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell startAnimation];
    [cell selectedStatus];
    
    [self endTiming];
    [self startTiming];
    
    [_pcseView stop];
    [_pcseView start];
}

//音乐播放完成,自动播放下一首音乐
- (void)audioPlayerDidFinish {
    if (_selectedIndexPath.row + 1 < _musics.count) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndexPath.row + 1
                                                inSection:0];
        
        [self playMusicByIndexPath:_selectedIndexPath];
    }
}

- (void)dragMusicView:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    NSLog(@"%f",location.y);
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        _musicView.y = location.y;
    }
}

#pragma mark - MusicView Move

- (void)showMusicView {
    if ([self musicViewOnBottom]) {
        CGRect frame = _musicView.frame;
        frame.origin.y = kScreenHeight - _musicView.frame.size.height;
        [_musicView setFrame:frame];
        [_tableView reloadData];
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否在底部
- (BOOL)musicViewOnBottom {
    if (_musicView.frame.origin.y == (kScreenHeight - 65)) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [MusicManager share].delegate = nil;
}


@end
