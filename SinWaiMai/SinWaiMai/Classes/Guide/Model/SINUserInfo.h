//
//  SINUserInfo.h
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  用户基本信息模型

#import <Foundation/Foundation.h>

@interface SINUserInfo : NSObject

/** 数量 */
@property (nonatomic,strong) NSString *amount;

/** 名称 */
@property (nonatomic,strong) NSString *name;

/** 类型 */
@property (nonatomic,strong) NSString *type;

/** 单位 */
@property (nonatomic,strong) NSString *unit;

/** url */
// bdwm://native?pageName=coupon
@property (nonatomic,strong) NSString *url;

/** is_new */
// 未知属性
@property (nonatomic,strong) NSString *is_new;


+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
@end
