
//
//  SINMineViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINMineViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "SINUserInfo.h"
#import "SINUserInfoView.h"
#import "SINWalletView.h"
#import "SINWalletItem.h"
#import "SINWallet.h"
#import "SINUserCenterItem.h"
#import "SINUserCenterView.h"
#import "SINWaveView.h"

#define MineLoginBtnW 120
#define MineLoginBtnH 40

@interface SINMineViewController ()

/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *netWorkMgr;

/** 整体scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 用户信息view */
@property (nonatomic,strong) SINUserInfoView *userInfoView;

/** 钱包view */
@property (nonatomic,strong) SINWalletView *walletView;

/** 用户中心view */
@property (nonatomic,strong) SINUserCenterView *userCenterView;

/** 登录view */
@property (nonatomic,strong) UIView *loginView;

/** 登录按钮 */
@property (nonatomic,strong) UIButton *loginBtn;


#pragma mark - 数据
/** 保存用户信息模型的数组 */
@property (nonatomic,strong) NSArray *userInfoes;

/** 保存用户钱包模型的数组 */
@property (nonatomic,strong) NSArray *walletItems;

/** 保存钱包模块所有数据 */
@property (nonatomic,strong) SINWallet *wallet;

/** 保存用户中心模块数据 */
@property (nonatomic,strong) NSArray *userCenterItems;

/** 保存客服热线字典 */
// name phone
@property (nonatomic,strong) NSDictionary *customer_service_Dict;

@end

@implementation SINMineViewController
#pragma mark - 控制器启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNavi];
    
    // 初始化子控件
    [self setupChildView];
    
    // 加载网络数据
    [self loadNetworkData];
    
//    [self waveViewAnim];
}

- (void)waveViewAnim
{
    SINWaveView *waveV = [[SINWaveView alloc] initWithFrame:CGRectMake(0, 50, SINScreenW, 150)];
    [self.view addSubview:waveV];
}

#pragma mark - 自定义方法
/**
 * 加载网络数据
 */
- (void)loadNetworkData
{
    NSDictionary *parames = @{@"net_type":@"wifi",@"jailbreak":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"loc_lat":@"2557437.139064",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"loc_lng":@"12617375.862145",@"channel":@"appstore",@"da_ext":@"",@"lng":@"12617375.861812",@"aoi_id":@"14203335102845747",@"os":@"8.2",@"from":@"na-iphone",@"address":@"龙瑞文化广场",@"vmgdb":@"",@"model":@"iPhone5,2",@"hot_fix":@"1",@"isp":@"46001",@"screen":@"320x568",@"resid":@"1001",@"city_id":@"187",@"lat":@"2557437.596041",@"request_time":@"2147483647",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"msgcuid":@"",@"alipay":@"0",@"device_name":@"“Administrator”的 iPhone (4)"};
    
    [self.netWorkMgr POST:@"http://client.waimai.baidu.com/mobileui/user/v2/usercenter" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
//        [responseObject writeToFile:@"/Users/apple/desktop/mine.plist" atomically:YES];
        
        // 客服热线
        self.customer_service_Dict = responseObject[@"result"][@"customer_service"];
        self.userCenterView.customer_service_Dict = self.customer_service_Dict;
        
        
        NSMutableArray *userInfoArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"user_info"]) {

            SINUserInfo *info = [SINUserInfo userInfoWithDict:dict];
            [userInfoArrM addObject:info];
        }
        self.userInfoes = userInfoArrM;
        self.userInfoView.userInfoes = userInfoArrM;
        
        // 钱包模块
        NSDictionary *walletDict = responseObject[@"result"][@"baiduWallet"];
        SINWallet *wallet = [SINWallet walletWithDict:walletDict];
        self.wallet = wallet;
        self.walletView.wallet = wallet;
        
        // 用户中心模块
        NSMutableArray *userCenterItemArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"user_center_list"]) {
            SINUserCenterItem *item = [SINUserCenterItem userCenterItemWithDict:dict];
            [userCenterItemArrM addObject:item];
        }
        self.userCenterItems = userCenterItemArrM;
        self.userCenterView.userCenterItems = userCenterItemArrM;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"我的控制器-数据加载失败 %@",error);
    }];
}

/**
 * 初始化子控件
 */
- (void)setupChildView
{
    // 创建子控件
    [self.view addSubview:self.gobalScrollView];
  
    // 用户信息view
    [self.gobalScrollView addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gobalScrollView);
        make.top.equalTo(self.gobalScrollView).offset(100);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(117));
    }];
    
    // 钱包view
    [self.gobalScrollView addSubview:self.walletView];
    [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gobalScrollView);
        make.top.equalTo(self.userInfoView.mas_bottom).offset(-6);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(115));
    }];
    
    // 用户中心view
    [self.gobalScrollView addSubview:self.userCenterView];
    [self.userCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gobalScrollView);
        make.top.equalTo(self.walletView.mas_bottom);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@455);
    }];
    
    // 设置整体scrollView的内容尺寸
//    CGFloat scrollVH = self.userInfoView.height + self.walletView.height + self.userCenterView.height;
//    NSLog(@"scrollVH%f",scrollVH);
    self.gobalScrollView.contentSize = CGSizeMake(0,739);
    
    
    // 登录view
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.width.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    // 登录view的登录按钮
    [self.loginView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loginView);
        make.height.equalTo(@(MineLoginBtnH));
        make.width.equalTo(@(MineLoginBtnW));
    }];
    
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0];
    
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.navigationController.navigationBar setBarTintColor:SINGobalColor];
    
//    UILabel *lab = [[UILabel alloc] init];
//    lab.text = @"我的";
//    lab.font = [UIFont systemFontOfSize:19];
//    lab.frame = CGRectMake(0, 0, 20, 50);
//    lab.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lab;
}


#pragma mark - 懒加载
- (AFHTTPSessionManager *)netWorkMgr
{
    if (_netWorkMgr == nil) {
        _netWorkMgr = [[AFHTTPSessionManager alloc] init];
    }
    return _netWorkMgr;
}

- (UIScrollView *)gobalScrollView
{
    if (_gobalScrollView == nil) {
        
        _gobalScrollView = [[UIScrollView alloc] init];
        
        _gobalScrollView.frame = self.view.bounds;
        
        _gobalScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _gobalScrollView;
}

- (SINUserInfoView *)userInfoView
{
    if (_userInfoView == nil) {
        _userInfoView = [[SINUserInfoView alloc] init];
        _userInfoView.backgroundColor = [UIColor whiteColor];

    }
    return _userInfoView;
}

- (SINWalletView *)walletView
{
    if (_walletView == nil) {
        _walletView = [[SINWalletView alloc] init];
        _walletView.backgroundColor = [UIColor whiteColor];
    }
    return _walletView;
}

- (SINUserCenterView *)userCenterView
{
    if (_userCenterView == nil) {
        _userCenterView = [[SINUserCenterView alloc] init];
        _userCenterView.backgroundColor = [UIColor whiteColor];
    }
    return _userCenterView;
}

- (UIView *)loginView
{
    if (_loginView == nil) {
        _loginView = [[UIView alloc] init];
        _loginView.backgroundColor = [UIColor colorWithRed:246/255.0 green:56/255.0 blue:82/255.0 alpha:1.0];
        
    }
    return _loginView;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.backgroundColor = [UIColor clearColor];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginBtn.layer.borderWidth = 1;
        _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginBtn.layer.cornerRadius = 20;
}
    return _loginBtn;
}

@end
