//
//  SINNewuserentry.m
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINNewuserentry.h"

@implementation SINNewuserentry

+ (instancetype)newuserentryWithDict:(NSDictionary *)dict
{
    SINNewuserentry *entry = [[SINNewuserentry alloc] init];
    
    
    [entry setValuesForKeysWithDictionary:dict];
    
    return entry;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

@end
