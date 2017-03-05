//
//  SINWallet.m
//  SinWaiMai
//
//  Created by apple on 03/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWallet.h"
#import "SINWalletItem.h"
#import "SINWalletTitle.h"

@implementation SINWallet

+ (instancetype)walletWithDict:(NSDictionary *)dict
{
    SINWallet *wallet = [[SINWallet alloc] init];
    
    [wallet setValuesForKeysWithDictionary:dict];
    
    return wallet;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        
        NSMutableArray *listArrM = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            SINWalletItem *item = [SINWalletItem walletItemWithDict:dict];
            [listArrM addObject:item];
        }
//        value = listArrM;
        self.list = listArrM;
        
    }else if ([key isEqualToString:@"title"])
    {
        SINWalletTitle *title = [SINWalletTitle walletTitleWithDict:value];
//        value = title;
        self.title = title;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
