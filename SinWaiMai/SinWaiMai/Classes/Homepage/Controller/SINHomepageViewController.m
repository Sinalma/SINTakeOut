//
//  SINHomepageViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  首页控制器

/** ad为广告的缩写 */

#import "SINHomepageViewController.h"

#import "Masonry.h"

#import "SINAdScrollView.h"

#import "SINWMTypeScrollView.h"

#import "SINNewUserEnjorView.h"

#import "SINSecondModuleView.h"

#import "SINThirdModuleView.h"

#import "SINShoppeTableViewCell.h"

#import "AFNetworking.h"

#import "SINShoppe.h"

/** 首页顶部广告图片数量 */
#define AdImageCount 3

/** 首页外卖类型数量 */
#define WMTypeCount 15

/** 普通间距 */
#define margin 10

@interface SINHomepageViewController () <UITableViewDataSource,UIScrollViewDelegate>

/** 整体的scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 顶部广告scrollView */
@property (nonatomic,strong) SINAdScrollView *adView;

/** 选择外卖类型的scrollView */
@property (nonatomic,strong) SINWMTypeScrollView *wMTypesView;

/** 存放外卖所有类型的图片名 */
@property (nonatomic,strong) NSMutableArray *wMTypesImgNs;

/** 存放外卖所有类型类型名 */
@property (nonatomic,strong) NSArray *wMTypesNames;

/** 新人专享view */
@property (nonatomic,strong) SINNewUserEnjorView *newuserEnjorView;

/** 模块二view */
@property (nonatomic,strong) SINSecondModuleView *secondModuleView;

/** 模块三view */
@property (nonatomic,strong) SINThirdModuleView *thirdModuleView;

/** 商品tableView */
@property (nonatomic,strong) UITableView *shoppeView;

/** 保存所有商户的数组 */
@property (nonatomic,strong) NSMutableArray *shoppes;

@end

@implementation SINHomepageViewController
#pragma mark - 首页启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNavi];
    
    // 添加和布局整体scrollView子控件
    [self layoutGobalScrollViewChildView];
    
    // 发送网络请求
    [self sendNetworkRespond];
}

#pragma mark - 自定义方法

/**
 * 请求网络数据
 resid	1001
 channel	appstore
 screen	320x568
 net_type	wifi
 loc_lat	2557437.974165
 hot_fix	1
 msgcuid
 model	iPhone5,2
 taste
 uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
 sv	4.3.3
 cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 vmgdb
 isp	46001
 da_ext
 jailbreak	0
 aoi_id	14203335102845747
 lng	12617386.904808
 from	na-iphone
 page	1
 idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
 count	20
 city_id	187
 sortby
 os	8.2
 lat	2557445.778459
 request_time	2147483647
 address	龙瑞文化广场
 loc_lng	12617396.259449
 promotion
 device_name	“Administrator”的 iPhone (4)
 alipay	0
 return_type	launch
 
 
 NSDictiontary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557437.974165",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.3.3",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617386.904808",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557445.778459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617396.259449",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"launch"};
 */

- (void)sendNetworkRespond
{
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] init];
    
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557429.095533",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.3.3",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617387.766717",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557429.324021",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.766884",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"paing"};
    
    [mgr POST:@"https://client.waimai.baidu.com/shopui/na/v1/cliententry" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [responseObject[@"result"][@"shop_info"] writeToFile:@"/Users/apple/desktop/sdfsdfsd.plist" atomically:YES];
        
        for (NSDictionary *dict in responseObject[@"result"][@"shop_info"]) {
            SINShoppe *shoppe = [SINShoppe shoppeWithDict:dict];
            
            [self.shoppes addObject:shoppe];
        }
        
        for (int i = 0; i < self.shoppes.count; i++) {
            
        }
        
        for (SINShoppe *shop in self.shoppes) {
            
//            NSString *log = [shop.logo_url componentsSeparatedByString:@"@"][1];
            NSLog(@"%@",shop.logo_url);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败 error : %@",error);
    }];
}

/**
 * 添加和布局整体scrollView子控件
 */
- (void)layoutGobalScrollViewChildView
{
    // 添加子控件
    [self.view addSubview:self.gobalScrollView];
    
    [self.gobalScrollView addSubview:self.adView];
    
    [self.gobalScrollView addSubview:self.wMTypesView];
    
    [self.gobalScrollView addSubview:self.newuserEnjorView];
    
    [self.gobalScrollView addSubview:self.secondModuleView];
    
    [self.gobalScrollView addSubview:self.thirdModuleView];
    
    [self.gobalScrollView addSubview:self.shoppeView];
    
    // 布局子控件
    // 广告scrollView
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.gobalScrollView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageAdHeight));
    }];
    
    // 外卖类型模块
    [self.wMTypesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView.mas_bottom);
        make.left.equalTo(self.adView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageWmTypeHeight));
    }];
    
    // 新人专享view
    [self.newuserEnjorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wMTypesView.mas_bottom).offset(10);
        make.left.equalTo(self.wMTypesView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageNewUserHeight));
    }];
    
    // 模块二
    [self.secondModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newuserEnjorView.mas_bottom).offset(10);
        make.left.equalTo(self.newuserEnjorView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageTwoModuleHeight));
    }];
    
    // 模块三
    [self.thirdModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondModuleView.mas_bottom).offset(10);
        make.left.equalTo(self.secondModuleView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageThirdModuleHeight));
    }];
    
    // 商品view
    [self.shoppeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdModuleView.mas_bottom).offset(10);
        make.left.equalTo(self.thirdModuleView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(SINScreenH));
    }];
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
    // 把状态栏文字改为白色
    // -[UIViewController preferredStatusBarStyle]
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINShoppeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}


