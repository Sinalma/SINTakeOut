//
//  SINWelfare.h
//  SinWaiMai
//
//  Created by apple on 18/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  福利

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KWelfareXin,
    KWelfareOvertimepayment ,
    KWelfareBright_kitchen
} WelfareType;

@interface SINWelfare : NSObject

/** 福利信息 */
@property (nonatomic,strong) NSString *msg;

/** 福利类型 */
@property (nonatomic,strong) NSString *type;

@end
