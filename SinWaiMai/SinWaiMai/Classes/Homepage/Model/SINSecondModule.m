//
//  SINSecondModule.m
//  SinWaiMai
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSecondModule.h"

@implementation SINSecondModule

+ (instancetype)secondModuleWithDict:(NSDictionary *)dict
{
    SINSecondModule *sm = [[SINSecondModule alloc] init];
    
    [sm setValuesForKeysWithDictionary:dict];
    
    return sm;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
