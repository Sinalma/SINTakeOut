//
//  SINAddress.h
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINAddress : NSObject

/** 地址 */
@property (nonatomic,strong) NSString *address;

/** 城市id */
@property (nonatomic,strong) NSString *city_id;

/** 城市名 */
@property (nonatomic,strong) NSString *city_name;

/** lat */
@property (nonatomic,strong) NSString *lat;

/** lng */
@property (nonatomic,strong) NSString *lng;

+ (instancetype)addressWithDict:(NSDictionary *)dict;

@end
