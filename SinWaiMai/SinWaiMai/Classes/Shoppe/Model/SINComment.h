//
//  SINComment.h
//  SinWaiMai
//
//  Created by apple on 13/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  单个用户评价信息

#import <Foundation/Foundation.h>

@interface SINComment : NSObject

/** 未知属性  参数中出现 */
@property (nonatomic,strong) NSString *aoi_id;

/** 订单时间 */
@property (nonatomic,strong) NSString *audit_time;

/** 未知属性 cal_score : 3 */
@property (nonatomic,strong) NSString *cal_score;

/** 评论id */
@property (nonatomic,strong) NSString *comment_id;

/** 未知属性 */
@property (nonatomic,strong) NSString *comment_label_ids;

/** 存放字典标签数组 - 字典内 content : 保存完好 */
@property (nonatomic,strong) NSArray *comment_labels;

/** 存放字典点赞食物数组 - 字典内 dish_name : 净云吞_干捞云吞 */
@property (nonatomic,strong) NSArray *recommend_dishes;

/** 评论内容 */
@property (nonatomic,strong) NSString *content;

/** 送达时长 分钟 */
@property (nonatomic,strong) NSString *cost_time;

/** 订单创建时间 和audit_time可能相同 */
@property (nonatomic,strong) NSString *create_time;

/** 未知属性 */
@property (nonatomic,strong) NSString *dish_score;

/** 订单id */
@property (nonatomic,strong) NSString *order_id;

/** 用户名 */
@property (nonatomic,strong) NSString *pass_name;

/** 用户uid */
@property (nonatomic,strong) NSString *pass_uid;

/** 
 未知url
 http://webmap1.map.bdimg.com/maps/services/thumbnails?align=middle,middle&width=<wm[width]wm>&height=<wm[height]wm>&quality=80&src=http%3A%2F%2Fhimg.baidu.com%2Fsys%2Fportrait%2Fitem%2F5018db4c
 */
@property (nonatomic,strong) NSString *portrait_url;

// 重复的key在真机运行会报错
/** 点赞食物的数组-内为字典-字典内 dish_name : 咸鱼鸡粒炒饭_单点 */
//@property (nonatomic,strong) NSArray *recommend_dishes;

/** 商家回复内容 */
@property (nonatomic,strong) NSString *reply_content;

/** 商家回复时间 */
@property (nonatomic,strong) NSString *reply_create_time;

/** 商家回复id */
@property (nonatomic,strong) NSString *reply_id;

/** 用户为商品评分 用户星星 */
@property (nonatomic,strong) NSString *score;

/** 配送服务评分 用于文字星 */
@property (nonatomic,strong) NSString *service_score;

/** 未知属性  sfrom : na-android*/
@property (nonatomic,strong) NSString *sfrom;

/** 商户名 */
@property (nonatomic,strong) NSString *shop_name;

/** 未知 可能是来源 source_name : baidu*/
@property (nonatomic,strong) NSString *source_name;

/** 未知属性 waimai_release_id : 1613093415*/
@property (nonatomic,strong) NSString *waimai_release_id;

+ (instancetype)commentWithDict:(NSDictionary *)dict;

@end
