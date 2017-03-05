//
//  SINOrderLoginView.m
//  SinWaiMai
//
//  Created by apple on 04/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINOrderLoginView.h"
#import "Masonry.h"
#import "UILabel+Category.h"

@implementation SINOrderLoginView

+ (instancetype)orderLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINOrderLoginView class]) owner:nil options:nil] firstObject];
}

- (instancetype)init
{
    if (self == [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@""];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@200);
    }];
    
    UILabel *remLab = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
    remLab.text = @"只有登录后才能查看订单哦";
    remLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remLab];
    [remLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(20);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录／注册" forState:UIControlStateNormal];
    loginBtn.backgroundColor = SINGobalColor;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.cornerRadius = 20;
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remLab.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
}

@end
