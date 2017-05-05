//
//  SINAnimtion.m
//  SinWaiMai
//
//  Created by apple on 05/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAnimtion.h"

@implementation SINAnimtion

+ (void)sin_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion
{
    [UIView animateWithDuration:duration animations:^{
        animations();
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });
}
@end
