//
//  SINShoppe.m
//  SinWaiMai
//
//  Created by apple on 18/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShoppe.h"

@implementation SINShoppe

+ (instancetype)shoppeWithDict:(NSDictionary *)dict
{
    SINShoppe *shoppe = [[SINShoppe alloc] init];
    
    [shoppe setValuesForKeysWithDictionary:dict];
    
    return shoppe;
}

- (void)setLogo_url:(NSString *)logo_url
{
    _logo_url = [logo_url componentsSeparatedByString:@"@"][0];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@",_shop_name,_logo_url];
}
@end
