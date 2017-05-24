//
//  SINBuyView.m
//  SinWaiMai
//
//  Created by apple on 20/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  用于操作食物添加／减少的view。

#import "SINBuyView.h"
#import "SINThrowView.h"
#import "SINFood.h"
#import "SINCarManager.h"

@interface SINBuyView ()

@property (nonatomic,strong) UIButton *increaseBtn;
@property (nonatomic,strong) UIButton *decreaseBtn;
@property (nonatomic,strong) UILabel *countLabel;

@end

@implementation SINBuyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setFood:(SINFood *)food
{
    _food = food;
    self.buyCount = food.orderCount;
}

- (void)setBuyCount:(int)buyCount
{
    _buyCount = buyCount;

    if (buyCount <= 0) {
        self.decreaseBtn.hidden = YES;
        self.countLabel.hidden = YES;
        self.countLabel.text = @"0";
    }else
    {
        self.decreaseBtn.hidden = NO;
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%d",buyCount];
    }
}

// 数量上限
static int buyMaxCount = 100;
- (void)increaseFood
{
    SINThrowView *imgV = [[SINThrowView alloc] init];
    imgV.image = [UIImage imageNamed:@"increase"];
    imgV.frame = self.increaseBtn.frame;
    imgV.layer.cornerRadius = self.increaseBtn.width*0.5;
    [self addSubview:imgV];
    imgV.timeRatio = 0.4;
    [imgV throwToPoint:CGPointMake(-245, 400) completion:nil];
    
    if (self.buyCount >= buyMaxCount) return;
    
    self.buyCount++;
    self.decreaseBtn.hidden = NO;
    self.countLabel.hidden = NO;
    self.food.orderCount = self.buyCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.buyCount];
    [[SINCarManager shareCarMgr] addFoodToShopCar:self.food];
    [self sendNotication];
}

- (void)decreaseFood
{
    if (self.buyCount <= 0) {
            return;
    }
    self.buyCount--;
    if (!self.buyCount) {
        self.decreaseBtn.hidden = YES;
        self.countLabel.hidden = YES;
        self.countLabel.text = @"0";
        [[SINCarManager shareCarMgr] removeFood:self.food];
    }
    
    self.food.orderCount = self.buyCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.buyCount];
    [self sendNotication];
    
}

- (void)sendNotication
{
    [SINNotificationCenter postNotificationName:SINShopCarCountDidChangeNoti object:nil];
    [SINNotificationCenter postNotificationName:SINShopCarPriceDidChangeNoti object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.decreaseBtn.frame = CGRectMake(0, 0, self.width * 0.3, self.height);
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.decreaseBtn.frame), 0, self.width * 0.4, self.height);
    self.increaseBtn.frame = CGRectMake(CGRectGetMaxX(self.countLabel.frame), 0, self.width * 0.3, self.height);
}

- (void)setupUI
{
    UIButton *decreaseBtn = [[UIButton alloc] init];
    decreaseBtn.hidden = YES;
    [decreaseBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decreaseBtn addTarget:self action:@selector(decreaseFood) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:decreaseBtn];
    self.decreaseBtn = decreaseBtn;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.hidden = YES;
    lab.text = @"0";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor darkTextColor];
    [self addSubview:lab];
    self.countLabel = lab;
    
    UIButton *increaseBtn = [[UIButton alloc] init];
    [increaseBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [increaseBtn addTarget:self action:@selector(increaseFood) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:increaseBtn];
    self.increaseBtn = increaseBtn;
}

@end
