//
//  SINFood.m
//  SinWaiMai
//
//  Created by apple on 30/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINFood.h"

@implementation SINFood

+ (instancetype)foodWithDict:(NSDictionary *)dict
{
    SINFood *food = [[SINFood alloc] init];
    
    [food setValuesForKeysWithDictionary:dict];
    
    return food;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 改key名
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
        return;
    }
}




@end
