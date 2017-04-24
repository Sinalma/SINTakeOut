//
//  UIImage+SINHelper.h
//  QRCode
//
//  Created by apple on 23/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SINHelper)

/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
