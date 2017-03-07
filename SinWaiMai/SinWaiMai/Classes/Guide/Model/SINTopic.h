//
//  SINTopic.h
//  SinWaiMai
//
//  Created by apple on 06/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  指南 - 段子模型

#import <Foundation/Foundation.h>

@interface SINTopic : NSObject

// 未知
/** 类似标题 */
@property (nonatomic,strong) NSString *abstract;

/**  */
// 1
@property (nonatomic,strong) NSString *audit_status;

/** 类型id */
@property (nonatomic,strong) NSString *category_id;

/** 类型名 */
@property (nonatomic,strong) NSString *category_name;

/** 内容id */
@property (nonatomic,strong) NSString *content_id;

/** 是否显示 */
// 0
@property (nonatomic,strong) NSString *content_is_show;

/** id 未知 - 1482141269740752277*/
@property (nonatomic,strong) NSString *coop_id;

/** name 未知 - 腾讯新闻*/
@property (nonatomic,strong) NSString *coop_name;

/** 点击段子跳转到内容细节url 
 *  http://op.inews.qq.com/m/JIA2017030601409900?refer=100000101&chl_code=jia360&h=0
 */
@property (nonatomic,strong) NSString *detail;

/** 收藏状态 - 0  */
@property (nonatomic,strong) NSString *favorite_status;

/** 视频 - null  */
@property (nonatomic,strong) NSString *head_video;

/** 段子图片 
 *  http://img.waimai.baidu.com/pc/a2c6f0a91b3227d52c4f6ff8706e2ec392
 */
@property (nonatomic,strong) NSString *image;

/** is_exclusive - 未知 */
@property (nonatomic,strong) NSString *is_exclusive;

/** is_self - 未知 */
@property (nonatomic,strong) NSString *is_self;

/** 点赞数 */
@property (nonatomic,strong) NSNumber *praise_num;

/** 发布id */
@property (nonatomic,strong) NSString *release_time;

/** show_big_image - 未知 - 0 */
@property (nonatomic,strong) NSString *show_big_image;

/** show_item_tag - 未知 */
@property (nonatomic,strong) NSNumber *show_item_tag;

/** show_shop_tag - 未知 */
@property (nonatomic,strong) NSNumber *show_shop_tag;

/** 来源 - 腾讯家居*/
@property (nonatomic,strong) NSString *source;

/** 来源key */
@property (nonatomic,strong) NSString *source_key;

/** source_time - 1488783626 */
@property (nonatomic,strong) NSString *source_time;

/** 子标题 */
@property (nonatomic,strong) NSString *sub_title;

/** 主题名 - 时尚圈*/
@property (nonatomic,strong) NSString *theme;

/** 主题id - 1479994417740697991*/
@property (nonatomic,strong) NSString *theme_id;

/** 主题logo url 
 *  http://img.waimai.baidu.com/pb/72e9477c0d393aab9b2452164346912c13
 */
@property (nonatomic,strong) NSString *theme_logo;

/** 标题 */
@property (nonatomic,strong) NSString *title;

/** 未知 - 内容的段子没有，顶部段子有 */
@property (nonatomic,strong) NSDictionary *content_top;

+ (instancetype)topicWithDict:(NSDictionary *)dict;

@end
