//
//  SINLoadingHUD.m
//  SinWaiMai
//
//  Created by apple on 24/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINLoadingHUD.h"
@implementation SINLoadingHUD

static UIView *_bgView;
static UIImageView *_driverView;
static NSTimer *_timer;
static completionBlock _completion;

+ (instancetype)showHudToView:(UIView *)view completion:(completionBlock)completion
{
    _completion = completion;
    
    SINLoadingHUD *hud = [[SINLoadingHUD alloc] init];
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.frame = [UIScreen mainScreen].bounds;
    [view insertSubview:_bgView aboveSubview:view];
    _bgView.frame = view.bounds;
    
    UIImageView *skyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_ground_130x130_"]];
    skyView.size = CGSizeMake(130, 130);
    skyView.center = _bgView.center;
    [_bgView addSubview:skyView];
    
    UIImageView *treeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_tree_bg_168x54_"]];
    treeView.size = CGSizeMake(110, 54);
    treeView.center = _bgView.center;
    [_bgView addSubview:treeView];
    
    _driverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_bear_1_90x72_"]];
    _driverView.size = CGSizeMake(85, 60);
    _driverView.center = _bgView.center;
    [_bgView addSubview:_driverView];
    
    [self startTimer];
    
    return hud;
}

static int imgIndex = 1;
+ (void)animation
{
    imgIndex++;
    if (imgIndex > 8) {
        imgIndex = 1;
    }
    NSString *imgStr = [NSString stringWithFormat:@"loading_bear_%d_90x72_",imgIndex];
    UIImage *img = [UIImage imageNamed:imgStr];
    _driverView.image = img;
}

+ (void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)hideHud
{
    _bgView.hidden = YES;
    if (_completion) {
        _completion();
    }
}

@end
