//
//  SINWaveView.h
//  SinWaiMai
//
//  Created by apple on 05/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SINWaveBlock)(CGFloat currentY);

@interface SINWaveView : UIView

/** 浪弯曲度 */
@property (nonatomic,assign) CGFloat waveCurvature;
/** 浪速 */
@property (nonatomic,assign) CGFloat waveSpeed;
/** 浪高 */
@property (nonatomic,assign) CGFloat waveHeight;
/** 实浪颜色 */
@property (nonatomic,strong) UIColor *realWaveColor;
/** 遮罩浪颜色 */
@property (nonatomic,strong) UIColor *maskWaveColor;
/** 回调 */
@property (nonatomic,copy) SINWaveBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;
@end
