//
//  NSString+Category.m
//  SinWaiMai
//
//  Created by apple on 18/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

/**
 * 保留一位小数，四舍五入，返回一个字符串
 */
+ (instancetype)accurateCalculationWithDecimal:(double)decimal
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber* decimalObj = [[NSDecimalNumber alloc] initWithDouble:decimal];
    NSNumber* ratio = [decimalObj decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",ratio];
}

@end
