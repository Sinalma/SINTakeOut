//
//  SINWalletTitle.m
//  SinWaiMai
//
//  Created by apple on 03/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWalletTitle.h"

@implementation SINWalletTitle

+ (instancetype)walletTitleWithDict:(NSDictionary *)dict
{
    SINWalletTitle *title = [[SINWalletTitle alloc] init];
    
    [title setValuesForKeysWithDictionary:dict];
    
    return title;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
