//
//  SINUserInfo.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINUserInfo.h"

@implementation SINUserInfo

+ (instancetype)userInfoWithDict:(NSDictionary *)dict
{
    SINUserInfo *info = [[SINUserInfo alloc] init];
    
    [info setValuesForKeysWithDictionary:dict];
    
    return info;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
