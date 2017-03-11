//
//  SINHUD.m
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINHUD.h"

@interface SINHUD ()

//
//@property (nonatomic,strong) SINHUD *hud;

@end

@implementation SINHUD

static SINHUD *_hud;

+ (instancetype)showHudAddTo:(UIView *)view
{
    SINHUD *hud = [SINHUD sharedHUD];
    hud.backgroundColor = [UIColor whiteColor];
    hud.alpha = 1.0;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.frame = view.bounds;
    [view addSubview:hud];
    [hud showAnimated:YES];
    
    return hud;
}

+ (instancetype)sharedHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _hud = [[self alloc] init];
    });
    return _hud;
}

- (void)hide
{
    [[SINHUD sharedHUD] hideAnimated:YES];
}


@end
