//
//  SINShoppeInfo.m
//  SinWaiMai
//
//  Created by apple on 29/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShoppeInfo.h"

@implementation SINShoppeInfo

+ (instancetype)shoppeInfoWithDict:(NSDictionary *)dict
{
    SINShoppeInfo *shoppeInfo = [[SINShoppeInfo alloc] init];
    
    [shoppeInfo setValuesForKeysWithDictionary:dict];
    
    return shoppeInfo;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.title_name];
}

@end
