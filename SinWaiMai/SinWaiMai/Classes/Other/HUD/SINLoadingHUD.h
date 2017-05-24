//
//  SINLoadingHUD.h
//  SinWaiMai
//
//  Created by apple on 24/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^completionBlock)(void);

@interface SINLoadingHUD : NSObject
//@property (nonatomic,strong) completionBlock completion;
+ (instancetype)showHudToView:(UIView *)view completion:(completionBlock)completion;
- (void)hideHud;
@end
