//
//  SINConst.h
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  这个类用来定义常量

#import <UIKit/UIKit.h>

/** 全局颜色rgb */
#define SINGobalColor [UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0]

/** 屏幕宽高 */
#define SINScreenW [UIScreen mainScreen].bounds.size.width
#define SINScreenH [UIScreen mainScreen].bounds.size.height

/** 首页 - 广告模块的高度 */
UIKIT_EXTERN CGFloat const HomepageAdHeight;
/** 首页 - 外卖类型模块的高度 */
UIKIT_EXTERN CGFloat const HomepageWmTypeHeight;
/** 首页 - 新人专享模块的高度 */
UIKIT_EXTERN CGFloat const HomepageNewUserHeight;
/** 首页 - 第二模块的高度 */
UIKIT_EXTERN CGFloat const HomepageTwoModuleHeight;
/** 首页 - 第三模块的高度 */
UIKIT_EXTERN CGFloat const HomepageThirdModuleHeight;
/** 商户 - 保存优惠信息图标地址的数组 */
UIKIT_EXTERN NSString const *ShoppeWelfareIconUrlFilePath;
