//
//  SINAnimtion.h
//  SinWaiMai
//
//  Created by apple on 05/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SINAnimtion : UIView

+ (void)sin_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion;

@end
