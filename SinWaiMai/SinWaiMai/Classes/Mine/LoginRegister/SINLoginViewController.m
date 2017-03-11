//
//  SINLoginViewController.m
//  SinWaiMai
//
//  Created by apple on 10/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINLoginViewController.h"
#import "Masonry.h"

#define LoginNaviBarHeight 44

@interface SINLoginViewController ()

@property (nonatomic,strong) UIView *naviBar;

@property (nonatomic,strong) UIImageView *logoView;

@property (nonatomic,strong) UIScrollView *contentView;

/** 短信登录按钮 */
@property (nonatomic,strong) UIButton *messageLoginBtn;

/** 普通登录 */
@property (nonatomic,strong) UIButton *normalLoginBtn;

/** 短信登录线条 */
@property (nonatomic,strong) UIView *messageLineView;

/** 普通登录线条 */
@property (nonatomic,strong) UIView *normalLineView;

/** 账号输入框 */
@property (nonatomic,strong) UITextField *accTextField;

/** 密码输入框 */
@property (nonatomic,strong) UITextField *pwdTextField;

/** 获取验证码或登录按钮 */
@property (nonatomic,strong) UIButton *loginBtn;

/** 遇到问题按钮 */
@property (nonatomic,strong) UIButton *questionBtn;

/** 底部立即注册按钮 */
@property (nonatomic,strong) UIButton *registerBtn;

@end

@implementation SINLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavi];
    
    [self setupChildView];
    [self layoutChildView];
}

- (void)layoutChildView
{
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(LoginNaviBarHeight));
        make.top.equalTo(self.view).offset(64);
    }];
    
    [self.messageLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.naviBar);
        make.width.equalTo(@(SINScreenW * 0.5));
        make.bottom.equalTo(self.naviBar).offset(-2);
    }];
    
    CGFloat messageLineW = [self.messageLoginBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    [self.messageLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLoginBtn.mas_bottom);
        make.height.equalTo(@2);
        make.width.equalTo(@(messageLineW));
        make.left.equalTo(@(SINScreenW * 0.5 * 0.5 - messageLineW * 0.5));
    }];
    
    [self.normalLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.naviBar);
        make.width.equalTo(@(SINScreenW * 0.5));
        make.bottom.equalTo(self.naviBar).offset(-2);
    }];
    CGFloat normalLineW = [self.normalLoginBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    [self.normalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalLoginBtn.mas_bottom);
        make.height.equalTo(@2);
        make.width.equalTo(@(normalLineW));
        make.left.equalTo(@(SINScreenW * 0.5 * 0.5 - normalLineW * 0.5 + SINScreenW * 0.5));
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(SINScreenW * 0.5 - 130 * 0.5));
        make.top.equalTo(self.naviBar.mas_bottom).offset(50);
        make.height.equalTo(@50);
        make.width.equalTo(@130);
    }];
    
    [self.accTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.logoView.mas_bottom).offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@(SINScreenW - 20));
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accTextField);
        make.height.equalTo(@0);
        make.top.equalTo(self.accTextField.mas_bottom);
        make.width.equalTo(@(SINScreenW - 20));
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTextField);
        make.width.equalTo(@(SINScreenW - 20));
        make.height.equalTo(@35);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(15);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn);
        make.width.equalTo(@(176));
        make.height.equalTo(@(20));
        make.top.equalTo(self.loginBtn.mas_bottom).offset(15);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionBtn).offset(210);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.left.equalTo(@(SINScreenW * 0.5 - 100 * 0.5));
    }];
}

- (void)setupChildView
{
    // 导航条
    UIView *naviBar = [[UIView alloc] init];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    self.naviBar = naviBar;
    
    // 导航条子控件
    UIButton *messageBtn = [[UIButton alloc] init];
    [messageBtn setTitle:@"短信快捷登录" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [messageBtn addTarget:self action:@selector(messageLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:messageBtn];
    self.messageLoginBtn = messageBtn;
    
    UIView *messageLineV = [[UIView alloc] init];
    messageLineV.backgroundColor = [UIColor redColor];
    [self.naviBar addSubview:messageLineV];
    self.messageLineView = messageLineV;
    
    
    UIButton *normalBtn = [[UIButton alloc] init];
    [normalBtn setTitle:@"普通登录" forState:UIControlStateNormal];
    [normalBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    normalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [normalBtn addTarget:self action:@selector(normalLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:normalBtn];
    self.normalLoginBtn = normalBtn;
    
    UIView *normalLineV = [[UIView alloc] init];
    normalLineV.hidden = YES;
    normalLineV.backgroundColor = [UIColor redColor];
    [self.naviBar addSubview:normalLineV];
    self.normalLineView = normalLineV;
    
    // 内容scrollView
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    // logo
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"baiduLogo"];
    [self.contentView addSubview:logoView];
    self.logoView = logoView;
    
    // 账号输入框
    UITextField *accTextField = [[UITextField alloc] init];
    accTextField.placeholder = @"请输入手机号";
    accTextField.backgroundColor = [UIColor whiteColor];
    accTextField.font = [UIFont systemFontOfSize:15];
    accTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accTextField.layer.borderWidth = 0.5;
    [self.contentView addSubview:accTextField];
    self.accTextField = accTextField;
    
    // 密码输入框
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    pwdTextField.layer.borderWidth = 0.5;
    pwdTextField.backgroundColor = [UIColor whiteColor];
    pwdTextField.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:130/255.0 blue:252/255.0 alpha:1.0];
    loginBtn.layer.cornerRadius = 2;
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    // 问题label
    UIButton *questionBtn = [[UIButton alloc] init];
    [questionBtn setTitle:@"我已阅读并同意百度用户协议" forState:UIControlStateNormal];
    [questionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    questionBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:questionBtn];
    self.questionBtn = questionBtn;
    
    // 立即注册
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn setTitleColor:[UIColor colorWithRed:88/255.0 green:130/255.0 blue:252/255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor whiteColor];
    registerBtn.layer.borderWidth = 0.5;
    registerBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:130/255.0 blue:252/255.0 alpha:1.0].CGColor;
    [self.contentView addSubview:registerBtn];
    self.registerBtn = registerBtn;
}



- (void)normalLoginBtnClick
{
    [UIView animateWithDuration:1.5 animations:^{
    self.normalLineView.hidden = NO;
    self.messageLineView.hidden = YES;
    
    [self.pwdTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
    }];
    self.accTextField.placeholder = @"手机号/用户名/邮箱";
    self.pwdTextField.placeholder = @"密码";
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.questionBtn setTitle:@"登录遇到问题" forState:UIControlStateNormal];
    
    [self.questionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@85);
    }];
        
    }];
}

- (void)messageLoginBtnClick
{
    [UIView animateWithDuration:1.5 animations:^{
        
    self.normalLineView.hidden = YES;
    self.messageLineView.hidden = NO;
    [self.pwdTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    self.accTextField.placeholder = @"请输入手机号码";
    self.pwdTextField.placeholder = nil;
    [self.loginBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [self.questionBtn setTitle:@"我已阅读并同意百度用户协议" forState:UIControlStateNormal];
    [self.questionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@176);
    }];
    }];
}

- (void)login
{
    NSLog(@"点击了登录按钮");
}

- (void)redisterBtnClick
{
    NSLog(@"点击了底部立即注册按钮");
}

- (void)questionBtnClick
{
    NSLog(@"点击了遇到问题按钮");
}

- (void)setupNavi
{
    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)registerClick
{
    NSLog(@"点击了注册");
}

- (void)back
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
