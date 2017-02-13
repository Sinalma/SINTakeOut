//
//  SINComment.m
//  SinWaiMai
//
//  Created by apple on 13/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINComment.h"

@implementation SINComment

+ (instancetype)commentWithDict:(NSDictionary *)dict
{
    SINComment *comment = [[SINComment alloc] init];
    
    [comment setValuesForKeysWithDictionary:dict];
    
    return comment;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
