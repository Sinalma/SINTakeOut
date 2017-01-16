//
//  SINGobalScrollView.m
//  SinWaiMai
//
//  Created by apple on 15/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINGobalScrollView.h"

@interface SINGobalScrollView () <UIScrollViewDelegate>



@end

@implementation SINGobalScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.delaysContentTouches = NO;
        self.delegate = self;
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    // 获取一个UITouch
    UITouch *touch = [touches anyObject];
    // 获取当前的位置
    CGPoint current = [touch locationInView:self];
    CGFloat y = 300;
    if (current.y >= y+ 10) {
        //在地图上
        NSLog(@"滚动整体scrollView");
        return YES;
    } else {
        return [super touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}

-  (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:NSClassFromString(@"UIScrollView")]) {
        NSLog(@"滚动了UIScrollView");
        //在地图上返回NO
        return NO;
    } else {
        return [super touchesShouldCancelInContentView:view];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating->%@",scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating->%@",scrollView);
}
@end
