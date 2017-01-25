//
//  SINUserCenterItem.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINUserCenterItem.h"

@implementation SINUserCenterItem

+ (instancetype)userCenterItemWithDict:(NSDictionary *)dict
{
    SINUserCenterItem *item = [[SINUserCenterItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
