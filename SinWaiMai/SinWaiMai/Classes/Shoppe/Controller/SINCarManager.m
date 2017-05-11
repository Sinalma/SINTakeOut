//
//  SINCarManager.m
//  SinWaiMai
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCarManager.h"
#import "SINFood.h"

#define OverviewUpdateFoodCountNoti @"OverviewAddFoodNoti"

@interface SINCarManager ()

/** Save current all of order int car view */
@property (nonatomic,strong) NSMutableArray *foodes;

@property (nonatomic,assign) int totalFoodCount;

@end

@implementation SINCarManager

/** Achieve all order for the class method  */
static NSArray *_classFoodes;

#pragma mark - 单粒
static SINCarManager *_carMgr;
#pragma mark - Inital Method
- (instancetype)init
{
    if (self = [super init]) {
        
        [SINNotificationCenter addObserver:self selector:@selector(foodCell_updateFood:) name:AddFoodToShopCarName object:nil];
        [SINNotificationCenter addObserver:self selector:@selector(overview_updateFoodCount:) name:OverviewUpdateFoodCountNoti object:nil];
        [SINNotificationCenter addObserver:self selector:@selector(carViewWillShowOverview:) name:ShowOverviewNotiName object:nil];
        [SINNotificationCenter addObserver:self selector:@selector(carViewWillHideOverview) name:HideOverviewNotiName object:nil];
        [SINNotificationCenter addObserver:self selector:@selector(foodCell_updateFood:) name:OverviewUpdateFoodNotiName object:nil];
    }
    return self;
}

- (void)carViewWillShowOverview:(NSNotification *)noti
{
    if ([self.overviewDelegate performSelector:@selector(carMgr_willShowOverview:) withObject:nil]) {
        [self.overviewDelegate carMgr_willShowOverview:self.foodes];
    }
}

- (void)carViewWillHideOverview
{
    if ([self.overviewDelegate performSelector:@selector(carMgr_willShowOverview:) withObject:nil]) {
        [self.overviewDelegate carMgr_willHideOverview];
    }
}

#pragma mark - Override Method

#pragma mark - Oneself Assign Method
+ (NSArray *)totalOrderFromFood
{
    return _classFoodes;
}

- (void)carMgr_addObjectToFoodes:(SINFood *)food
{
    [self.foodes addObject:food];
    _classFoodes = self.foodes;
}

static NSString *totalCountStr = nil;
static NSArray *emptyFoodIndexes = nil;
- (void)compareFood_idAndDealFood:(SINFood *)food
{
    self.totalFoodCount = 0;
    BOOL isRepetion = NO;
    
    for (SINFood *curFood in self.foodes) {
        
        self.totalFoodCount += curFood.orderCount;

        if ([curFood.item_id isEqualToString:food.item_id]) {
            switch (food.operate) {
                case KOperateByIncrease:
                    curFood.orderCount += 1;
                    self.totalFoodCount += 1;
                    break;
                case KOperateByDecrease:{
                    curFood.orderCount -= 1;
                    self.totalFoodCount -= 1;
                }
                    break;
                default:
                    break;
            }
            isRepetion = YES;
        }
        
        NSMutableArray *arrM = [NSMutableArray array];
        if (curFood.orderCount == 0) {
            [arrM addObject:curFood];
        }
        emptyFoodIndexes = arrM;
    }
    
    if (!isRepetion || !self.foodes.count) {
        food.orderCount = 1;
        self.totalFoodCount += food.orderCount;
        [self carMgr_addObjectToFoodes:food];
    }
    
    for (SINFood *food in emptyFoodIndexes) {
        [self.foodes removeObject:food];
    }
    
    food.operate = KOperateByDone;
    totalCountStr = [NSString stringWithFormat:@"%d",self.totalFoodCount];
    if (self.totalFoodCount == 0) {
        self.foodes = nil;
    }
}

static NSString *totalPriceStr = nil;
static int totalPrice;
- (void)countingTotalPrice
{
    totalPrice = 0;
    int price = 0;
    for (SINFood *food in self.foodes) {
       price = [food.current_price intValue];
       totalPrice = totalPrice + (price * food.orderCount);
    }
    totalPriceStr = [NSString stringWithFormat:@"%d",totalPrice];
}

#pragma mark - Monitored Method From Notification
/**
 * Food cell add food notification method.
 */
- (void)foodCell_updateFood:(NSNotification *)noti
{
    SINFood *food = noti.object;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self compareFood_idAndDealFood:food];
        [self countingTotalPrice];
    });
    
    SINDISPATCH_MAIN_THREAD(^{
        
        // notify delegate
        if ([self.delegate performSelector:@selector(carMgr_OrderFromFood:operate:) withObject:food withObject:@(KOperateByIncrease)]) {
            [self.delegate carMgr_OrderFromFood:food operate:KOperateByIncrease];
        }
        [self updateDelegateCountAndPrice];
    });
}

- (void)updateDelegateCountAndPrice
{
    if ([self.delegate performSelector:@selector(carMgr_updateOrder:totalCount:) withObject:self.foodes withObject:totalCountStr]) {
        [self.delegate carMgr_updateOrder:self.foodes totalCount:totalCountStr];
    }
    
    if ([self.delegate performSelector:@selector(carMgr_updateTotalPrice:) withObject:totalPriceStr]) {
        [self.delegate carMgr_updateTotalPrice:totalPriceStr];
    }
}

- (void)overview_updateFoodCount:(NSNotification *)noti
{
    SINFood *food = noti.object;
    
    for (SINFood *food_t in self.foodes) {
        if (food_t.category_id == food.category_id) {
            food_t.orderCount = food.orderCount;
        }
    }
}

#pragma mark - Lazying Load
- (NSMutableArray *)foodes
{
    if (!_foodes) {
        _foodes = [NSMutableArray array];
    }
    return _foodes;
}

#pragma mark - Single Method
+ (instancetype)shareCarMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _carMgr = [[self alloc] init];
    });
    return _carMgr;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _carMgr = [super allocWithZone:zone];
    });
    return _carMgr;
}

- (instancetype)copy
{
    return _carMgr;
}

@end
