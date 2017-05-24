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
// Mob 短信验证SDK
#import <SMS_SDK/SMSSDK.h>
// Mob 分享SDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//新浪微博SDK头文件
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "WeiboSDK.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

// SMS (Mob Message )
#define MobSMSAppKey @"1ce79d24fa768"
#define MobSMSAppSecret @"02eb72bcdf47137ee49bbea374f657ad"

// Share (Mob Share)
#define MobShareAppKey @"1ceb10ada271b"
#define MobShareAppSecret @"7955fcc5d11ee81b886a8295b185eac9"

// Sina
#define SinaAppKey @"3566302707"
#define SinaAppSecret @"3217c2bf6f35b65943495bf2977dec64"

// Map (Baidu)
#define BaiduMapAppKey @"fxKMYO8psq28cGeOc6C4tIoqAoisqUxS"
#define BaiduMapAppSecret @"dO2aIcWNvjKhRaM1fQKjypp3lNOLvkHe"

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
    
    self.window.rootViewController = [[SINTabBarController alloc] init];
//    [self chooseRootVC];
    
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 短信验证
    [SMSSDK registerApp:MobSMSAppKey withSecret:MobSMSAppSecret];
    
    // 分享
    [self share];
    
    // 百度地图
    [self baiduMap];
    
    return YES;
}

- (void)baiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduMapAppKey  generalDelegate:nil];
    if (!ret) {
        SINLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
}

- (void)share
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformTypeMail), 
//                            @(SSDKPlatformTypeSMS),
//                            @(SSDKPlatformTypeCopy),
//                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeRenren),
//                            @(SSDKPlatformTypeGooglePlus)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                  break;
                 
                 //初始化的import参数注意要链接原生新浪微博SDK。
                          case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectRenren:[RennClient class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:SinaAppKey appSecret:SinaAppSecret redirectUri:@"http://www.sharesdk.cn"authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
//                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
//                 break;
//             case SSDKPlatformTypeRenren:
//                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
//                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                               authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeGooglePlus:
//                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                            redirectUri:@"http://localhost"];
//                 break;
             default:
                 break;
         }
     }];
}

- (void)chooseRootVC
{
    if ([self isNewUpdate]) {
        self.window.rootViewController = [[SINTabBarController alloc] init];
    }else
    {
        // 新版本引导界面
    }
}

- (BOOL)isNewUpdate
{
    // 当前版本
    NSString *curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 本地储存版本
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    
    if ([curVersion compare:sanboxVersion] == NSOrderedDescending) {
        
        [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:@"CFBundleShortVersionString"];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *str = [[url.absoluteString componentsSeparatedByString:@"?"] lastObject];
    self.pwdStr = str;
    
    [SINNotificationCenter postNotificationName:PasswordNotiName object:str];
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
