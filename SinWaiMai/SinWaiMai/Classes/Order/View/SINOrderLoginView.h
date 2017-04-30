//
//  SINOrderLoginView.h
//  SinWaiMai
//
//  Created by apple on 04/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SINOrderLoginViewDelegate <NSObject>

@optional
/** 回调控制器弹出登录/注册控制器 */
- (void)loginRegisterBtnClick;

@end

@interface SINOrderLoginView : UIView

@property (nonatomic,weak) id<SINOrderLoginViewDelegate> delegate;

+ (instancetype)orderLoginView;
- (void)stopImgAnimation;
- (void)startImgVAnimation;

@end
