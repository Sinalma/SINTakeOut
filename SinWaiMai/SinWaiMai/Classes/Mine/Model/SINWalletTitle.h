//
//  SINWalletTitle.h
//  SinWaiMai
//
//  Created by apple on 03/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  我的界面->钱包模块标题模型

#import <Foundation/Foundation.h>



@interface SINWalletTitle : NSObject

/** 标题名称 */
@property (nonatomic,strong) NSString *title_name;

/** 标题图标url */
// http://co.baifubao.com/content/mywallet/ios/home/icon_logo_2x.png
@property (nonatomic,strong) NSString *title_icon;

/** 消息 */
// 官方推荐支付方式
@property (nonatomic,strong) NSString *discount_msg;

/** 是否显示这个消息 */
// 1
@property (nonatomic,strong) NSString *is_show_discount_msg;

/** 标题弹出的url */
// bdwm://native?pageName=bdwallet&ios_type=3&ios_link_addr=100&android_type=3&android_link_addr=16384
@property (nonatomic,strong) NSString *url;


+ (instancetype)walletTitleWithDict:(NSDictionary *)dict;

@end
