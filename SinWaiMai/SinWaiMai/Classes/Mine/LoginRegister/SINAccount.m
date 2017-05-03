//
//  SINAccount.m
//  SinWaiMai
//
//  Created by apple on 14/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

/**
 * if user register account successful,save user account and password to database.
 * if user is login,verify account and password,return result of Bool.
 */

#import "SINAccount.h"
#import "SINLoginViewController.h"

#define AccPwdDictNameKey @"accPwdDict.plist"
#define AccountKey @"account"
#define PasswordKey @"password"

// 登录验证状态
typedef enum : NSUInteger {
    KAccountNotRegister,
    KAccountPwdWrong,
    KAccountCorrect,
} AccountVerify;

@interface SINAccount ()

/** 保存 */
@property (nonatomic,strong) NSMutableDictionary *accPwdDict;

@end

@implementation SINAccount

static SINAccount *_account;

- (NSMutableDictionary *)accPwdDict
{
    if (_accPwdDict==nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[AccPwdDictNameKey cachePath]];
        _accPwdDict = dict;
    }
    return _accPwdDict;
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    
    SINLog(@"登录%d",_isLogin);
}

- (void)jumpLoginVc
{
    SINLoginViewController *loginVC = [[SINLoginViewController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:nil];
}

/**
 * 是否跳转至登录界面
 */
- (void)isJumpToLoginVc
{
    if (!self.isLogin) {
        [self jumpLoginVc];
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _account = [super allocWithZone:zone];
    });
    return _account;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _account;
}

+ (instancetype)sharedAccount
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _account = [[self alloc] init];
    });
    return _account;
}

/**
 * 注册
 */
- (BOOL)registerWithAccount:(NSString *)acc password:(NSString *)pwd
{
    __block BOOL bol = NO;
    [UIView animateWithDuration:1.0 animations:^{
        
        NSDictionary *dict = @{AccountKey : acc,PasswordKey : pwd};
         bol = [dict writeToFile:[AccPwdDictNameKey cachePath] atomically:YES];
        
    }];
    return bol;
}

/**
 * 验证账号密码
 */
- (BOOL)verifyWithAccount:(NSString *)account pwd:(NSString *)pwd
{
    __block BOOL bol = NO;
    if (self.accPwdDict[AccountKey]){
    
    [UIView animateWithDuration:1.0 animations:^{
        
        if (self.accPwdDict[PasswordKey] == pwd) bol = YES;
    }];
    }
    
    return bol;
}

@end
