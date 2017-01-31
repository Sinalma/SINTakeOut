//
//  SINShopCarView.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  购物车提示view

#import "SINShopCarView.h"

@interface SINShopCarView ()

/** 购物车图片imgView */
@property (weak, nonatomic) IBOutlet UIImageView *shoppeCarImgV;

/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/** 配送费 */
@property (weak, nonatomic) IBOutlet UILabel *takeoutPriceLabel;

/** 起送差额 */
@property (weak, nonatomic) IBOutlet UILabel *differPriceLabel;

@end

@implementation SINShopCarView

+ (instancetype)shopCarView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINShopCarView class]) owner:nil options:nil] lastObject];
}

@end
