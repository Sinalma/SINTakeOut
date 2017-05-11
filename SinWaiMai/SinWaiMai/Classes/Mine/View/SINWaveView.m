//
//  SINWaveView.m
//  SinWaiMai
//
//  Created by apple on 05/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWaveView.h"

@interface SINProxy : NSObject
@property (nonatomic,weak) id executor;
@end

@implementation SINProxy
- (void)callback
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [_executor performSelector:@selector(wave)];
#pragma clang diagnostic pop

}
@end

@interface SINWaveView ()
/** 刷屏器 */
@property (nonatomic,strong) CADisplayLink *timer;
/** 真实浪 */
@property (nonatomic,strong) CAShapeLayer *realWaveLayer;
/** 遮罩浪 */
@property (nonatomic,strong) CAShapeLayer *maskWaveLayer;
@property (nonatomic,assign) CGFloat offset;
@end

@implementation SINWaveView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.waveSpeed = 0.5;
    self.waveCurvature = 1.5;
    self.waveHeight = 4;
    self.realWaveColor = [UIColor whiteColor];
    self.maskWaveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer];
}

- (CAShapeLayer *)realWaveLayer
{
    if (!_realWaveLayer) {
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}

- (CAShapeLayer *)maskWaveLayer
{
    if (!_maskWaveLayer) {
        _maskWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer.frame = frame;
        _maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}

- (void)setWaveHeight:(CGFloat)waveHeight
{
    _waveHeight = waveHeight;
    
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height - self.waveHeight;
    frame.size.height = self.waveHeight;
    _realWaveLayer.frame = frame;
    
    CGRect frame1 = self.bounds;
    frame1.origin.y = frame1.size.height - self.waveHeight;
    frame1.size.height = self.waveHeight;
    _maskWaveLayer.frame = frame1;
}

- (void)startWaveAnimation
{
    SINProxy *proxy = [[SINProxy alloc] init];
    proxy.executor = self;
    self.timer = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(callback)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWaveAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave
{
    self.offset += self.waveSpeed;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;
    
    // 真浪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    
    // 遮罩浪
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathMoveToPoint(maskPath, NULL, 0, height);
    CGFloat maskY = 0.f;
    for (CGFloat x = 0.f; x <= width; x++) {
        y = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
        maskY = -y;
        CGPathAddLineToPoint(maskPath, NULL, x, maskY);
    }
    
    // 变化的中间y值
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGFloat centerY = height * sinf(0.01 * self.waveCurvature * centerX + self.offset * 0.045);
    if (self.waveBlock) {
        self.waveBlock(centerY);
    }
    
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.realWaveLayer.path = path;
    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskPath, NULL, width, height);
    CGPathAddLineToPoint(maskPath, NULL, 0, height);
    CGPathCloseSubpath(maskPath);
    self.maskWaveLayer.path = maskPath;
    self.maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskPath);
    
}

@end
