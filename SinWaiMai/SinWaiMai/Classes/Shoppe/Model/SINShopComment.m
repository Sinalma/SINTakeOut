//
//  SINShopComment.m
//  
//
//  Created by apple on 13/02/2017.
//
//

#import "SINShopComment.h"

@implementation SINShopComment

+ (instancetype)shopCommentWithDict:(NSDictionary *)dict
{
    SINShopComment *shopComment = [[SINShopComment alloc] init];
    
    [shopComment setValuesForKeysWithDictionary:dict];
    
    return shopComment;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
