//
//  SINLoginViewController.m
//  SinWaiMai
//
//  Created by apple on 10/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINLoginViewController.h"
#import "Masonry.h"
#import "SINAccount.h"
#import <SMS_SDK/SMSSDK.h>

typedef enum : NSUInteger {
    KAccountStatueLoignNow = 0,
    KAccountStatueRegsiterNow = 1,
} AccountStatue;

#define LoginNaviBarHeight 44

@interface SINLoginViewController () <UITextFieldDelegate>

/** 导航条 */
@property (nonatomic,strong) UIView *naviBar;

/** 百度logo */
@property (nonatomic,strong) UIImageView *logoView;

/** 内容scrollView */
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

/** 账号类 */
@property (nonatomic,strong) SINAccount *account;

/** 登录或者注册的状态 */
@property (nonatomic,assign) AccountStatue accountStatue;

@property (nonatomic,strong) SINHUD *hud;

/** 保存临时输入的密码，但为点击登录 */
@property (nonatomic,strong) NSString *tempPwd;

/** 保存当前获取验证码的手机号码 */
@property (nonatomic,strong) NSString *curPhone;

@end

@implementation SINLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    
    [self setupChildView];
    [self layoutChildView];
    [self contentViewTap];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.pwdTextField.text = nil;
    self.accTextField.text = nil;
    
    canJumpToPasswordApp = YES;
}

- (void)dealloc
{
    [SINNotificationCenter removeObserver:self];
}

#pragma mark - 密码相关
static BOOL canJumpToPasswordApp = YES;
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.pwdTextField && canJumpToPasswordApp == YES) {
        [self.accTextField endEditing:YES];
        
        // 提醒用户是否使用密码功能
        UIAlertController *alert = [[UIAlertController alloc] init];
        alert.title = @"是否使用密码功能";
        UIAlertAction *yesAct = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 进入密码填充界面
            [self jumpToPasswordApp];
            
            // 监听密码通知
            [self addPasswordNoti];
        }];
        [alert addAction:yesAct];
        UIAlertAction *noAct = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            // 本次拒绝后不再询问是否跳转密码填充界面
            canJumpToPasswordApp = NO;
            [self.pwdTextField becomeFirstResponder];
        }];
        [alert addAction:noAct];
        
        [self presentViewController:alert animated:YES completion:^{
            [self.view endEditing:YES];
        }];
    }
}

/**
 * 监听appDelegate密码的通知
 */
- (void)addPasswordNoti
{
    [SINNotificationCenter addObserver:self selector:@selector(passwordNoti:) name:PasswordNotiName object:nil];
}

- (void)passwordNoti:(NSNotification *)noti
{
    self.pwdTextField.text = noti.object;
}


/**
 * 跳转到密码填充app
 */
- (void)jumpToPasswordApp
{
    NSURL *url = [NSURL URLWithString:@"Password://?SinWaiMai"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }else
    {
        SINLog(@"未安装密码填充app");
    }
}

#pragma mark - 自定义方法
- (void)login
{
    SINHUD *hud = [[SINHUD alloc] init];
    self.hud = hud;
    [self.view addSubview:hud];
    hud.backgroundColor = [UIColor clearColor];
    hud.centerY = self.view.centerY - 70;
    hud.centerX = self.view.centerX;
    [hud showAnimated:YES];
    
    if (self.normalLineView.hidden == YES) {
        
        if ([self.loginBtn.titleLabel.text isEqualToString:@"提交"]) {
            
            // 已获取验证码，点击提交后验证验证码的真伪
            [SMSSDK commitVerificationCode:self.accTextField.text phoneNumber:self.curPhone zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                if (!error)
                {
                    self.account.isLogin = YES;
                    hud.label.text = @"验证成功，登录中...";
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [self back];
                    });
                    SINLog(@"验证成功");
                }
                else
                {
                    self.account.isLogin = NO;
                    hud.label.text = @"验证失败，请重试";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                });
                    SINLog(@"错误信息:%@",error);
                }
            }];
            
            
        }else if ([self.loginBtn.titleLabel.text isEqualToString:@"获取手机验证码"])
        {
            self.curPhone = self.accTextField.text;
            self.accTextField.placeholder = @"请输入验证码";
            [self.loginBtn setTitle:@"提交" forState:UIControlStateNormal];
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (error) {
                    SINLog(@"获取短信验证码失败");
                    [hud showAnimated:YES];
                    hud.label.text = @"获取验证码失败，请重新获取";
                    self.accTextField.placeholder = @"请输入手机号";
                    [self.loginBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([self.loginBtn.titleLabel.text isEqualToString:@"提交"]) {
                            self.accTextField.placeholder = @"请输入手机号";
                            [self.loginBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                        }
                    });
                    
                }else
                {
                    SINLog(@"获取短信验证码成功");
                }
            }];
            
            self.accTextField.text = nil;
        }
        
        
        [hud hideAnimated:YES];
        
        return;
    }
    
    if (!self.accTextField.text.length || !self.pwdTextField.text.length) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"账号和密码不能为空";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        return;
    }
    
    
    BOOL bol = NO;
    
    if (self.accountStatue == KAccountStatueRegsiterNow) bol = [self.account registerWithAccount:self.accTextField.text password:self.pwdTextField.text];
    
    if (self.accountStatue == KAccountStatueLoignNow) bol = [self.account verifyWithAccount:self.accTextField.text pwd:self.pwdTextField.text];
    
    hud.label.text = nil;
    if (bol == NO) {
        hud.label.text = self.accountStatue == KAccountStatueRegsiterNow ? @"注册失败" : @"账号或密码输入错误，请重新输入";
    }else
    {
        hud.label.text = self.accountStatue == KAccountStatueRegsiterNow ? @"注册成功,即将跳转登录界面" : @"登录成功，即将进入主界面";
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [hud hideAnimated:YES];
       
        if (bol == YES) {
            
            if (self.accountStatue == KAccountStatueRegsiterNow) {
                [self registerClick];
            }else
            {
                [self back];
            }
        }
    });
}

