//
//  SINCarDatabase.m
//  SinWaiMai
//
//  Created by apple on 14/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCarDatabase.h"
#import "SINFood.h"

@interface SINCarDatabase ()

/** order of all shoppes for current user */
@property (nonatomic,strong) NSMutableDictionary *orderShoppes;

/** order of all foodes for current shop */
@property (nonatomic,strong) NSMutableDictionary *orderFoodes;

@end

@implementation SINCarDatabase


- (int)carDB_curUserOrderCount
{
    int totalCount = 0;
    for (NSDictionary *shop in _orderShoppes) {
        for (SINFood *food in shop) {
            totalCount += food.orderCount;
        }
    }
    return totalCount;
}

- (int)carDB_ShopOrderCount:(NSString *)shop_id
{
    int totalCount = 0;
    NSDictionary *dict = _orderShoppes[shop_id];
    for (SINFood *food in dict) {
        totalCount += food.orderCount;
    }
    return totalCount;
}

- (void)carDB_curShopFoodes:(NSString *)item_id
{
    
}

- (void)carDB_updateFood:(SINFood *)food
{
    if (!food) return;
    if (!food.orderCount) {
        [_orderFoodes removeObjectForKey:food.item_id];
    }
}


- (NSMutableDictionary *)orderFoodes
{
    if (!_orderFoodes) {
        _orderFoodes = [NSMutableDictionary dictionary];
    }
    return _orderFoodes;
}

- (NSMutableDictionary *)orderShoppes
{
    if (!_orderShoppes) {
        _orderShoppes = [NSMutableDictionary dictionary];
    }
    return _orderShoppes;
}

@end
