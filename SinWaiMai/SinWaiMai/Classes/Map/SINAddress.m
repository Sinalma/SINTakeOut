//
//  SINAddress.m
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAddress.h"

@implementation SINAddress

+ (instancetype)addressWithDict:(NSDictionary *)dict
{
    SINAddress *address = [[SINAddress alloc] init];
    
    [address setValuesForKeysWithDictionary:dict];
    
    return address;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
