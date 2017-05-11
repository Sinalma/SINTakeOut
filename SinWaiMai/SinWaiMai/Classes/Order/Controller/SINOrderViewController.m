//
//  SINOrderViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINOrderViewController.h"
#import "SINOrderLoginView.h"
#import "Masonry.h"
#import "SINLoginViewController.h"

@interface SINOrderViewController () <SINOrderLoginViewDelegate>
@property (nonatomic,strong) SINOrderLoginView *orderLoginView;
@end

@implementation SINOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNaiv];
    
    [self setupChildView];
}

- (void)setupChildView
{
    [self.view addSubview:self.orderLoginView];
    [self.orderLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@300);
    }];
    
}

#pragma mark - SINOrderLoginViewDelegata
- (void)loginRegisterBtnClick
{
    [self.orderLoginView stopImgAnimation];
    
    SINLoginViewController *loginVC = [[SINLoginViewController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)shopCarBtnClick
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.orderLoginView startImgVAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.orderLoginView stopImgAnimation];
}

- (void)setupNaiv
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"订单";
    lab.font = [UIFont systemFontOfSize:19];
    lab.frame = CGRectMake(0, 0, 20, 50);
    lab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lab;
    
    [self.navigationController.navigationBar setBarTintColor:SINGobalColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shopCar_navi"] style:UIBarButtonItemStylePlain target:self action:@selector(shopCarBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (SINOrderLoginView *)orderLoginView
{
    if (_orderLoginView == nil) {
        _orderLoginView = [[SINOrderLoginView alloc] init];
        _orderLoginView.delegate = self;
    }
    return _orderLoginView;
}

@end
