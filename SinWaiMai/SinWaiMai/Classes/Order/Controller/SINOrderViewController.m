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

- (void)setupNaiv
{
    self.title = @"订单";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:246/255.0 green:46/255.0 blue:66/255.0 alpha:1.0]];
}

- (SINOrderLoginView *)orderLoginView
{
    if (_orderLoginView == nil) {
        _orderLoginView = [[SINOrderLoginView alloc] init];
    }
    return _orderLoginView;
}

@end
