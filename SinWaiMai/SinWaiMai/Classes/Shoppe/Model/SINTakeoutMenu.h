//
//  SINTakeoutMenu.h
//  SinWaiMai
//
//  Created by apple on 30/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINTakeoutMenu : NSObject

/** 类型未选中图片url */
@property (nonatomic,strong) NSString *cate_pic_noselect;

/** 类型选中图片url */
@property (nonatomic,strong) NSString *cate_pic_select;

/** 类型模块名称 */
@property (nonatomic,strong) NSString *catalog;

/** 数据数组 */
@property (nonatomic,strong) NSArray *data;

+ (instancetype)takeoutMenuWithDict:(NSDictionary *)dict;

@end
