//
//  SINUserInfoView.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINUserInfoView.h"
#import "UILabel+Category.h"
#import "SINUserInfo.h"

@implementation SINUserInfoView

- (void)setUserInfoes:(NSArray *)userInfoes
{
    // 初始化子控件
    [self setupChildView];
}

- (instancetype)init
{
    if (self == [super init]) {
        [self setupChildView];
    }
    return nil;
}

/**
 * 初始化子控件
 */
- (void)setupChildView
{
    NSInteger count = self.userInfoes.count;
    
    CGFloat margin = 10;
    
    // 分割线宽度
    CGFloat lineW = 1;
    
    CGFloat itemW = SINScreenW / count;
    
    for (int i = 0; i < count; i++) {
    
        SINUserInfo *userInfo = self.userInfoes[i];
        
        UILabel *amoutLab = [UILabel createLabelWithFont:13 textColor:[UIColor redColor]];
        amoutLab.text = [NSString stringWithFormat:@"%@%@",userInfo.amount,userInfo.unit];
        if (amoutLab.text.length == 0) {
            amoutLab.text = @"_";
        }
        amoutLab.textAlignment = NSTextAlignmentCenter;
        amoutLab.centerX = itemW / 2;
        amoutLab.centerY = self.height / 2;
        amoutLab.size = CGSizeMake(self.width - 2 * margin, 20);
        [self addSubview:amoutLab];
        
        UILabel *nameLab = [UILabel createLabelWithFont:13 textColor:[UIColor darkGrayColor]];
        nameLab.text = userInfo.name;
        if (nameLab.text.length == 0) {
            nameLab.text = @"带警犬";
        }
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.frame = CGRectMake(amoutLab.x, CGRectGetMaxY(amoutLab.frame) + 10, amoutLab.width, amoutLab.height);
        [self addSubview:nameLab];
        
        if (i == count) {
            return;
        }
        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor darkGrayColor];
        lineView.x = itemW - lineW * 0.5;
        lineView.y = CGRectGetMaxY(amoutLab.frame);
        lineView.height = CGRectGetMaxY(nameLab.frame) - CGRectGetMaxY(nameLab.frame);
        lineView.width = lineW;
        [self addSubview:lineView];
    }
}

@end
