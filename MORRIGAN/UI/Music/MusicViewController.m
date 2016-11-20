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
#import "SearchPeripheralViewController.h"

@interface MusicViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MusicManagerDelegate> {
    PCSEQVisualizer *_pcseView;
    NSTimer *_timer;
    NSIndexPath *_selectedIndexPath;
    CGFloat _beganY;
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
@property (weak, nonatomic) IBOutlet UIImageView *panGestureView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

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
        _selectedIndexPath = [NSIndexPath indexPathForRow:[MusicManager share].currentSelectedIndex
                                                inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [_previousButton setBackgroundImage:[UIImage imageNamed:@"music_previous"]
                               forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"music_next"]
                           forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_play"]
                            forState:UIControlStateNormal];
    
    [_previousButton setBackgroundImage:[UIImage imageNamed:@"music_previous_selected"]
                               forState:UIControlStateHighlighted];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"music_next_selected"]
                               forState:UIControlStateHighlighted];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_play_selected"]
                               forState:UIControlStateHighlighted];
    
    [_slider setThumbImage:[UIImage imageNamed:@"music_adjust_progress"]
                  forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"music_adjust_progress"]
                  forState:UIControlStateHighlighted];
    [_slider addTarget:self action:@selector(sliderValueChanged)
      forControlEvents:UIControlEventValueChanged];
    
    _slider.tintColor = [Utils stringTOColor:@"#ff70dc"];
    
    int count;
    if (kScreenHeight == 568) {
        count = 50;
    }
    else if (kScreenHeight == 667) {
        count = 60;
    }
    else if (kScreenHeight == 736) {
        count = 65;
    }
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMusicView:)];
    _panGestureView.userInteractionEnabled = YES;
    [_panGestureView addGestureRecognizer:panGestureRecognizer];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               _panGestureView.height - 4.5,
                                                               _panGestureView.width,
                                                               0.5)];
    topLine.backgroundColor = [UIColor colorWithRed:186 / 255.0
                                              green:140 / 255.0
                                               blue:244 / 255.0
                                              alpha:1];
    [_panGestureView addSubview:topLine];
    
    UITapGestureRecognizer *show = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMusicView)];
    [_panGestureView addGestureRecognizer:show];
    
    UITapGestureRecognizer *hidde = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeMusicView)];
    _musicTopBackgoundView.userInteractionEnabled = YES;
    [_musicTopBackgoundView addGestureRecognizer:hidde];
    
    [hidde requireGestureRecognizerToFail:show];
    [panGestureRecognizer requireGestureRecognizerToFail:show];
    
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
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  _closeButton.width,
                                                                  0.5)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 / 255.0
                                                 green:0 / 255.0
                                                  blue:0 / 255.0
                                                 alpha:0.1];
    [_closeButton addSubview:bottomLine];
    
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
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
//    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                  0,
//                                                                  _pcseView.frame.size.width,
//                                                                  _pcseView.frame.size.height / 2)];
//    shadowView.backgroundColor = [Utils stringTOColor:@"#8c39e5"];
//    [_pcseView addSubview:shadowView];
    
    
    MusicModel *model = [_musics objectAtIndex:_selectedIndexPath.row];
    if (model) {
        _musicNameLabel.text = model.title;
        _singerLabel.text = model.artist;
        _totalTimeLable.text = [model playBackDurationString];
    }
    
    if (self.connectBottomView) {
        [self.view bringSubviewToFront:self.connectBottomView];
    }
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
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateHighlighted];
    [MusicManager share].currentSelectedIndex = _selectedIndexPath.row;
}


- (IBAction)startPlayMusic:(id)sender {
    if (!_selectedIndexPath) {
        return;
    }
    if (![[MusicManager share] prepareToPlay]) {
        [self playMusicByIndexPath:_selectedIndexPath];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                                forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                                forState:UIControlStateHighlighted];
    }
    else if ([[MusicManager share] isPlaying]) {
        [[MusicManager share] pause];
        [_pcseView stop];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_play"]
                                forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_play_selected"]
                                forState:UIControlStateHighlighted];
    } else {
        [[MusicManager share] play];
        [self startTiming];
        [_pcseView start];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                                forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                                forState:UIControlStateHighlighted];
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
    if (_timer.isValid) {
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
    }
    else {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_musics.count - 1
                                                inSection:0];
    }
    [self playMusicByIndexPath:_selectedIndexPath];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateHighlighted];
    [MusicManager share].currentSelectedIndex = _selectedIndexPath.row;
}

- (IBAction)nextMusic:(id)sender {
    if (_selectedIndexPath.row + 1 < _musics.count) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndexPath.row + 1
                                                inSection:0];
        
    }
    else {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                inSection:0];
    }
    [self playMusicByIndexPath:_selectedIndexPath];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"music_stop"]
                            forState:UIControlStateHighlighted];
    [MusicManager share].currentSelectedIndex = _selectedIndexPath.row;
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


#pragma mark - MusicManager Delegate

//音乐播放完成,自动播放下一首音乐
- (void)audioPlayerDidFinish {
    if (_selectedIndexPath.row + 1 < _musics.count) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndexPath.row + 1
                                                inSection:0];
        
        [self playMusicByIndexPath:_selectedIndexPath];
    }
    else {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                inSection:0];
        [self playMusicByIndexPath:_selectedIndexPath];
    }
    [MusicManager share].currentSelectedIndex = _selectedIndexPath.row;
}


#pragma mark - MusicView Move

- (void)dragMusicView:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    NSLog(@"%f",location.y);
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (location.y >= kScreenHeight - _musicView.frame.size.height &&
            location.y <= kScreenHeight - 65) {
            _musicView.y = location.y;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beganY = location.y;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (location.y > _beganY) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = _musicView.frame;
                frame.origin.y = kScreenHeight - 65;
                [_musicView setFrame:frame];
                
            }];
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = _musicView.frame;
                frame.origin.y = kScreenHeight - _musicView.frame.size.height;
                [_musicView setFrame:frame];
                
            }];
        }
    }
}

- (void)showMusicView {
    if ([self musicViewOnBottom]) {
        [_tableView reloadData];
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = _musicView.frame;
            frame.origin.y = kScreenHeight - _musicView.frame.size.height;
            [_musicView setFrame:frame];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    NSLog(@"moveMusicView");
}


- (void)hiddeMusicView {
    if (![self musicViewOnBottom]) {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = _musicView.frame;
            frame.origin.y = kScreenHeight - 65;
            [_musicView setFrame:frame];
            
        }];
    }
    NSLog(@"hiddeMusicView");
}

- (IBAction)back:(id)sender {
    [self endTiming];
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否在底部
- (BOOL)musicViewOnBottom {
    if (_musicView.frame.origin.y == (kScreenHeight - 65)) {
        return YES;
    }
    return NO;
}

- (IBAction)connectPeripheral:(id)sender {
    SearchPeripheralViewController *ctl = [[SearchPeripheralViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)dealloc
{
    [MusicManager share].delegate = nil;
    [[MusicManager share] stop];
}


@end
