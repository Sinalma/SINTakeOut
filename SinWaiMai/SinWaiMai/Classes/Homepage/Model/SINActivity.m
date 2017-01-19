//
//  SINActivity.m
//  SinWaiMai
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINActivity.h"

@implementation SINActivity

+ (instancetype)activityWithDict:(NSDictionary *)dict
{
    SINActivity *sm = [[SINActivity alloc] init];
    
    [sm setValuesForKeysWithDictionary:dict];
    
    return sm;
}

- (void)setHead_icon:(NSString *)head_icon
{
    _head_icon = [head_icon componentsSeparatedByString:@"@"][0];
}

- (void)setImg_url:(NSString *)img_url
{
    _img_url = [img_url componentsSeparatedByString:@"@"][0];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
