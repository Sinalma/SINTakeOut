//
//  SINWMType.m
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWMType.h"

@implementation SINWMType

+ (instancetype)wMTypeWithDict:(NSDictionary *)dict
{
    SINWMType *type = [[SINWMType alloc] init];
    
    [type setValuesForKeysWithDictionary:dict];
    
    return type;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
