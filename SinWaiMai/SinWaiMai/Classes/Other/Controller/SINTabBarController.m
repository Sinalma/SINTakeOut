//
//  SINTabBarController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINTabBarController.h"
#import "SINNavigationController.h"
#import "SINHomepageViewController.h"
#import "SINGuideViewController.h"
#import "SINOrderViewController.h"
#import "SINMineViewController.h"

@interface SINTabBarController ()

@end

@implementation SINTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setupAllChildVC];
}


/**
 * 添加所有子控制器
 */
- (void)setupAllChildVC
{
    SINHomepageViewController *homepage = [[SINHomepageViewController alloc] init];
    [self setupChildVC:homepage title:@"首页" imgN:@"tabbar_home"];
    
    SINGuideViewController *guide = [[SINGuideViewController alloc] init];
    [self setupChildVC:guide title:@"指南" imgN:@"tabbar_guide"];
    
    SINOrderViewController *order = [[SINOrderViewController alloc] init];
    [self setupChildVC:order title:@"订单" imgN:@"tabbar_order"];
    
    SINMineViewController *mine = [[SINMineViewController alloc] init];
    [self setupChildVC:mine title:@"我的" imgN:@"tabbar_mine"];
}

/**
 * 快速创建控制器，包装导航控制器
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title imgN:(NSString *)imgN
{
    SINNavigationController *naviVC = [[SINNavigationController alloc] initWithRootViewController:vc];
    [naviVC.tabBarItem setImage:[UIImage imageNamed:imgN]];
    NSString *highLightImgN = [imgN stringByAppendingString:@"_highlighted"];
    [naviVC.tabBarItem setSelectedImage:[UIImage imageNamed:highLightImgN]];
    
    [[UITabBar appearance] setTintColor:SINGobalColor];
    vc.navigationController.title = title;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:naviVC];
}

@end
