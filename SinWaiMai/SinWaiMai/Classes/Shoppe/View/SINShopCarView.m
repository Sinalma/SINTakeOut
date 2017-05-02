//
//  SINShopCarView.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  购物车提示view

#import "SINShopCarView.h"
#import "SINFood.h"

@interface SINShopCarView ()

/** 购物车图片imgView */
@property (weak, nonatomic) IBOutlet UIImageView *shoppeCarImgV;

/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/** 配送费 */
@property (weak, nonatomic) IBOutlet UILabel *takeoutPriceLabel;

/** 起送差额 */
@property (weak, nonatomic) IBOutlet UILabel *differPriceLabel;

@property (nonatomic,strong) UILabel *redPriceLabel;

@property (nonatomic,strong) NSMutableArray *foodes;

@end

@implementation SINShopCarView

- (UILabel *)redPriceLabel
{
    if (!_redPriceLabel) {
        _redPriceLabel = [[UILabel alloc] init];
        _redPriceLabel.font = [UIFont systemFontOfSize:15];
        _redPriceLabel.textColor = [UIColor whiteColor];
        _redPriceLabel.backgroundColor = [UIColor redColor];
        _redPriceLabel.layer.cornerRadius = 10;
        _redPriceLabel.frame = CGRectMake(50, -10, 20, 20);
        [self addSubview:_redPriceLabel];
    }
    return _redPriceLabel;
}

+ (instancetype)shopCarView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINShopCarView class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [SINNotificationCenter addObserver:self selector:@selector(receiveFood:) name:AddFoodToShopCarName object:nil];
}

- (void)receiveFood:(NSNotification *)noti
{
    SINFood *food = noti.object;
    [self.foodes addObject:food];
    int price = [self totalPrice];
//    self.redPriceLabel.text = [NSString stringWithFormat:@"%d",price];
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.layer.cornerRadius = 15;
    lab.clipsToBounds = YES;
    lab.frame = CGRectMake(50, 0, 30, 30);
    [self addSubview:lab];
    lab.text = [NSString stringWithFormat:@"%d",price];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SINLog(@"购物车是空的");
}

- (int)totalPrice
{
    int totalP = 0;
    for (SINFood *food in self.foodes) {
        int price = [food.current_price intValue];
        totalP += price;
    }
    return totalP;
}

- (NSMutableArray *)foodes
{
    if (!_foodes) {
        _foodes = [NSMutableArray array];
    }
    return _foodes;
}

@end
