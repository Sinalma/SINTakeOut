//
//  UILabel+Category.m
//  SinWaiMai
//
//  Created by apple on 18/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)
/**
 * 快速创建一个label
 */
+ (instancetype)createLabelWithFont:(CGFloat)font textColor:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:font];
    lab.textColor = color;
    return lab;
}

@end
