//
//  SINProgressHUD.m
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINProgressHUD.h"

#import "MBProgressHUD.h"

@interface SINProgressHUD ()

@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation SINProgressHUD

static MBProgressHUD *_hud;
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.frame = view.bounds;
    hud.backgroundColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud showAnimated:YES];
    _hud = hud;
    return hud;
}

- (void)hideHUD
{
    [_hud hideAnimated:YES];
}
@end
