//
//  SINCycleView.h
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINCycleView;

@protocol SINCycleViewDelegate <NSObject>

@optional
/** 点击图片时跳用代理方法 */
- (void)cycleView:(SINCycleView *)cycleView didClickImageAtIndex:(int)index;

@end

@interface SINCycleView : UIView

@property (nonatomic,weak) id<SINCycleViewDelegate> delegate;
/** 分页标识符是否隐藏 */
@property (nonatomic,assign) BOOL isHidePageControl;
/** 本地图片名数组 */
@property (nonatomic,strong) NSArray *imageNames;
/** 网络图片url数组 */
@property (nonatomic,strong) NSArray *imageUrls;
/** 图片切换时间,默认为3秒 */
@property (nonatomic,assign) CGFloat cycleInterval;

/** 开始图片轮播定时器 */
- (void)startCycleTimer;

/** 关闭图片轮播定时器 */
- (void)stopCycleTimer;

@end
