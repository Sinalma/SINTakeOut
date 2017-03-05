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
    _userInfoes = userInfoes;
    
    // 初始化子控件
    [self setupChildView];
}


- (instancetype)init
{
    if (self == [super init]) {
    }
    return self;
}

/**
 * 初始化子控件
 */
- (void)setupChildView
{
    CGFloat selfH = 100;
    CGFloat selfW = SINScreenW;
    
    NSInteger count = self.userInfoes.count;
    CGFloat margin = 10;
    
    // 分割线宽度
    CGFloat lineW = 0.5;
    
    CGFloat itemW = selfW / count;
    NSLog(@"item - %f",itemW);
    for (int i = 0; i < count; i++) {
    
        SINUserInfo *userInfo = self.userInfoes[i];
        
        UILabel *amoutLab = [UILabel createLabelWithFont:13 textColor:[UIColor redColor]];
        NSString *amoutStr = [NSString stringWithFormat:@"%@%@",userInfo.amount,userInfo.unit];
        if ([userInfo.amount isEqualToString:@"0"]) {
            amoutStr = @"-";
        }
        amoutLab.text = amoutStr;
        
        if (amoutLab.text.length == 0) {
            amoutLab.text = @"_";
        }
        amoutLab.textAlignment = NSTextAlignmentCenter;
        amoutLab.size = CGSizeMake(selfW - 2 * margin, 20);
        amoutLab.x = itemW * 0.5 - amoutLab.width * 0.5 + (i * itemW);
        amoutLab.y = selfH * 0.5 - amoutLab.height * 0.5;
        [self addSubview:amoutLab];
        
        UILabel *nameLab = [UILabel createLabelWithFont:13 textColor:[UIColor darkGrayColor]];
        nameLab.text = userInfo.name;
        if (nameLab.text.length == 0) {
            nameLab.text = @"带警犬";
        }
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.frame = CGRectMake(amoutLab.x, CGRectGetMaxY(amoutLab.frame) + 10, amoutLab.width, amoutLab.height);
        [self addSubview:nameLab];
        
        if (i != count-1) {
        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor darkGrayColor];
        lineView.x = itemW - lineW * 0.5 + (itemW * i);
        lineView.y = CGRectGetMaxY(amoutLab.frame);
        lineView.height = CGRectGetMaxY(nameLab.frame) - CGRectGetMaxY(amoutLab.frame);
        lineView.width = lineW;
        [self addSubview:lineView];
            
        }else
        {
            // 底部分割线
            UIView *bLineV = [[UIView alloc] init];
            bLineV.backgroundColor = [UIColor grayColor];
            bLineV.alpha = 0.5;
            bLineV.width = SINScreenW;
            bLineV.height = 0.5;
            bLineV.x = 0;
            bLineV.y = CGRectGetMaxY(nameLab.frame) + 10;
            [self addSubview:bLineV];
            
            // 分隔条
            UIView *bLin = [[UIView alloc] init];
            bLin.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
            bLin.width = SINScreenW;
            bLin.height = margin;
            bLin.x = 0;
            bLin.y = CGRectGetMaxY(bLineV.frame);
            [self addSubview:bLin];
            
            self.height = CGRectGetMaxY(bLin.frame) + margin;
            NSLog(@"height->%f",self.height);
        }
    }
}

@end
