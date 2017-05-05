//
//  SINThrowView.h
//  SinWaiMai
//
//  Created by apple on 04/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  抛物线动画

#import <UIKit/UIKit.h>

typedef  void(^completionBlock)(void);

@interface SINThrowView : UIImageView

@property (nonatomic,strong) completionBlock completion;

- (void)throwToPoint:(CGPoint)point completion:(completionBlock)completion;

/** 时间系数，值越大动画时间越长 */
@property (nonatomic,assign) CGFloat timeRatio;

@end
