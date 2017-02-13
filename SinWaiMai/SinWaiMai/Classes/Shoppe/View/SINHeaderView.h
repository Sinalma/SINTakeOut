//
//  SINHeaderView.h
//  SinWaiMai
//
//  Created by apple on 12/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINShopComment;

@interface SINHeaderView : UIView

/** 模型 */
@property (nonatomic,strong) SINShopComment *shopComment;

+ (instancetype)headerView;

@end
