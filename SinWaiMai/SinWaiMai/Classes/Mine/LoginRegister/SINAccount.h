//
//  SINAccount.h
//  SinWaiMai
//
//  Created by apple on 14/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINAccount : NSObject

/** 用户是否登录 */
@property (nonatomic,assign) BOOL isLogin;

@property(nonatomic,strong) NSString *pwd;

@property(nonatomic,strong) NSString *account;

+ (instancetype)sharedAccount;

- (void)jumpLoginVc;

- (void)isJumpToLoginVc;

- (BOOL)registerWithAccount:(NSString *)acc password:(NSString *)pwd;

- (BOOL)verifyWithAccount:(NSString *)account pwd:(NSString *)pwd;

- (BOOL)viewJumpToLoginVc;

@end
