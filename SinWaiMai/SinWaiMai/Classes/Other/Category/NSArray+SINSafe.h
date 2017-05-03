//
//  NSArray+SINSafe.h
//  SinWaiMai
//
//  Created by apple on 01/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SINSafe)

/** 对数组操作进行安全检测，保证程序不挂 */
- (id)sin_safeObjectAtIndex:(NSUInteger)index;

@end
