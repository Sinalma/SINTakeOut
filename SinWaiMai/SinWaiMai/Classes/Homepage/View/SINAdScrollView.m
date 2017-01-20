//
//  SINAdScrollView.m
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAdScrollView.h"

#import "UIImageView+SINWebCache.h"

@implementation SINAdScrollView

- (void)setAdImgArr:(NSArray *)adImgArr
{
    _adImgArr = adImgArr;
    
    [self setup];
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setup
{
    NSInteger adImgCount = self.adImgArr.count;
    
    // 添加子控件
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    for (int i = 0; i < adImgCount; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        x = i * w;
        
        imageV.frame = CGRectMake(x, y, w, h);
        
        [imageV sin_setImageWithURL:[NSURL URLWithString:self.adImgArr[i]]];
        
        [self addSubview:imageV];
    }
    
    // 设置内容尺寸
    self.contentSize = CGSizeMake(SINScreenW * adImgCount, HomepageAdHeight);
}

@end
