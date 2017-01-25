//
//  SINWalletItem.h
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  关于余额的模型

#import <Foundation/Foundation.h>

@interface SINWalletItem : NSObject

/** 图标 */
@property (nonatomic,strong) NSString *icon;

/** 名称 */
@property (nonatomic,strong) NSString *name;

/** 地址 */
// bdwm://native?pageName=bdwallet&ios_type=3&ios_link_addr=107&android_type=3&android_link_addr=8192
@property (nonatomic,strong) NSString *url;


+ (instancetype)walletItemWithDict:(NSDictionary *)dict;

@end
