//
//  SINRecommend.m
//  SinWaiMai
//
//  Created by apple on 06/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINRecommend.h"

@implementation SINRecommend

+ (instancetype)recommendWithDict:(NSDictionary *)dict
{
    SINRecommend *recommend = [[SINRecommend alloc] init];
    
    [recommend setValuesForKeysWithDictionary:dict];
    
    return recommend;
}

@end