- (void)loginOrRegister:(AccountStatue)accountStatue
{
    if (accountStatue == 0) {
        [UIView animateWithDuration:1.5 animations:^{
            
        [self normalLoginBtnClick];
        self.title = @"注册";
        [self.navigationItem.rightBarButtonItem setTitle:@"登录"];
        [self.registerBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        self.view.transform = CGAffineTransformMakeScale(-0.5, -0.5);
        self.naviBar.transform = CGAffineTransformMakeTranslation(SINScreenW, 0);
            self.questionBtn.hidden = YES;
        }];
        self.view.transform = CGAffineTransformIdentity;
    }else
    {
        [UIView animateWithDuration:1.5 animations:^{
            self.questionBtn.hidden = NO;
        self.title = @"登录";
        [self.navigationItem.rightBarButtonItem setTitle:@"注册"];
        [self.registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        self.view.transform = CGAffineTransformMakeScale(-0.5, -0.5);
            self.naviBar.transform = CGAffineTransformIdentity;
        }];
        self.view.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 点击事件
/**
 * contentView添加手势
 */
- (void)contentViewTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesContentView)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)touchesContentView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accTextField endEditing:YES];
    [self.pwdTextField endEditing:YES];
}

- (void)normalLoginBtnClick
{
    // 防止输入了密码没登入，但跳至短信登录界面时密码不见
    self.pwdTextField.text = self.tempPwd ? self.tempPwd : @"";
    
    //    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view endEditing:YES];
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
    // 清空另一个textField的文字
    self.tempPwd = self.pwdTextField.text;
    self.pwdTextField.text = nil;
    
    [self.view endEditing:YES];
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

- (void)redisterBtnClick
{
    [self loginOrRegister:self.accountStatue];
    self.accountStatue = self.accountStatue==KAccountStatueLoignNow ? KAccountStatueRegsiterNow : KAccountStatueLoignNow;
}
/**
 * 导航栏右侧按钮
 */
- (void)registerClick
{
    [self.view endEditing:YES];
    [self redisterBtnClick];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)questionBtnClick
{
    SINLog(@"点击了遇到问题按钮");
}

#pragma mark - 初始化
- (void)setupNavi
{
    self.title = @"登录";
    
    self.accountStatue = KAccountStatueLoignNow;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
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
    
    self.logoView.backgroundColor = [UIColor orangeColor];
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
        make.top.equalTo(self.questionBtn).offset(125);
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
    accTextField.delegate = self;
    //    accTextField.alignmentRectInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.contentView addSubview:accTextField];
    self.accTextField = accTextField;
    
    // 密码输入框
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.delegate = self;
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
    [registerBtn addTarget:self action:@selector(redisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.backgroundColor = [UIColor whiteColor];
    registerBtn.layer.borderWidth = 0.5;
    registerBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:130/255.0 blue:252/255.0 alpha:1.0].CGColor;
    [self.contentView addSubview:registerBtn];
    self.registerBtn = registerBtn;
}

#pragma mark - 懒加载
- (SINAccount *)account
{
    if (_account == nil) {
        _account = [[SINAccount alloc] init];
    }
    return _account;
}

@end
