//
//  SINUserCenterView.m
//  SinWaiMai
//
//  Created by apple on 04/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINUserCenterView.h"
#import "SINUserCenterItem.h"
#import "UIButton+SINWebCache.h"
#import "SINNormalButton.h"
#import "UILabel+Category.h"

@implementation SINUserCenterView

- (void)setUserCenterItems:(NSArray *)userCenterItems
{
    _userCenterItems = userCenterItems;
    
    [self setup];
}

- (void)setup
{
    NSArray *userCenterItems = self.userCenterItems;
    CGFloat selfW = SINScreenW;
    CGFloat selfH = 400;
    CGFloat lineWH = 0.5; // 线宽高
    NSInteger itemCount = userCenterItems.count;
    NSInteger column = 4;
    CGFloat itemWHPor = 0.7;
    CGFloat itemW = selfW / column;
    CGFloat itemH = itemW / itemWHPor;
    CGFloat btnW = itemW * 3/5;
    CGFloat btnH = itemH * 0.5;
    NSInteger row = itemCount % column > 0 ? itemCount / column + 1 : itemCount / column;
    
    // 横线
    for (int i = 0; i < row + 1; i++) {
        UIView *hV = [[UIView alloc] init];
        hV.alpha = 0.5;
        hV.backgroundColor = [UIColor darkGrayColor];
        hV.x = 0;
        hV.y = i * itemH;
        hV.height = lineWH;
        hV.width = selfW;
        [self addSubview:hV];
        
        if (i == row) {
            // 客服热线
            UILabel *serviceLab = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
            serviceLab.textAlignment = NSTextAlignmentCenter;
            serviceLab.text = [NSString stringWithFormat:@"%@ : %@",self.customer_service_Dict[@"name"],self.customer_service_Dict[@"phone"]];
            serviceLab.x = hV.x;
            serviceLab.width = hV.width;
            serviceLab.height = 20;
            serviceLab.y = CGRectGetMaxY(hV.frame) + 10;
            [self addSubview:serviceLab];
        }
    }
    
    // 竖线
    for (int i = 0; i < column + 1; i++) {
        UIView *vV = [[UIView alloc] init];
        vV.alpha = 0.5;
        vV.backgroundColor = [UIColor blackColor];
        vV.x = i * itemW;
        vV.y = 0;
        vV.height = selfH;
        vV.width = lineWH;
        [self addSubview:vV];
    }
    
    for (NSInteger i = 0; i < itemCount; i++) {
        SINNormalButton *btn = [[SINNormalButton alloc] init];
        SINUserCenterItem *item = userCenterItems[i];
        [btn sin_setImageWithURL:[NSURL URLWithString:item.icon] forState:UIControlStateNormal];
        [btn setTitle:item.name forState:UIControlStateNormal];
        NSInteger preRow = i / 4;
        NSInteger preCol = i % 4;
        btn.width = btnW;
        CGFloat strW = [item.name boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
        if (btn.width < strW) {
            btn.width = strW;
        }
        btn.height = btnH;
        btn.x = itemW * 0.5 - btn.width * 0.5 + itemW * preCol;
        btn.y =  itemH * 0.5 - btn.height * 0.5 + itemH * preRow;
        [self addSubview:btn];
        
        // item附加信息
        if (item.desc.length) {
            UILabel *descLab = [UILabel createLabelWithFont:11 textColor:[UIColor redColor]];
            descLab.textAlignment = NSTextAlignmentCenter;
            descLab.text = item.desc;
            descLab.y = CGRectGetMaxY(btn.frame) + 5;
            descLab.x = itemW * preCol;
            descLab.width = itemW;
            descLab.height = 20;
            [self addSubview:descLab];
        }
    }
}

@end
