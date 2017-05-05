//
//  SINShopCarView.h
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  购物车提示view

#import <UIKit/UIKit.h>
@class SINShoppeInfo;

@protocol SINCarOverviewDelegate <NSObject>

@required
- (void)showOverviewWithFoodes:(NSArray *)foodes;
- (void)hideOverview;
@end

@interface SINShopCarView : UIView

@property (nonatomic,weak) id<SINCarOverviewDelegate> delegate;

@property (nonatomic,strong) SINShoppeInfo *shopInfo;

+ (instancetype)shopCarView;
- (void)showOrHideOverview;
@end
