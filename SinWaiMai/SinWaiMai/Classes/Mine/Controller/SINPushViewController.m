//
//  SINPushViewController.m
//  SinWaiMai
//
//  Created by apple on 06/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINPushViewController.h"
#import "SINPushView.h"

@interface SINPushViewController ()

@end

@implementation SINPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setSubview];
}

- (void)setSubview
{
    NSArray *titles = @[@"代金券通知",@"优惠信息通知",@"互动消息",@"个人权益同志"];
    NSArray *subTitles = @[@"包含代金券到账提醒、到期提醒等",@"商家活动消息、大促消息等",@"包含商家回复评论等",@"包含会员卡、配送权益到期通知等"];
    
    for (int i = 0; i < titles.count; i++) {
        SINPushView *pushView = [[SINPushView alloc] initWithFrame:CGRectMake(0, i*80, SINScreenW, 80)];
        pushView.title = titles[i];
        pushView.subTitle = subTitles[i];
        [self.view addSubview:pushView];
    }
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"推送消息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_icon_white_nomal_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
