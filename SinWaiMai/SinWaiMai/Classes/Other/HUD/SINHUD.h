//
//  SINHUD.h
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface SINHUD : MBProgressHUD
+ (instancetype)showHudAddTo:(UIView *)view;

- (void)hide;

@end
