//
//  SINShoppeTableViewCell.m
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShoppeTableViewCell.h"
#import "UIImageView+SINWebCache.h"
#import "UILabel+Category.h"
#import "UIImageView+SINWebCache.h"

@interface SINShoppeTableViewCell ()

#pragma mark - 控件
/** 新店图标 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_mark_picView;
/** 商户logoImageView */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
/** 商户名label */
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
/** 配送商label */
@property (weak, nonatomic) IBOutlet UILabel *front_logistics_text;
/** 月销售量label */
@property (weak, nonatomic) IBOutlet UILabel *saledMouthLabel;
/** 起送价label */
@property (weak, nonatomic) IBOutlet UILabel *takeOutPriceLabel;
/** 配送费label */
@property (weak, nonatomic) IBOutlet UILabel *takeOutCostLabel;
/** 配送时间label */
@property (weak, nonatomic) IBOutlet UILabel *delivery_time;
/** 距离label */
@property (weak, nonatomic) IBOutlet UILabel *distance;
/** 底部优惠信息容器View */
@property (weak, nonatomic) IBOutlet UIView *welfareContainer;

#pragma mark - 数据
/** 保存优惠信息图标地址的字典 */
@property (nonatomic,strong) NSDictionary *welfareIconUrls;

@end

@implementation SINShoppeTableViewCell
- (NSDictionary *)welfareIconUrls
{
    if (_welfareIconUrls == nil) {
        _welfareIconUrls = [NSDictionary dictionaryWithContentsOfFile:ShoppeWelfareIconUrlFilePath.cachePath];
    }
    return _welfareIconUrls;
}

- (void)setShoppe:(SINShoppe *)shoppe
{
    _shoppe = shoppe;
    
    // 商户logo
    [self.logoImageView sin_setImageWithURL:[NSURL URLWithString:shoppe.logo_url] placeholderImage:[UIImage imageNamed:@"category_default_50x50_"]];
    
    // 商户名称
    self.shopNameLabel.text = shoppe.shop_name;
    
    // 百度专送
    if ([shoppe.front_logistics_text isEqualToString:@"百度专送"]) {
        
        self.front_logistics_text.hidden = NO;
    }else
    {
        self.front_logistics_text.hidden = YES;
    }
    
    // 月销售量
    self.saledMouthLabel.text = [NSString stringWithFormat:@"月售%d份",shoppe.saled_month];
    
    // 起送价
    self.takeOutPriceLabel.text = [NSString stringWithFormat:@"起送价 ¥%@",shoppe.takeout_price];
    
    // 配送费
    if ([shoppe.takeout_cost isEqualToString:@"0"]) {
        
        self.takeOutCostLabel.text = [NSString stringWithFormat:@"免费配送"];
    }else
    {
        self.takeOutCostLabel.text = [NSString stringWithFormat:@"配送费 ¥%@",shoppe.takeout_cost];
    }
    
    // 配送时间
    self.delivery_time.text = [NSString stringWithFormat:@"%d分钟",shoppe.delivery_time];
    
    // 距离
    if (shoppe.distance >= 1000) {
        
        NSString *ratio = [NSString accurateCalculationWithDecimal:shoppe.distance / 1000.0];
        
        self.distance.text = [NSString stringWithFormat:@"%@km",ratio];
    }else
    {
        self.distance.text = [NSString stringWithFormat:@"%dm",shoppe.distance];
    }
    
    // 添加优惠信息
    CGFloat margin = 10;

    // 优惠图片
    CGFloat imgW = 20;
    CGFloat imgH = 20;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    
    // 箭头宽高
    CGFloat arrowWH = 15;
    CGFloat arrowX = 0;
    CGFloat arrowY = 0;
    
    // 活动数label
    CGFloat labCW = 45;
    CGFloat labCX = 0;
    
    // 优惠信息label
    CGFloat labW = SINScreenW - 2 * margin - imgW - margin - arrowWH - labCW;
    CGFloat labH = imgH;
    CGFloat labX = 0;
    CGFloat labY = 0;
    
    for (UIView *view in self.welfareContainer.subviews) {
        [view removeFromSuperview];
    }
    
    // 新店图标
    if (shoppe.shop_mark_pic.length) {
        
        self.shop_mark_picView.hidden = NO;
        [self.shop_mark_picView sin_setImageWithURL:[NSURL URLWithString:shoppe.shop_mark_pic]];
    }else if (!shoppe.shop_mark_pic.length)
    {
        self.shop_mark_picView.hidden = YES;
    }
    
    // 优惠数
    NSInteger welCount = shoppe.welfare_act_info.count;
    
    if (welCount <= 2) {
        self.welfareContainer.userInteractionEnabled = NO;
    }else if (welCount > 2)
    {
        self.welfareContainer.userInteractionEnabled = YES;
    }
    
    for (int i = 0; i < welCount; i++) {
        // 优惠信息图标
        UIImageView *imgV = [[UIImageView alloc] init];
        NSString *signType = shoppe.welfare_act_info[i][@"type"];
        NSString *signUrl = self.welfareIconUrls[signType];
        [imgV sin_setImageWithURL:[NSURL URLWithString:signUrl]];
        imgY = (imgH + margin) * i;
        imgV.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [self.welfareContainer addSubview:imgV];
        // 优惠信息标题
        UILabel *label = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
        label.text = shoppe.welfare_act_info[i][@"msg"];
        labX = CGRectGetMaxX(imgV.frame) + 10;
        labY = imgY;
        if (shoppe.welfare_act_info.count <= 2) {
            // 两个及以下活动时，优惠信息标题占剩余的全部可用宽度
            label.frame = CGRectMake(labX, labY, SINScreenW-2*margin-imgW-margin, labH);
        }else
        {
            
            label.frame = CGRectMake(labX, labY, labW, labH);
        }
        [self.welfareContainer addSubview:label];
        
        // 添加活动数label和箭头图片
        if (shoppe.welfare_act_info.count > 2 && i == 0) {
            
            UILabel *lab = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
            lab.text = [NSString stringWithFormat:@"%ld个活动",(long)welCount];
            labCX = CGRectGetMaxX(label.frame);
            lab.frame = CGRectMake(labCX, labY, labCW, labH);
            [self.welfareContainer addSubview:lab];
            
            UIButton *btn = [[UIButton alloc] init];
            [btn setImage:[UIImage imageNamed:@"downarrow_14x14_"] forState:UIControlStateNormal];
            arrowY = (lab.height - arrowWH) / 2;
            arrowX = CGRectGetMaxX(lab.frame);
            btn.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
            [self.welfareContainer addSubview:btn];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    // 添加手势监听优惠容器的点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(welfareContainerClick)];
    [self.welfareContainer addGestureRecognizer:tap];
}

/** 记录底部优惠容器张开与闭合的状态 */
static bool welfareContainerStatus = NO;

- (void)welfareContainerClick
{
    NSInteger welCount = self.shoppe.welfare_act_info.count;
    
    if (welCount > 2 && welfareContainerStatus == NO) {
        
        self.cellHeight = self.welfareContainer.y + welCount * 30;
        self.height = self.cellHeight;
        welfareContainerStatus = !welfareContainerStatus;
    }else if (welCount > 2 && welfareContainerStatus == YES)
    {
        self.cellHeight = self.welfareContainer.y + 2 * 30;
            self.height = self.cellHeight;
        
        welfareContainerStatus = !welfareContainerStatus;
    }
    
    if ([self.delegate respondsToSelector:@selector(shoppeCellWelfareContainerClick:)]) {
        
        [self.delegate shoppeCellWelfareContainerClick:self];
    }
}

@end
