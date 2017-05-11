//
//  SINShopCarView.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  购物车提示view

#import "SINShopCarView.h"
#import "SINFood.h"
#import "SINShoppeInfo.h"
#import "SINLoginViewController.h"
#import "SINCarManager.h"

#define SINCarViewGrayColor [UIColor colorWithRed:66/255.0 green:62/255.0 blue:59/255.0 alpha:1.0]
#define SINCarViewPinkColor [UIColor colorWithRed:245/255.0 green:56/255.0 blue:82/255.0 alpha:1.0]

@interface SINShopCarView () <SINCarMgrDelegate>

/** 购物车图片imgView */
@property (weak, nonatomic) IBOutlet UIImageView *shoppeCarImgV;

/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/** 配送费 */
@property (weak, nonatomic) IBOutlet UILabel *takeoutPriceLabel;

/** 起送差额 */
@property (weak, nonatomic) IBOutlet UILabel *differPriceLabel;

/** 当前订单数label */
@property (weak, nonatomic) IBOutlet UILabel *curOrderCountLabel;

/** 存放当前选择的所有食物的数组 */
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
    
    // 初始化
    self.carMgr = [SINCarManager shareCarMgr];
    self.carMgr.delegate = self;
    
    self.backgroundColor = SINCarViewGrayColor;
    self.differPriceLabel.backgroundColor = SINCarViewGrayColor;
    self.curOrderCountLabel.backgroundColor = SINCarViewPinkColor;
    
    NSString *str = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
    self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",str];
    self.differPriceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceOK)];
    [self.differPriceLabel addGestureRecognizer:tap];
    
//    [SINNotificationCenter addObserver:self selector:@selector(receiveFood:) name:AddFoodToShopCarName object:nil];
}

- (void)dealloc
{
    [SINNotificationCenter removeObserver:self];
}

/**
 * 右边起送费lable点击
 */
- (void)choiceOK
{
    if (!self.foodes.count) {
        // 购物车为空
        return;
    }
    // 未登录则跳转至登录界面
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
- (void)carMgr_updateOrder:(NSArray *)foodes totalCount:(NSString *)totalCount
{
    self.foodes = [foodes copy];
    self.curOrderCountLabel.hidden = NO;
    self.curOrderCountLabel.text = totalCount;
    int count = [totalCount intValue];
    SINLog(@"totalCount - %@ - %d",totalCount,count);
    if (count <= 0) {
        self.curOrderCountLabel.hidden = YES;
    }
}

- (void)carMgr_updateTotalPrice:(NSString *)totalPrice
{
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共¥%@",totalPrice];
    
    self.takeoutPriceLabel.text = [NSString stringWithFormat:@"另需配送费%@元",self.shopInfo.takeout_cost];
    NSString *str = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
    
    self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",str];
    self.differPriceLabel.text = @"选好了";
    self.differPriceLabel.textColor = [UIColor whiteColor];
    self.differPriceLabel.backgroundColor = SINCarViewPinkColor;
}

- (void)carMgr_OrderFromFood:(SINFood *)food operate:(CarMgrOperateWay)operate
{
    
}

/**
 * 接到添加食物通知调用方法
 */
- (void)receiveFood:(NSNotification *)noti
{
    SINFood *food = noti.object;
    [self.foodes addObject:food];
    
    int orderCount = (int)self.foodes.count;
    int price = [self totalPrice];
    self.curOrderCountLabel.hidden = NO;
    self.curOrderCountLabel.text = [NSString stringWithFormat:@"%d",orderCount];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共¥%d",price];
    
    self.takeoutPriceLabel.text = [NSString stringWithFormat:@"另需配送费%@元",self.shopInfo.takeout_cost];
    NSString *str = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
    
    self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",str];
    self.differPriceLabel.text = @"选好了";
    self.differPriceLabel.textColor = [UIColor whiteColor];
    self.differPriceLabel.backgroundColor = SINCarViewPinkColor;
}

static BOOL showingOverviewState = NO;
- (void)showOrHideOverview
{
    if (!self.foodes.count && showingOverviewState == NO) {
        SINLog(@"购物车是空的");
        return;
    }
    if (showingOverviewState) {
//        if ([self.delegate performSelector:@selector(hideOverview)]) {
//            [self.delegate hideOverview];
//            [self hideShopCarAnim];
//        }
        [SINNotificationCenter postNotificationName:HideOverviewNotiName object:nil];
        [self hideShopCarAnim];
        showingOverviewState = NO;
        return;
    }
    
    // 弹出已选商品总览界面
//    if ([self.delegate performSelector:@selector(showOverviewWithFoodes:) withObject:self.foodes]) {
//        [self.delegate showOverviewWithFoodes:self.foodes];
//    }
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


/**
 * 获取当前已选食物总价格
 */
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
