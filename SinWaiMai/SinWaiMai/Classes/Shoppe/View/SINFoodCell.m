//
//  SINFoodCell.m
//  SinWaiMai
//
//  Created by apple on 24/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINFoodCell.h"
#import "UIImageView+SINWebCache.h"
#import "SINThrowView.h"
#import "SINCarManager.h"
#import "SINBuyView.h"

@interface SINFoodCell ()
/** 商户logoUrl */
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
/** 商户名label */
@property (weak, nonatomic) IBOutlet UILabel *shop_name_label;
/** 食物描述-套餐 */
@property (weak, nonatomic) IBOutlet UILabel *descption_Label;
/** 月售和好评率label */
@property (weak, nonatomic) IBOutlet UILabel *saledWithGoodCommentLabel;
/** 当前价格label */
@property (weak, nonatomic) IBOutlet UILabel *currentPricelabel;
/** 原始价格 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@property (nonatomic,strong) SINCarManager *carMgr;

@property (nonatomic,strong) SINBuyView *buyView;
@end

@implementation SINFoodCell

- (void)setFood:(SINFood *)food
{
    _food = food;
    
    [self addSubview:self.buyView];
    self.buyView.food = food;
    SINLog(@"buyView - %@",NSStringFromCGRect(self.buyView.frame));
    food.orderCount = 0;
    
    food.url = [[food.url componentsSeparatedByString:@"@"] firstObject];
    [self.logoImgView sin_setImageWithURL:[NSURL URLWithString:food.url] placeholderImage:[UIImage imageNamed:@"category_default_50x50_"]];
    
    self.shop_name_label.text = food.name;
    self.descption_Label.text = food.desc;
    
    NSString *goodCommentRatio = food.good_comment_ratio;
    int ratio = [goodCommentRatio intValue] * 100;
    NSString *ratioStr = ratio == 0 ? @"0" : [NSString stringWithFormat:@"%d%%",ratio];
    self.saledWithGoodCommentLabel.text = [NSString stringWithFormat:@"月售%@ 好评率%@",food.saled,ratioStr];
    
    self.currentPricelabel.text = [NSString stringWithFormat:@"¥%@",food.current_price];
}

- (SINBuyView *)buyView
{
    if (!_buyView) {
        CGFloat y = (30 - self.originalPriceLabel.height) * 0.5;
        CGFloat x = SINScreenW * 0.75 - 100 - 10;
        _buyView = [[SINBuyView alloc] initWithFrame:CGRectMake(x, self.originalPriceLabel.y-y, 100, 30)];
//        _buyView = [[SINBuyView alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
    }
    return _buyView;
}

@end
