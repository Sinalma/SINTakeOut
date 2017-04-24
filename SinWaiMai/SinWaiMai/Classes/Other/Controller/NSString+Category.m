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

// 判断一个路径是文件夹 or 文件
//    [[mgr attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeDirectory];

- (NSInteger)fileSize
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 这个路径是否存在
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 路径不存在
    if (exists == NO) return 0;
    
    if (isDirectory) { // 文件夹
        // 总大小
        NSInteger size = 0;
        // 获得文件夹中的所有内容
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 获得文件属性
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return size;
    } else { // 文件
        return [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
}


@end
