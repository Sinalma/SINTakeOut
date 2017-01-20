//
//  UIButton+SINWebCache.m
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "UIButton+SINWebCache.h"

#import "UIButton+WebCache.h"

@implementation UIButton (SINWebCache)

- (void)sin_setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self sd_setImageWithURL:url forState:state];
    
}

- (void)sin_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url forState:state placeholderImage:image];
}

@end
