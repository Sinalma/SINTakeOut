//
//  UIImageView+SINWebCache.m
//  SinWaiMai
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "UIImageView+SINWebCache.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (SINWebCache)

/**
 * 下载网络图片，对SDWebImage框架的UIImageView-WebCache的一层封装
 */
- (void)sin_setImageWithURL:(NSURL *)url
{
    [self sd_setImageWithURL:url];
}

/**
 * 下载网络图片，对SDWebImage框架的UIImageView-WebCache的一层封装
 */
- (void)sin_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image];
}
@end
