//
//  SINFoodCell.m
//  SinWaiMai
//
//  Created by apple on 24/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINFoodCell.h"
#import "UIImageView+SINWebCache.h"

@interface SINFoodCell ()

/** 商户logoUrl */
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

/** 商户名label */
@property (weak, nonatomic) IBOutlet UILabel *shop_name_label;

/** 食物描述-套餐 */
@property (weak, nonatomic) IBOutlet UILabel *descption_Label;

/** 月售和好评率label */
@property (weak, nonatomic) IBOutlet UILabel *saledWithGoodCommentLabel;

/** 价格label */
@property (weak, nonatomic) IBOutlet UILabel *origin_price_label;

@end

@implementation SINFoodCell

- (void)setFood:(SINFood *)food
{
    _food = food;
    
    food.url = [[food.url componentsSeparatedByString:@"@"] firstObject];
    [self.logoImgView sin_setImageWithURL:[NSURL URLWithString:food.url]];
    
    self.shop_name_label.text = food.name;
    
    self.descption_Label.text = food.desc;
    
    NSString *goodCommentRatio = food.good_comment_ratio;
    int ratio = [goodCommentRatio intValue] * 100;
    NSString *ratioStr = ratio == 0 ? @"0" : [NSString stringWithFormat:@"%d%%",ratio];
    self.saledWithGoodCommentLabel.text = [NSString stringWithFormat:@"月售%@ 好评率%@",food.saled,ratioStr];
    
    self.origin_price_label.text = [NSString stringWithFormat:@"¥%@",food.origin_price];
}
- (IBAction)addFood:(UIButton *)sender {
    
    UIView *redView = [[UIView alloc] init];
    redView.frame = sender.frame;
    redView.layer.cornerRadius = sender.width*0.5;
    redView.backgroundColor = [UIColor redColor];
    [self addSubview:redView];
    [UIView animateWithDuration:1.0 animations:^{
        
        redView.transform = CGAffineTransformMakeTranslation(-SINScreenW, SINScreenH-sender.y-50);
    } completion:^(BOOL finished) {
        [SINNotificationCenter postNotificationName:AddFoodToShopCarName object:self.food];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
