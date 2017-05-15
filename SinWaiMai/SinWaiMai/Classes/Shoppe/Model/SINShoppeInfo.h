//
//  SINShoppeInfo.h
//  SinWaiMai
//
//  Created by apple on 29/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINShoppeInfo : NSObject

/** 商家名称 */
@property (nonatomic,strong) NSString *shop_name;

/** 地址 */
@property (nonatomic,strong) NSString *address;

/** 平均评分 */
@property (nonatomic,strong) NSString *average_score;

/** 营业时间 */
@property (nonatomic,strong) NSString *bussiness_time;

// 公告板
/** 配送费说明 */
@property (nonatomic,strong) NSArray *delivery_announcement;
/** 商家公告 */
@property (nonatomic,strong) NSString *shop_announcement;

/** 配送时间 */
@property (nonatomic,strong) NSString *delivery_time;

/** 外送商 */
@property (nonatomic,strong) NSString *front_logistics_text;

/** 商家logo url */
@property (nonatomic,strong) NSString *logo_url;

/** 相似好店标签数组 */
@property (nonatomic,strong) NSArray *shop_category;

/** 营业执照图片url数组 */
@property (nonatomic,strong) NSArray *shop_certification_info;

/** 堂食实景图片url数组 */
@property (nonatomic,strong) NSArray *shop_photo_info;

/** 配送费 */
@property (nonatomic,strong) NSString *takeout_cost;

/** 配送费范围 */
@property (nonatomic,strong) NSString *takeout_cost_range;

/** 起送价格 */
@property (nonatomic,strong) NSString *takeout_price;

/** 公告板外层信息 */
@property (nonatomic,strong) NSString *title_name;

/** 活动信息数组 显示在选择食物界面，主界面 */
@property (nonatomic,strong) NSArray *welfare_act_info;

/** 基本活动信息数组 显示在商家详情界面 */
@property (nonatomic,strong) NSArray *welfare_basic_info;


// 商家模块
@property (nonatomic,strong) NSDictionary *front_logistics_brand;


@property (nonatomic,strong) NSString *shop_id;

///** 标题 */
//@property (nonatomic,strong) NSString *brand;
///** 描述 */
//@property (nonatomic,strong) NSString *desc;
///** 图标url */
//// http://img.waimai.baidu.com/pb/742020350b3ca86cf0d89dede4d25744ef@w_<wm[width]wm>,h_<wm[height]wm>,s_2,cf_1,l_1,q_60,f_png
//@property (nonatomic,strong) NSString *icon;
///** 信息 */
//@property (nonatomic,strong) NSString *message;
///** 链接 */
//@property (nonatomic,strong) NSString *url;


+ (instancetype)shoppeInfoWithDict:(NSDictionary *)dict;

@end
