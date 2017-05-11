//
//  SINCarManager.h
//  SinWaiMai
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

// This calss is manager food data、detail and logic about user all of order .

/**
 * Implementation Detail 
 *
 * Monitored add food from food cell , back up transfer delegate method of car view and overview.
 * When user click car view , push overview and give all of food data to over view.
 * When add food from overview ,update food cell data after back.
 */

// share data

#import <Foundation/Foundation.h>
@class SINFood;


@protocol SINCarMgrDelegate <NSObject>

/** When receive notification of add food , back up this method from delegate. */
- (void)carMgr_updateOrder:(NSArray *)foodes totalCount:(NSString *)totalCount;
- (void)carMgr_updateTotalPrice:(NSString *)totalPrice;
@optional
- (void)carMgr_OrderFromFood:(SINFood *)food operate:(CarMgrOperateWay)operate;

@end

@protocol SINOverviewMgrDelegate <NSObject>

- (void)carMgr_willShowOverview:(NSMutableArray *)foodes;
- (void)carMgr_willHideOverview;

@end

@interface SINCarManager : NSObject

@property (nonatomic,weak) id<SINCarMgrDelegate> delegate;

@property (nonatomic,weak) id<SINOverviewMgrDelegate> overviewDelegate;

+ (instancetype)shareCarMgr;

/** Return all of order from food. */
+ (NSArray *)totalOrderFromFood;

@end
