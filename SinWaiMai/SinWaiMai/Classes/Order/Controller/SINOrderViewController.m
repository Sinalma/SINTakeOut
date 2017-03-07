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

@interface SINOrderViewController ()

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

- (void)viewDidAppear:(BOOL)animated
{
    [self.orderLoginView startImgVAnimation];
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
}

- (SINOrderLoginView *)orderLoginView
{
    if (_orderLoginView == nil) {
        _orderLoginView = [[SINOrderLoginView alloc] init];
    }
    return _orderLoginView;
}

@end
