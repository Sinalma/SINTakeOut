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

@interface SINOrderLoginView ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIImageView *imgV;

@end

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

static int imgVAnimCount = 0;
- (void)startImgVAnimation
{
    imgVAnimCount = 0;
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(imgAnim) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopImgAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}
/**
 * Timer Transfer Method
 */
static int imgIndex = 0;
- (void)imgAnim
{
    if (imgIndex == 4) {
        imgIndex = 0;
        imgVAnimCount ++;
    }
    if (imgVAnimCount >= 2) {
        return ;
    }
    NSString *imgN = [NSString stringWithFormat:@"no_login_0%d",imgIndex];
    self.imgV.image = [UIImage imageNamed:imgN];
    imgIndex++;
}

- (void)setup
{
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"no_login_00"];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@200);
    }];
    self.imgV = imgV;
    
    UILabel *remLab = [UILabel createLabelWithFont:14 textColor:[UIColor lightGrayColor]];
    remLab.text = @"登录后才能查看订单哦";
    remLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remLab];
    [remLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(30);
        make.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    loginBtn.backgroundColor = SINGobalColor;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.cornerRadius = 20;
    [loginBtn addTarget:self action:@selector(loginRegisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remLab.mas_bottom).offset(30);
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
}

- (void)loginRegisterBtnClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(loginRegisterBtnClick)]) {
            [self.delegate loginRegisterBtnClick];
        }
    });
}



@end
