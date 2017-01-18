//
//  SINShoppe.h
//  SinWaiMai
//
//  Created by apple on 18/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINShoppe : NSObject

/** 平均评分 */
@property (nonatomic,strong) NSString *average_score;

/** 外送时间 */
@property (nonatomic,assign) int *delivery_time;

/** 距离 */
@property (nonatomic,assign) int *distance;

/** 外送类型名称 */
@property (nonatomic,strong) NSString *front_logistics_text;

/** 外送类型 */
@property (nonatomic,strong) NSString *front_logistics_type;

/** 商家logo(需要截串) */
@property (nonatomic,strong) NSString *logo_url;

/** 月销售量 */
@property (nonatomic,assign) int *saled_month;

/** 商户id */
@property (nonatomic,strong) NSString *shop_id;

/** 商户名 */
@property (nonatomic,strong) NSString *shop_name;

/** 配送费 */
@property (nonatomic,strong) NSString *takeout_cost;

/** 起送价 */
@property (nonatomic,strong) NSString *takeout_price;


+ (instancetype)shoppeWithDict:(NSDictionary *)dict;

@end
