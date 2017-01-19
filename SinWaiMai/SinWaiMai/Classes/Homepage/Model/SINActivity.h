//
//  SINActivity.h
//  SinWaiMai
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINActivity : NSObject
/** 活动名称 */
@property (nonatomic,strong) NSString *title;

/** 活动名称字体颜色 */
@property (nonatomic,strong) NSString *title_color;

/** 活动简介 */
@property (nonatomic,strong) NSString *desc;

/** 活动简介字体颜色 */
@property (nonatomic,strong) NSString *desc_color;

/** 顶部图片地址 */
@property (nonatomic,strong) NSString *head_icon;

/** 底部图片外层 */
@property (nonatomic,strong) NSString *spec_icon;

/** 底部图片内层 */
@property (nonatomic,strong) NSString *img_url;

+ (instancetype)activityWithDict:(NSDictionary *)dict;
@end
