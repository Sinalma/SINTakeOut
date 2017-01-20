//
//  UIButton+SINWebCache.h
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SINWebCache)


- (void)sin_setImageWithURL:(NSURL *)url forState:(UIControlState )state;

- (void)sin_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)image;
@end
