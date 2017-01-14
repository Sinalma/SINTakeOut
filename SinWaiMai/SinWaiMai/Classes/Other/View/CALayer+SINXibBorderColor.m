//
//  CALayer+SINXibBorderColor.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "CALayer+SINXibBorderColor.h"
#import <QuartzCore/QuartzCore.h>
@implementation CALayer (SINXibBorderColor)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}

@end
