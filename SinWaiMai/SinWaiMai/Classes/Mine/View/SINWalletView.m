//
//  SINWalletView.m
//  SinWaiMai
//
//  Created by apple on 03/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWalletView.h"
#import "UILabel+Category.h"
#import "UIImageView+SINWebCache.h"
#import "SINWalletTitle.h"
#import "SINWalletItem.h"
#import "SINWallet.h"

@implementation SINWalletView

- (void)setWallet:(SINWallet *)wallet
{
    _wallet = wallet;
    
    [self setup];
    
    
}

- (void)setup
{
    CGFloat selfW = SINScreenW;
    CGFloat margin = 10;
    CGFloat imgWH = 20;
    CGFloat lineW = 0.5;
    
    // 顶部分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.alpha = 0.5;
    topLine.backgroundColor = [UIColor darkGrayColor];
    topLine.frame = CGRectMake(0, 0, selfW, 0.5);
    [self addSubview:topLine];
    
    // 顶部百度钱包log
    UIImageView *bDLogV = [[UIImageView alloc] init];
    [bDLogV sin_setImageWithURL:[NSURL URLWithString:self.wallet.title.title_icon]];
    bDLogV.frame = CGRectMake(margin, margin, imgWH, imgWH);
    [self addSubview:bDLogV];
    
    // 百度钱包文字lab
    UILabel *bDLab = [UILabel createLabelWithFont:14 textColor:[UIColor darkGrayColor]];
    bDLab.text = self.wallet.title.title_name;
    bDLab.x = CGRectGetMaxY(bDLogV.frame);
    bDLab.y = bDLogV.y + 2;
    [bDLab sizeToFit];
    [self addSubview:bDLab];
    
    // 最右侧箭头
    UILabel *arrowLab = [UILabel createLabelWithFont:15 textColor:[UIColor darkGrayColor]];
    arrowLab.text = @">";
    arrowLab.x = selfW - imgWH - margin;
    arrowLab.y = margin;
    [arrowLab sizeToFit];
    [self addSubview:arrowLab];
    
    // 官方推荐支付方式lab
    UILabel *recLab = [UILabel createLabelWithFont:12 textColor:[UIColor redColor]];
    recLab.textAlignment = NSTextAlignmentRight;
    recLab.text = self.wallet.title.discount_msg;
    CGFloat recLabW = [recLab.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
    recLab.width = recLabW;
    recLab.x = selfW - margin - imgWH - recLabW - 5;
    recLab.y = bDLab.y;
    recLab.height = 20;
    [self addSubview:recLab];
    

    SINWallet *wallet = self.wallet;
    NSInteger itemCount = wallet.list.count;
    CGFloat itemW = selfW / itemCount;
    CGFloat iconWH = 30;
    for (int i = 0; i < itemCount; i++) {
        UIImageView *iconV = [[UIImageView alloc] init];
        SINWalletItem *item = wallet.list[i];
        [iconV sin_setImageWithURL:[NSURL URLWithString:item.icon]];
        iconV.x = itemW * 0.5 - iconWH * 0.5 + (itemW * i);
        iconV.y = CGRectGetMaxY(bDLab.frame) + margin;
        iconV.width = iconWH;
        iconV.height = iconWH;
        [self addSubview:iconV];
        
        UILabel *strLab = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
        strLab.text = item.name;
        CGFloat strLabW = [strLab.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
        strLab.width = strLabW;
        strLab.x = iconV.x + iconV.width * 0.5 - strLabW * 0.5;
        strLab.y = CGRectGetMaxY(iconV.frame) + margin * 0.5;
        strLab.height = 20;
        [self addSubview:strLab];
        
        if (i == itemCount - 1) {
            
            // 分割线
            UIView *lineV = [[UIView alloc] init];
            lineV.alpha = 0.5;
            lineV.backgroundColor = [UIColor darkGrayColor];
            lineV.x = 0;
            lineV.y = CGRectGetMaxY(strLab.frame) + margin;
            lineV.width = selfW;
            lineV.height = 0.5;
            [self addSubview:lineV];
            
            // 分割条
            UIView *highLineV = [[UIView alloc] init];
            highLineV.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
            highLineV.x = lineV.x;
            highLineV.y = CGRectGetMaxY(lineV.frame);
            highLineV.width = lineV.width;
            highLineV.height = margin;
            [self addSubview:highLineV];
            
            // 设置本身高度
            self.height = CGRectGetMaxY(highLineV.frame);
        }else
        {
            // item之间分割线
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor darkGrayColor];
            lineView.x = itemW - lineW * 0.5 + (itemW * i);
            lineView.y = iconV.y + margin * 0.5;
            lineView.height = CGRectGetMaxY(iconV.frame) - strLab.height * 2;
            lineView.width = lineW;
            [self addSubview:lineView];
        }
        
    }
    
}

@end
