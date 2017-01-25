
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

@interface SINMineViewController ()

/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *netWorkMgr;

/** 整体scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 用户信息view */
@property (nonatomic,strong) SINUserInfoView *userInfoView;

#pragma mark - 数据
/** 保存用户信息模型的数组 */
@property (nonatomic,strong) NSArray *userInfoes;

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
}

#pragma mark - 自定义方法
/**
 * 加载网络数据
 */
- (void)loadNetworkData
{
    NSDictionary *parames = @{@"net_type":@"wifi",@"jailbreak":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"loc_lat":@"2557437.139064",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"loc_lng":@"12617375.862145",@"channel":@"appstore",@"da_ext":@"",@"lng":@"12617375.861812",@"aoi_id":@"14203335102845747",@"os":@"8.2",@"from":@"na-iphone",@"address":@"龙瑞文化广场",@"vmgdb":@"",@"model":@"iPhone5,2",@"hot_fix":@"1",@"isp":@"46001",@"screen":@"320x568",@"resid":@"1001",@"city_id":@"187",@"lat":@"2557437.596041",@"request_time":@"2147483647",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"msgcuid":@"",@"alipay":@"0",@"device_name":@"“Administrator”的 iPhone (4)"};
    
    [self.netWorkMgr POST:@"http://client.waimai.baidu.com/mobileui/user/v2/usercenter" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
        NSMutableArray *userInfoArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"user_info"]) {

            SINUserInfo *info = [SINUserInfo userInfoWithDict:dict];
            [userInfoArrM addObject:info];
        }
        self.userInfoes = userInfoArrM;
        self.userInfoView.userInfoes = userInfoArrM;
        
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
  
    [self.gobalScrollView addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(100));
    }];
    
    // 设置整体scrollView的内容尺寸
    self.gobalScrollView.contentSize = CGSizeMake(SINScreenW, self.userInfoView.height * 2);
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
    
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
        
        _gobalScrollView.backgroundColor = [UIColor orangeColor];
    }
    return _gobalScrollView;
}

- (SINUserInfoView *)userInfoView
{
    if (_userInfoView == nil) {
        _userInfoView = [[SINUserInfoView alloc] init];
        _userInfoView.backgroundColor = [UIColor cyanColor];

    }
    return _userInfoView;
}

@end
