//
//  SINWallet.h
//  SinWaiMai
//
//  Created by apple on 03/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SINWalletTitle;

@interface SINWallet : NSObject

/** 是否显示钱包 */
// 1
@property (nonatomic,strong) NSString *is_show_baiduWallet;

/** 钱包内内容子控件 */
// 存放SINWalletItem模型数组
@property (nonatomic,strong) NSArray *list;

/** 钱包模块标题内容 */
// SINWalletTitle模型
@property (nonatomic,strong) SINWalletTitle *title;

+ (instancetype)walletWithDict:(NSDictionary *)dict;

@end
