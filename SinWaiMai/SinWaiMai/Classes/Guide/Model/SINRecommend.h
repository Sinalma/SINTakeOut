//
//  SINRecommend.h
//  SinWaiMai
//
//  Created by apple on 06/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINRecommend : NSObject

/** id */
@property (nonatomic,strong) NSString *commend_id;

/** 图片url */
@property (nonatomic,strong) NSString *commend_picture;

/** 类型 */
@property (nonatomic,strong) NSString *commend_type;

/** 标题 */
@property (nonatomic,strong) NSString *title;

/** 细节 - 数组 - 内容未知*/
@property (nonatomic,strong) NSArray *commend_detail;

+ (instancetype)recommendWithDict:(NSDictionary *)dict;

@end
