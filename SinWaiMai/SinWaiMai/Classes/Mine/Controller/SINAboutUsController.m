//
//  SINAboutUsController.m
//  SinWaiMai
//
//  Created by apple on 06/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAboutUsController.h"
#import "UILabel+Category.h"
#import "Masonry.h"

@interface SINAboutUsController ()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *editionLabel;
@end

@implementation SINAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)layout
{
    [self.view addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@110);
        make.height.equalTo(@70);
        make.top.equalTo(self.view).offset(60);
    }];
    
    [self.view addSubview:self.editionLabel];
     [self.editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.iconView);
         make.top.equalTo(self.iconView.mas_bottom).offset(20);
    }];
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_icon_white_nomal_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"logo"];
    }
    return _iconView;
}

- (UILabel *)editionLabel
{
    if (!_editionLabel) {
        _editionLabel = [UILabel createLabelWithFont:15 textColor:[UIColor darkTextColor]];
        _editionLabel.text = @"百度外卖iOS版_v4.9.0";
    }
    return _editionLabel;
}

@end
