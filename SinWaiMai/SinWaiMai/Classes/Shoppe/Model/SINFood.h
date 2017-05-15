//
//  SINFood.h
//  SinWaiMai
//
//  Created by apple on 30/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  result->takeout_menu->元素->data->元素

#import <Foundation/Foundation.h>

@interface SINFood : NSObject

/** 自定义的属性，用于购物车结算统计 */
@property (nonatomic,assign) int orderCount;
@property (nonatomic,assign) CarMgrOperateWay operate;

/** 全部评价 */
@property (nonatomic,strong) NSNumber *total_comment_num;

/** 食物id */
@property (nonatomic,strong) NSString *category_id;

/** 当前价格 */
@property (nonatomic,strong) NSString *current_price;

/** 食物描述 */
@property (nonatomic,strong) NSString *desc;

/** 销售时间提示数组 */
@property (nonatomic,strong) NSArray *dish_available_tip;

/** 存放分类的数组 */
@property (nonatomic,strong) NSArray *dish_attr;

/** itemid */
@property (nonatomic,strong) NSString *item_id;

/** 好评率 */
@property (nonatomic,strong) NSString *good_comment_ratio;

/** 食物名称 */
@property (nonatomic,strong) NSString *name;

/** 是否销售-数字 */
@property (nonatomic,assign) NSNumber *on_sale;

/** 原始价格 */
@property (nonatomic,strong) NSString *origin_price;

/** 月销售量 */
@property (nonatomic,strong) NSNumber *saled;

/** 分享信息-字典 */
@property (nonatomic,strong) NSDictionary *share_tip;

/** logourl */
@property (nonatomic,strong) NSString *url;


+ (instancetype)foodWithDict:(NSDictionary *)dict;

@end
