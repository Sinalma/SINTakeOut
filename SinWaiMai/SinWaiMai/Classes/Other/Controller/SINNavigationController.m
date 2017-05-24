//
//  SINNavigationController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINNavigationController.h"
#import "SINHomepageViewController.h"
#import "SINShoppeViewController.h"
#import "SINMineViewController.h"

@interface SINNavigationController ()
@end

@implementation SINNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    
    // 不是首页控制器，将导航栏背景换成红色
    /*
    if (![rootViewController isKindOfClass:[SINHomepageViewController class]]) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"newuser_bg"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return self;
    }
    */
    //
    if (![rootViewController isKindOfClass:[SINHomepageViewController class]]) {
        
        if ([rootViewController isKindOfClass:[SINShoppeViewController class]]) {
            [self.navigationBar setBarTintColor:[UIColor orangeColor]];
            [self.navigationBar setBackgroundColor:[UIColor colorWithRed:253/255.0 green:126/255.0 blue:21/255.0 alpha:1.0]];
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:253/255.0 green:126/255.0 blue:21/255.0 alpha:1.0]}];
            self.navigationBar.translucent = NO;
            [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[[UIImage alloc] init]];
            return self;
        }
        
        if ([rootViewController isKindOfClass:[SINMineViewController class]]) {
            [self.navigationBar setBarTintColor:SINGobalColor];
            [self.navigationBar setBackgroundColor:[UIColor colorWithRed:244/255.0 green:46/255.0 blue:81/255.0 alpha:1.0]];
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:244/255.0 green:46/255.0 blue:81/255.0 alpha:1.0]}];
            self.navigationBar.translucent = NO;
            [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        }
        
        [self.navigationBar setBackgroundColor:SINGobalColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:SINGobalColor}];
        
        return self;
    }
    
    // 传一个空的图片或者一张透明的图片(分辨率无所谓)
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationBar.layer.masksToBounds = YES;// 去掉横线（没有这一行代码导航栏的最下面还会有一个横线）
    return self;
    
    /*
    if (self) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self.view insertSubview:view belowSubview:self.navigationBar];
    }
    return self;
     */
}

@end
