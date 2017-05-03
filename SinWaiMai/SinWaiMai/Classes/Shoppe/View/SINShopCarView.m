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
#import "SINAccount.h"
#import "SINLoginViewController.h"

@interface SINShopCarView ()

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

/** 已加入购物车的商品一览表内层view */
@property (nonatomic,strong) UIView *carOverview;

/** 蒙版 */
@property (nonatomic,strong) UIWindow *outWindow;

/** 显示商品的tableview */
@property (nonatomic,strong) UITableView *overTableView;

@end

@implementation SINShopCarView
+ (instancetype)shopCarView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINShopCarView class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString *str = self.shopInfo.takeout_price.length?self.shopInfo.takeout_price:@"0";
    self.differPriceLabel.text = [NSString stringWithFormat:@"%@元起送",str];
    self.differPriceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceOK)];
    [self.differPriceLabel addGestureRecognizer:tap];
    [SINNotificationCenter addObserver:self selector:@selector(receiveFood:) name:AddFoodToShopCarName object:nil];
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
    self.differPriceLabel.backgroundColor = [UIColor redColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.foodes.count) {
        SINLog(@"购物车是空的");
        return;
    }
    // 弹出已选商品总览界面
    self.outWindow.hidden = NO;
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

- (UIView *)outView
{
    if (!_outWindow) {
        _outWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SINScreenW, SINScreenH-self.height)];
        _outWindow.backgroundColor = [UIColor redColor];
        _outWindow.alpha = 0.6;
        [[UIApplication sharedApplication].keyWindow addSubview:_outWindow];
    }
    return _outWindow;
}

- (UIView *)carOverview
{
    if (!_carOverview) {
        _carOverview = [[UIView alloc] init];
        _carOverview.backgroundColor = [UIColor whiteColor];
    }
    return _carOverview;
}

- (UITableView *)overTableView
{
    if (!_overTableView) {
        _overTableView = [[UITableView alloc] init];
    }
    return _overTableView;
}

@end
