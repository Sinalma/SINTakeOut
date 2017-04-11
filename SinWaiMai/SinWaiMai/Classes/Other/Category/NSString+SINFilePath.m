//
//  NSString+SINFilePath.m
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "NSString+SINFilePath.h"

@implementation NSString (SINFilePath)

- (NSString *)cachePath
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:self];
    
    return filePath;
}



@end
