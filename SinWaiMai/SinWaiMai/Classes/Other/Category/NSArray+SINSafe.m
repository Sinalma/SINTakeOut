
//
//  NSArray+SINSafe.m
//  SinWaiMai
//
//  Created by apple on 01/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "NSArray+SINSafe.h"

@implementation NSArray (SINSafe)

- (id)sin_safeObjectAtIndex:(NSUInteger)index
{
    if (self.count == 0) {
        SINLog(@"SIN_The mutable array have no object.");
        return (nil);
    }
    if (index > MAX(self.count - 1, 0)) {
        SINLog(@"SIN_Index:%li out of mutableArray range ---", (long)index);
        return (nil);
    }
    return [self objectAtIndex:index];
}

@end
