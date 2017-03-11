//
//  SINProgressHUD.h
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface SINProgressHUD : UIView
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
- (void)hideHUD;
@end
