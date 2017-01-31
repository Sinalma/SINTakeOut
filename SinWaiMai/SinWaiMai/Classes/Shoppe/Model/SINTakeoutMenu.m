//
//  SINTakeoutMenu.m
//  SinWaiMai
//
//  Created by apple on 30/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINTakeoutMenu.h"

@implementation SINTakeoutMenu

+ (instancetype)takeoutMenuWithDict:(NSDictionary *)dict
{
    SINTakeoutMenu *menu = [[SINTakeoutMenu alloc] init];
    
    [menu setValuesForKeysWithDictionary:dict];
    
    return menu;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
