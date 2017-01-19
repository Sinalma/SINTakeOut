//
//  SINAdScrollView.m
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAdScrollView.h"

@implementation SINAdScrollView

- (instancetype)init
{
    if (self = [super init]) {
        
        // 初始化设置
//        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setup];
}
- (void)setup
{
    // 添加子控件
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    for (int i = 0; i < self.adImgCount; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        x = i * w;
        
        imageV.frame = CGRectMake(x, y, w, h);
        
//        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d",i + 1]];
        imageV.image = [UIImage imageNamed:self.adImgArr[i]];
        
        [self addSubview:imageV];
    }
}

@end
