//
//  SINCarManager.h
//  SinWaiMai
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  添加食物的第一响应类，食物的采集者

// This calss is manager food data、detail and logic about user all of order.

/**
 * Implementation Detail 
 * share data
 *
 * Monitored add food from food cell , back up transfer delegate method of car view and overview.
 * When user click car view , push overview and give all of food data to over view.
 * When add food from overview ,update food cell data after back.
 */

#import <Foundation/Foundation.h>
@class SINFood;

@protocol SINOverviewMgrDelegate <NSObject>

@optional
- (void)carMgr_willShowOverview:(NSMutableArray *)foodes;
- (void)carMgr_willHideOverview;

@end

@interface SINCarManager : NSObject

@property (nonatomic,weak) id<SINOverviewMgrDelegate> overviewDelegate;

+ (instancetype)shareCarMgr;

- (void)addFoodToShopCar:(SINFood *)food;
- (void)removeFood:(SINFood *)food;
- (NSMutableArray *)getShopCarFoodes;
- (NSInteger)getFoodTypeCount;
- (int)getTotalFoodCount;
- (NSString *)getAllFoodPrice;
- (BOOL)isEmpty;

@end
