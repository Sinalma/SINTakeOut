//
//  UIColor+Category.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  这个类用于开发时测试->获取随机色

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (CGFloat)number
{
    return arc4random_uniform(256);
}

/**
 * 获取随机颜色
 */
+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:[UIColor number]/255.0 green:[UIColor number]/255.0 blue:[UIColor number]/255.0 alpha:1.0];
}




@end
