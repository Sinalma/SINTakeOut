//
//  SINNormalButton.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  这个自定义按钮，图片在上标题在下

#import "SINNormalButton.h"

// 图片占整体的比例
#define NormalBtnRatio 0.8
// 间距
#define imgMargin 5

@implementation SINNormalButton

- (instancetype)init
{
    if (self = [super init]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0,self.height * NormalBtnRatio,self.width,self.height * (1 - NormalBtnRatio));
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.width * NormalBtnRatio - imgMargin * 2;
    CGFloat h = w;
    CGFloat x = (self.width - w) / 2;
    return CGRectMake(x, imgMargin, w, h);
}

@end
