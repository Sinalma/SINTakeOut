//
//  SINWalletItem.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWalletItem.h"

@implementation SINWalletItem

+ (instancetype)walletItemWithDict:(NSDictionary *)dict
{
    SINWalletItem *item = [[SINWalletItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    return item;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