#pragma mark - 懒加载
static NSString *const cellID = @"shoppeCell";
- (UITableView *)shoppeView
{
    if (_shoppeView == nil) {
        _shoppeView = [[UITableView alloc] init];
        
        _shoppeView.dataSource = self;
        
        [_shoppeView registerNib:[UINib nibWithNibName:NSStringFromClass([SINShoppeTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        
        _shoppeView.rowHeight = 175;
        _shoppeView.estimatedRowHeight = 175;
    }
    return _shoppeView;
}

// 整体的scrollView
- (UIScrollView *)gobalScrollView
{
    if (_gobalScrollView == nil) {
        
        _gobalScrollView = [[UIScrollView alloc] init];
        _gobalScrollView.frame = self.view.bounds;
        _gobalScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _gobalScrollView.backgroundColor = [UIColor lightGrayColor];
        _gobalScrollView.delegate = self;
        // 设置整体scrollView的内容尺寸
        CGFloat contentH = HomepageAdHeight + HomepageWmTypeHeight + HomepageNewUserHeight + HomepageTwoModuleHeight + HomepageThirdModuleHeight + SINScreenH + 4 * 10;
        [_gobalScrollView setContentSize:CGSizeMake(SINScreenW, contentH)];
    }
    
    return _gobalScrollView;
}

// 广告scrollView
- (SINAdScrollView *)adView
{
    if (_adView == nil) {
        _adView = [[SINAdScrollView alloc] init];
        _adView.pagingEnabled = YES;
        _adView.size = CGSizeMake(SINScreenW, HomepageAdHeight);
        _adView.contentSize = CGSizeMake(SINScreenW * AdImageCount, HomepageAdHeight);
        _adView.adImgCount = AdImageCount;
        
        // 传递数据
        NSMutableArray *tempArrM = [NSMutableArray array];
        for (int i = 0; i < AdImageCount; i++) {
            NSString *str = [NSString stringWithFormat:@"ad0%d",i + 1];
            [tempArrM addObject:str];
        }
        _adView.adImgArr = tempArrM;
    }
    return _adView;
}

// 选择外卖类型的scrollView
- (SINWMTypeScrollView *)wMTypesView
{
    if (_wMTypesView == nil) {
        
        _wMTypesView = [[SINWMTypeScrollView alloc] init];
        _wMTypesView.backgroundColor = [UIColor whiteColor];
        
        // 传递数据
        _wMTypesView.wMTypeImgNs = self.wMTypesImgNs;
        _wMTypesView.wMTypeNames = self.wMTypesNames;
        _wMTypesView.wMTypeCount = (int)self.wMTypesNames.count;
    }
    return _wMTypesView;
}

// 存放所有外卖类型名称的数组
- (NSArray *)wMTypesNames
{
    if (_wMTypesNames == nil) {
        _wMTypesNames = @[@"餐饮",@"超市购",@"百度专送",@"早餐",@"品牌馆",@"百度糯米",@"鲜花蛋糕",@"土豪特供",@"新店特惠",@"水果生鲜",@"质享生活",@"领券",@"火锅",@"商务快食",@"送药上门"];
    }
    return _wMTypesNames;
}

// 存放所有外卖类型的图片名的数组
- (NSMutableArray *)wMTypesImgNs
{
    if (_wMTypesImgNs == nil) {
        
        _wMTypesImgNs = [NSMutableArray array];
        
        for (int i = 0; i < WMTypeCount; i++) {
            
            NSString *str = [NSString stringWithFormat:@"WMType0%d",i + 1];
            
            [_wMTypesImgNs addObject:str];
        }
    }
    return _wMTypesImgNs;
}

// 新人专享
- (SINNewUserEnjorView *)newuserEnjorView
{
    if (_newuserEnjorView == nil) {
        _newuserEnjorView = [SINNewUserEnjorView newUserEnjorView];
    }
    return _newuserEnjorView;
}

// 模块二
- (SINSecondModuleView *)secondModuleView
{
    if (_secondModuleView == nil) {
        _secondModuleView = [SINSecondModuleView secondModuleView];
    }
    return _secondModuleView;
}

// 模块三
- (SINThirdModuleView *)thirdModuleView
{
    if (_thirdModuleView == nil) {
        _thirdModuleView = [SINThirdModuleView thirdModuleView];
    }
    return _thirdModuleView;
}

- (NSMutableArray *)shoppes
{
    if (_shoppes == nil) {
        _shoppes = [NSMutableArray array];
    }
    return _shoppes;
}

@end
