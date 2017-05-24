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
    
    [self setupAllChildVC];
}

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

- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title imgN:(NSString *)imgN
{
    SINNavigationController *naviVC = [[SINNavigationController alloc] initWithRootViewController:vc];
    [naviVC.tabBarItem setImage:[UIImage imageNamed:imgN]];
    NSString *highLightImgN = [imgN stringByAppendingString:@"_highlighted"];
    [naviVC.tabBarItem setSelectedImage:[UIImage imageNamed:highLightImgN]];
//    [[UITabBar appearance] setTintColor:SINGobalColor];
     [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:SINGobalColor} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    
    vc.navigationController.title = title;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:naviVC];
}

@end
