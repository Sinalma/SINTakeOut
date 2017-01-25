//
//  SINUserCenterItem.h
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  用户界面的服务

#import <Foundation/Foundation.h>

@interface SINUserCenterItem : NSObject

/** 描述 */
@property (nonatomic,strong) NSString *desc;

/** 图标地址 */
@property (nonatomic,strong) NSString *icon;

/** 名称 */
@property (nonatomic,strong) NSString *name;

/** 类型 */
@property (nonatomic,strong) NSString *type;

/** 点击链接 */
@property (nonatomic,strong) NSString *url;

+ (instancetype)userCenterItemWithDict:(NSDictionary *)
dict;
@end
