//
//  SINThrowView.m
//  SinWaiMai
//
//  Created by apple on 04/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINThrowView.h"

#define BaseTime 1.0
#define BaseSpace 300.0

@interface SINThrowView () <CAAnimationDelegate>

@property (nonatomic,strong) CABasicAnimation *rotationAnim;

@property (nonatomic,strong) CAKeyframeAnimation *positionAnim;

@end
@implementation SINThrowView
- (void)throwToPoint:(CGPoint)point completion:(completionBlock)completion
{
    self.completion = completion;
    
    // 创建抛物线
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 起点
    [path moveToPoint:self.center];
    
    CGFloat controlX = point.x;
    CGFloat controlY = self.center.y;
    //抛物线的控制点
    CGPoint controlPoint = CGPointMake(controlX, controlY);
    [path addQuadCurveToPoint:point controlPoint:controlPoint];
    
    // 物品和购物车的直线距离
    CGFloat space = sqrt((point.x-self.center.x) * (point.x-self.center.x) + (point.y-self.center.y) * (point.y-self.center.y));
    
    // 根据直线距离更改动画时间
    CGFloat duration = self.timeRatio ? space/BaseSpace*BaseTime*self.timeRatio:space/BaseSpace*BaseTime;
    
    // 抛物动画
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animation];
    positionAnim.keyPath = @"position";
    positionAnim.path = path.CGPath;
    positionAnim.duration = duration;
    positionAnim.repeatCount = 1;
    
    // 组动画
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    groupAnim.delegate = self;
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.duration = duration;
    groupAnim.animations = @[positionAnim,self.rotationAnim];
    [self.layer addAnimation:groupAnim forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 动画执行结束移除view
    [self removeFromSuperview];
    
//    if (self.completion) {
        self.completion();
//    }
}

- (CABasicAnimation *)rotationAnim
{
    if (!_rotationAnim) {
        // 旋转动画
        _rotationAnim = [CABasicAnimation animation];
        _rotationAnim.keyPath = @"transform.rotation";
        _rotationAnim.fromValue = @0;
        _rotationAnim.toValue = @(M_PI * 2);
        _rotationAnim.repeatCount = MAXFLOAT;
        _rotationAnim.duration = 0.28;
    }
    return _rotationAnim;
}

@end
