//
//  UIImageView+SINWebCache.h
//  SinWaiMai
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  下载网络图片，对SDWebImage框架的UIImageView-WebCache的一层封装

#import <UIKit/UIKit.h>

@interface UIImageView (SINWebCache)

- (void)sin_setImageWithURL:(NSURL *)url;

- (void)sin_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image;
@end
