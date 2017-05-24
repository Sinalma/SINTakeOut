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
static SINCarManager *_carMgr;

- (void)addFoodToShopCar:(SINFood *)food
{
    for (SINFood *everyFood in self.foodes) {
        if (everyFood.item_id == food.item_id) {
            return;
        }
    }
    [self.foodes addObject:food];
}

- (void)removeFood:(SINFood *)food
{
    for (int i = 0; i < self.foodes.count; i++) {
        SINFood *everyFood = self.foodes[i];
        if (everyFood.item_id == food.item_id) {
            [self.foodes removeObjectAtIndex:i];
        }
    }
    
    if (!self.foodes.count) {
        [SINNotificationCenter postNotificationName:SINShopCarDidClearNoti object:nil];
    }
}

- (NSMutableArray *)getShopCarFoodes
{
    return self.foodes;
}

- (NSInteger)getFoodTypeCount
{
    return self.foodes.count;
}

- (int)getTotalFoodCount
{
    int totalCount = 0;
    for (SINFood *food in self.foodes) {
        totalCount += food.orderCount;
    }
    return totalCount;
}

- (NSString *)getAllFoodPrice
{
    int totalPrice = 0;
    int price = 0;
    if (!self.foodes.count) return @"0";
    for (SINFood *food in self.foodes) {
        price = [food.current_price intValue];
        totalPrice = totalPrice + price * food.orderCount;
    }
    return [NSString stringWithFormat:@"%d",totalPrice];
}

- (BOOL)isEmpty
{
    return self.foodes.count;
}

#pragma mark - Inital Method
- (instancetype)init
{
    if (self = [super init]) {
        [SINNotificationCenter addObserver:self selector:@selector(carViewWillShowOverview:) name:ShowOverviewNotiName object:nil];
        [SINNotificationCenter addObserver:self selector:@selector(carViewWillHideOverview) name:HideOverviewNotiName object:nil];
    }
    return self;
}

#pragma mark - Monitored Method From Notification
- (void)carViewWillShowOverview:(NSNotification *)noti
{
    if ([self.overviewDelegate respondsToSelector:@selector(carMgr_willShowOverview:)]) {
        [self.overviewDelegate carMgr_willShowOverview:self.foodes];
    }
}

- (void)carViewWillHideOverview
{
    if ([self.overviewDelegate respondsToSelector:@selector(carMgr_willHideOverview)]) {
        [self.overviewDelegate carMgr_willHideOverview];
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
