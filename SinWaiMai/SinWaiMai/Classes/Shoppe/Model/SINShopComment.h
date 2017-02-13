//
//  SINShopComment.h
//  
//
//  Created by apple on 13/02/2017.
//
//  商户评价相关信息

#import <Foundation/Foundation.h>

@interface SINShopComment : NSObject

/** 评分 */
@property (nonatomic,strong) NSString *average_dish_score;

/** 配送服务评分 */
@property (nonatomic,strong) NSString *average_service_score;

/** 总评价数 */
@property (nonatomic,strong) NSString *comment_num;

/** 好评数 */
@property (nonatomic,strong) NSString *good_comment_num;

/** 中评数 */
@property (nonatomic,strong) NSString *medium_comment_num;

/** 差评数 */
@property (nonatomic,strong) NSString *bad_comment_num;

/** 是否收藏 */
@property (nonatomic,strong) NSString *is_favorite;

/** 内容不为空的评价数 */
@property (nonatomic,strong) NSString *noempty_comment_num;

/** 未知属性 */
@property (nonatomic,strong) NSString *release_id;

// 1088 227 28 18
@property (nonatomic,strong) NSArray *score_detail;

// 嵌套模型
/**
 评论类型标签
 * content 内容 : 味道赞
 * label_count : 189
 * label_id : 18
 */
@property (nonatomic,strong) NSArray *labels;

/**
 未知属性数组
 * count : 1
 * name : 牛肉干炒河粉
 */
@property (nonatomic,strong) NSArray *recommend_dishes;

/** 用户评论细节数组 */
@property (nonatomic,strong) NSArray *shopcomment_list;


/**
 周评分字典
 * last_one_week : 4.4
 * last_three_week : 0
 * last_two_week : 4.5
 */
@property (nonatomic,strong) NSDictionary *weeks_score;

+ (instancetype)shopCommentWithDict:(NSDictionary *)dict;

@end
