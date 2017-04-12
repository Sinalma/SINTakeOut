//
//  AppDelegate.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "AppDelegate.h"

#import "SINTabBarController.h"
#import "SINLoginViewController.h"

#import <SMS_SDK/SMSSDK.h>

/**
 1.短信登录功能
 2.存储账号密码、店铺信息至数据库
 3.地图功能
 4.手势操作
 5.物理感应
 */

// APP KEY : 1ce79d24fa768
// App Secret : 02eb72bcdf47137ee49bbea374f657ad

#define AppKey @"1ce79d24fa768"
#define AppSecret @"02eb72bcdf47137ee49bbea374f657ad"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    self.window = [[UIWindow alloc] init];
    
    // 没有设置尺寸，会导致运行在真机时触摸事件不能传递
    self.window.frame = [UIScreen mainScreen].bounds;
    /**
      unexpected nil window in _UIApplicationHandleEventFromQueueEvent, _windowServerHitTestWindow: <UIWindow: 0x17663920; frame = (0 0; 0 0); gestureRecognizers = <NSArray: 0x176641c0>; layer = <UIWindowLayer: 0x17663b30>>
     */
//    SINLoginViewController *LOGINVC = [[SINLoginViewController alloc] init];
//    UINavigationController *NAVIVC = [[UINavigationController alloc] initWithRootViewController:LOGINVC];
//    self.window.rootViewController = NAVIVC;
    
    self.window.rootViewController = [[SINTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 短信验证功能
    [SMSSDK registerApp:AppKey withSecret:AppSecret];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    NSString *str = [[url.absoluteString componentsSeparatedByString:@"?"] lastObject];
    self.pwdStr = str;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PasswordNotiName object:str];
    if ([self.pwdDelegate performSelector:@selector(fullPassword:)]) {
        [self.pwdDelegate fullPassword:str];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
