//
//  SINWMType.h
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINWMType : NSObject

/** 名称 */
@property (nonatomic,strong) NSString *name;

/** 图标地址 */
@property (nonatomic,strong) NSString *pic;

/** 进入后商户的总个数 */
@property (nonatomic,assign) int *total_count;

/** 活动标志图片地址 */
@property (nonatomic,strong) NSString *img_url;


+ (instancetype)wMTypeWithDict:(NSDictionary *)dict;
@end
