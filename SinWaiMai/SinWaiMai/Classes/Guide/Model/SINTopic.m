//
//  SINTopic.m
//  SinWaiMai
//
//  Created by apple on 06/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINTopic.h"

@implementation SINTopic

+ (instancetype)topicWithDict:(NSDictionary *)dict
{
    SINTopic *topic = [[SINTopic alloc] init];
    
    [topic setValuesForKeysWithDictionary:dict];
    
    return topic;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
