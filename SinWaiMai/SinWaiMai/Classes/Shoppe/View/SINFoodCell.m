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
/** 订单数label */
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
/** 减 */
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
/** 加 */
@property (weak, nonatomic) IBOutlet UIButton *inCreaseBtn;
/** 原始价格 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@end

@implementation SINFoodCell

- (void)setFood:(SINFood *)food
{
    if (!self.curOrderCount) {
        self.decreaseBtn.hidden = YES;
        self.orderCountLabel.hidden = YES;
        self.orderCountLabel.text = @"0";
    }
    _food = food;
    
    food.url = [[food.url componentsSeparatedByString:@"@"] firstObject];
    [self.logoImgView sin_setImageWithURL:[NSURL URLWithString:food.url]];
    
    self.shop_name_label.text = food.name;
    self.descption_Label.text = food.desc;
    
    NSString *goodCommentRatio = food.good_comment_ratio;
    int ratio = [goodCommentRatio intValue] * 100;
    NSString *ratioStr = ratio == 0 ? @"0" : [NSString stringWithFormat:@"%d%%",ratio];
    self.saledWithGoodCommentLabel.text = [NSString stringWithFormat:@"月售%@ 好评率%@",food.saled,ratioStr];
    
    self.currentPricelabel.text = [NSString stringWithFormat:@"¥%@",food.current_price];
}

- (IBAction)decreaseBtnClick:(id)sender {
    self.curOrderCount--;
    self.orderCountLabel.text = [NSString stringWithFormat:@"%d",self.curOrderCount];
    if (self.curOrderCount == 0) {
        self.orderCountLabel.hidden = YES;
        self.decreaseBtn.hidden = YES;
    }
}

- (IBAction)addFood:(UIButton *)sender {

    SINThrowView *imgV = [[SINThrowView alloc] init];
    imgV.image = [UIImage imageNamed:@"increase"];
    imgV.frame = sender.frame;
    imgV.layer.cornerRadius = sender.width*0.5;
    [self addSubview:imgV];
    imgV.timeRatio = 0.5;
    [imgV throwToPoint:CGPointMake(-50, 400) completion:^{
        // 通知购物车
        [SINNotificationCenter postNotificationName:AddFoodToShopCarName object:self.food];
    }];
    
    self.curOrderCount++;
    self.decreaseBtn.hidden = NO;
    self.orderCountLabel.hidden = NO;
    self.orderCountLabel.text = [NSString stringWithFormat:@"%d",self.curOrderCount];
}

@end
