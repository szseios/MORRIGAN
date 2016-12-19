//
//  HNHHEQVisualizer.m
//  HNHH
//
//  Created by Dobango on 9/17/13.
//  Copyright (c) 2013 RC. All rights reserved.
//

#import "PCSEQVisualizer.h"
#import "UIImage+Color.h"

#define kWidth 4
#define kHeight 200
#define kPadding 1


@implementation PCSEQVisualizer
{
    NSTimer* timer;
    NSArray* barArray;
    NSArray* topArray;
}
- (id)initWithNumberOfBars:(int)numberOfBars
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(kWidth*numberOfBars), kHeight);
        
        NSMutableArray* tempBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        NSMutableArray* tempTopBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        
        for(int i = 0; i < numberOfBars; i++){
            
            UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth+i*kPadding, 0, kWidth, 1)];
            bar.userInteractionEnabled = YES;
            bar.image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:1]];
            [self addSubview:bar];
            [tempBarArray addObject:bar];
            
            
            UIImageView* topBar = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth+i*kPadding, 0, kWidth, 1)];
            topBar.userInteractionEnabled = YES;
            topBar.image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.15]];
            [self addSubview:topBar];
            [tempTopBarArray addObject:topBar];
            
        }

        barArray = [[NSArray alloc]initWithArray:tempBarArray];
        topArray = [[NSArray alloc]initWithArray:tempTopBarArray];
        
        [self initAnimationViews];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopTimer" object:nil];
  
    }
    return self;
}


-(void)start{
    
    self.hidden = NO;
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(ticker) userInfo:nil repeats:YES];
    }
    
}


-(void)stop{
    
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)initAnimationViews {
    
    for (NSInteger i = 0; i < barArray.count; i++) {
        UIImageView *bar = [barArray objectAtIndex:i];
        UIImageView *topBar = [topArray objectAtIndex:i];
        
        CGRect rect = bar.frame;
        rect.size.height = arc4random() % (kHeight / 2 - 25) + 25;
        rect.origin.y = self.height / 2 - rect.size.height;
        bar.frame = rect;
        rect.origin.y = self.frame.size.height / 2;
        topBar.frame = rect;
    }
    
}

-(void)ticker{

    [UIView animateWithDuration:.2 animations:^{
        for (NSInteger i = 0; i < barArray.count; i++) {
            UIImageView *bar = [barArray objectAtIndex:i];
            UIImageView *topBar = [topArray objectAtIndex:i];
            
            CGRect rect = bar.frame;
            rect.size.height = arc4random() % (kHeight / 2 - 25) + 25;
            rect.origin.y = self.height / 2 - rect.size.height;
            bar.frame = rect;
            rect.origin.y = self.frame.size.height / 2;
            topBar.frame = rect;
        }
    
    }];
}

@end
