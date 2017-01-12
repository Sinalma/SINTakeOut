//
//  UIView+Category.h
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  用点语法实现改控件的单个尺寸和单个位置坐标

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) CGPoint origin;



@end
