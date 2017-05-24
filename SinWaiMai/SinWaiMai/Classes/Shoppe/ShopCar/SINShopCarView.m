//
//  SINShopCarView.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShopCarView.h"
#import "SINFood.h"
#import "SINShoppeInfo.h"
#import "SINLoginViewController.h"
#import "SINCarManager.h"

#define SINCarViewGrayColor [UIColor colorWithRed:66/255.0 green:62/255.0 blue:59/255.0 alpha:1.0]
#define SINCarViewPinkColor [UIColor colorWithRed:245/255.0 green:56/255.0 blue:82/255.0 alpha:1.0]

@interface SINShopCarView () <SINOverviewMgrDelegate>

/** 购物车图片imgView */
@property (weak, nonatomic) IBOutlet UIImageView *shoppeCarImgV;
/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/** 配送费 */
@property (weak, nonatomic) IBOutlet UILabel *takeoutPriceLabel;
/** 起送费 */
@property (weak, nonatomic) IBOutlet UILabel *differPriceLabel;
/** 当前订单数 */
@property (weak, nonatomic) IBOutlet UILabel *curOrderCountLabel;
/** 购物车食物的数组 */
@property (nonatomic,strong) NSMutableArray *foodes;
@property (nonatomic,strong) SINCarManager *carMgr;

@end

@implementation SINShopCarView
+ (instancetype)shopCarView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINShopCarView class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = SINCarViewGrayColor;
    self.differPriceLabel.backgroundColor = SINCarViewGrayColor;
    self.curOrderCountLabel.backgroundColor = SINCarViewPinkColor;
    self.differPriceLabel.textColor = [UIColor whiteColor];
    
    NSString *str = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
    self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",str];
    self.differPriceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceOK)];
    [self.differPriceLabel addGestureRecognizer:tap];
    
    [SINNotificationCenter addObserver:self selector:@selector(priceDidChange) name:SINShopCarPriceDidChangeNoti object:nil];
    [SINNotificationCenter addObserver:self selector:@selector(showOrHideOverview) name:SINShopCarDidClearNoti object:nil];
}

- (void)priceDidChange
{
    int count = [[SINCarManager shareCarMgr] getTotalFoodCount];
    
    if (count <= 0)
    {
        self.curOrderCountLabel.hidden = YES;
        self.differPriceLabel.backgroundColor = SINCarViewGrayColor;
        NSString *difStr = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
        self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",difStr];
    }else
    {
        self.differPriceLabel.text = @"选好了";
        self.differPriceLabel.backgroundColor = SINCarViewPinkColor;
        self.curOrderCountLabel.hidden = NO;
    }
    self.curOrderCountLabel.text = [NSString stringWithFormat:@"%d",count];
    self.foodes = [[SINCarManager shareCarMgr] getShopCarFoodes];
    
    NSString *priceStr = [[SINCarManager shareCarMgr] getAllFoodPrice];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共¥%@",priceStr];
    
    self.takeoutPriceLabel.text = [NSString stringWithFormat:@"另需配送费%@元",self.shopInfo.takeout_cost];
}

- (void)dealloc
{
    [SINNotificationCenter removeObserver:self];
}

/**
 * Right pink button click , is select ok.
 */
- (void)choiceOK
{
    if (!self.foodes.count) {
        // HUD:Shop car is empty.
        return;
    }
    // Not login,jump to login view control.
    if (![[SINAccount sharedAccount] isLogin])
    {
        UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *naviVC = (UINavigationController *)rootVC.presentedViewController;
        SINLoginViewController *loginVC = [[SINLoginViewController alloc] init];
        UINavigationController *curNaviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [naviVC presentViewController:curNaviVC animated:YES completion:nil];
    }
}

#pragma mark - SINCarMgrDelegate

- (void)carMgr_willHideOverview
{
    [self hideShopCarAnim];
}

static BOOL showingOverviewState = NO;
- (void)showOrHideOverview
{
    if (!self.foodes.count && showingOverviewState == NO) {
        SINLog(@"购物车是空的");
        return;
    }
    if (showingOverviewState) {
        [SINNotificationCenter postNotificationName:HideOverviewNotiName object:nil];
        [self hideShopCarAnim];
        showingOverviewState = NO;
        return;
    }
    
    // 弹出已选商品一览界面
    [SINNotificationCenter postNotificationName:ShowOverviewNotiName object:self.foodes];
    
    [self showShopCarAnim];
    
    showingOverviewState = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showOrHideOverview];
}

- (void)hideShopCarAnim
{
    self.userInteractionEnabled = NO;
    [SINAnimtion sin_animateWithDuration:ShowOverTableAnimTime animations:^{
        self.shoppeCarImgV.transform = CGAffineTransformIdentity;
        self.curOrderCountLabel.transform = CGAffineTransformIdentity;
        self.totalPriceLabel.transform = CGAffineTransformIdentity;
        self.takeoutPriceLabel.transform = CGAffineTransformIdentity;
    } completion:^{
        self.userInteractionEnabled = YES;
    }];
}

- (void)showShopCarAnim
{
    self.userInteractionEnabled = NO;
    // 同时做购物车图标上移动画
    [SINAnimtion sin_animateWithDuration:ShowOverTableAnimTime animations:^{
        self.shoppeCarImgV.transform = CGAffineTransformMakeTranslation(0, -465);
        self.curOrderCountLabel.transform = CGAffineTransformMakeTranslation(0, -465);
        self.totalPriceLabel.transform = CGAffineTransformMakeTranslation(-60, 0);
        self.takeoutPriceLabel.transform = CGAffineTransformMakeTranslation(-60, 0);
    } completion:^{
        self.userInteractionEnabled = YES;
    }];
}

- (NSMutableArray *)foodes
{
    if (!_foodes) {
        _foodes = [NSMutableArray array];
    }
    return _foodes;
}

@end
