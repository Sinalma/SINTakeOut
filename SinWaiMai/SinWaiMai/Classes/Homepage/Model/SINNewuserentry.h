//
//  SINNewuserentry.h
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  新用户专享界面模型

#import <Foundation/Foundation.h>

@interface SINNewuserentry : NSObject

/** 图片地址 */
@property (nonatomic,strong) NSString *icon;

/** 标题 */
@property (nonatomic,strong) NSString *title;

/** 子标题 */
@property (nonatomic,strong) NSString *sub_title;

/** 链接 */
@property (nonatomic,strong) NSString *target_url;

+ (instancetype)newuserentryWithDict:(NSDictionary *)dict;

@end
