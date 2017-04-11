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
#import "SINActivity.h"
#import "SINWMType.h"
#import "SINNewuserentry.h"
#import "NSString+SINFilePath.h"
#import "MJRefresh.h"
#import "UILabel+Category.h"
#import "SINShoppeViewController.h"

/** 普通间距 */
#define margin 10

@interface SINHomepageViewController () <UITableViewDataSource,UIScrollViewDelegate,SINShoppeTableViewCellDelegate,UITableViewDelegate>

#pragma mark - 控件
/** 整体的scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 顶部广告scrollView */
@property (nonatomic,strong) SINAdScrollView *adView;

/** 选择外卖类型的scrollView */
@property (nonatomic,strong) SINWMTypeScrollView *wMTypesView;

/** 新人专享view */
@property (nonatomic,strong) SINNewUserEnjorView *newuserEnjorView;

/** 模块二view */
@property (nonatomic,strong) SINSecondModuleView *secondModuleView;

/** 模块三view */
@property (nonatomic,strong) SINThirdModuleView *thirdModuleView;

/** 商品tableView */
@property (nonatomic,strong) UITableView *shoppeView;

#pragma mark - 数据
/** 保存所有商户的数组 */
@property (nonatomic,strong) NSMutableArray *shoppes;

/** 保存最近美食商户的数组 */
@property (nonatomic,strong) NSMutableArray *yummyShoppes;

/** 保存活动的数组 */
@property (nonatomic,strong) NSArray *activties;

/** 保存外卖类型的数组 */
@property (nonatomic,strong) NSArray *wMTypes;

/** 保存广告的数组 */
@property (nonatomic,strong) NSArray *adImgUrls;

/** 保存新用户专享模块的模型 */
@property (nonatomic,strong) NSArray *newuesrentries;

/** 保存商户优惠信息图标地址 */
@property (nonatomic,strong) NSMutableDictionary *welfareSignUrls;

/** 网络管理类 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;

@end

@implementation SINHomepageViewController
#pragma mark - 首页启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNavi];
    
    // 添加和布局整体scrollView子控件
    [self layoutGobalScrollViewChildView];
    
    // 初始化刷新控件
    [self setupRefreshing];
}

- (void)dealloc
{
    self.networkMgr = nil;
}

/**
 * 初始化刷新控件
 */
- (void)setupRefreshing
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setImages:@[] forState:MJRefreshStateIdle];
    self.gobalScrollView.mj_header = header;
    [self.gobalScrollView.mj_header beginRefreshing];

    self.shoppeView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.shoppeView.mj_footer beginRefreshing];
}

/**
 * 下拉刷新调用
 * 进入首页默认下拉刷新请求网络数据
 */
- (void)loadMoreData
{
    [self sendShoppesRequest];
}

/**
 * 上拉刷新调用
 */
- (void)loadNewData
{
    networkPage = 1;
    [self.yummyShoppes removeAllObjects];
    self.yummyShoppes = nil;
    [self.shoppes removeAllObjects];
    self.shoppes = nil;
    
    [self sendShoppesRequest];
    
    // 获取其他模块数据
    [self sendOtherRequest];
}

#pragma mark - 自定义方法
/**
 * 获取数据:外卖类型模块数据，活动清单数据
 */
- (void)sendOtherRequest
{
//    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] init];
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557449.874939",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"os":@"8.2",@"request_time":@"2147483647",@"loc_lng":@"12617391.151377",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"launch",@"lat":@"",@"lng":@"",@"city_id":@"",@"address":@""};
    
    [self.networkMgr POST:@"http://client.waimai.baidu.com/shopui/na/v1/cliententry" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [responseObject[@"result"][@"newuserentry"] writeToFile:@"/Users/apple/desktop/newuserentry.plist" atomically:YES];
        // 广告模块
        NSMutableArray *adArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"activity_mobile"]) {
            [adArrM addObject:dict[@"img"]];
        }
        self.adImgUrls = adArrM;
        self.adView.adImgArr = adArrM;
        
        // 新人专享模块
//        NSMutableArray *newuserArrM = [NSMutableArray array];
//        NSLog(@"%@",responseObject[@"result"]);
//        [responseObject writeToFile:@"/Users/apple/desktop/error.plist" atomically:YES];
        /*
        if (responseObject[@"result"][@"newuserentry"][@"entries"]) {
            for (NSDictionary *dict in responseObject[@"result"][@"newuserentry"][@"entries"]) {
                SINNewuserentry *entry = [SINNewuserentry newuserentryWithDict:dict];
                [newuserArrM addObject:entry];
            }
            self.newuesrentries = newuserArrM;
            self.newuserEnjorView.newuesrentries = newuserArrM;
        }
        */
        
        // 外卖类型模块数据
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"eight_entry"]) {
            
            SINWMType *type = [SINWMType wMTypeWithDict:dict];
            [arrM addObject:type];
        }
        self.wMTypes = arrM;
        self.wMTypesView.wMTypes = arrM;
        
        // 活动数据
        // 需要重构这个模块，根据服务器返回的活动数动态创建控件
        NSMutableArray *actArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"activity_list"]) {
            SINActivity *act = [SINActivity activityWithDict:dict];
            [actArrM addObject:act];
        }
        self.activties = actArrM;
        self.secondModuleView.activities = actArrM;
        
        // 优惠信息图标
        NSMutableDictionary *welIconDict = [NSMutableDictionary dictionary];
        [responseObject[@"result"][@"welfare_icon"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull url, BOOL * _Nonnull stop) {
            url = [url componentsSeparatedByString:@"@"][0];
            welIconDict[key] = url;
        }];
        self.welfareSignUrls = welIconDict;
        // 将地址字典存到沙盒
        [self.welfareSignUrls writeToFile:ShoppeWelfareIconUrlFilePath.cachePath atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求其他数据失败 error : %@",error);
    }];
}

// 本方法请求数据page参数的值
static int networkPage = 1;
- (void)sendShoppesRequest
{
    // 暂定只有4页
    if (networkPage > 4) {
        return;
    }
    
//    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] init];
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557429.095533",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.3.3",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617387.766717",@"from":@"na-iphone",@"page":@(networkPage),@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557429.324021",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.766884",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"paging"};
    
    [self.networkMgr POST:@"https://client.waimai.baidu.com/shopui/na/v1/cliententry" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        [self.gobalScrollView.mj_header endRefreshing];
        [self.shoppeView.mj_footer endRefreshing];
        
        for (NSDictionary *dict in responseObject[@"result"][@"shop_info"]) {
            SINShoppe *shoppe = [SINShoppe shoppeWithDict:dict];
            
            // 第二页开始都属于附近美食组
            if (networkPage >= 2) {
                [self.yummyShoppes addObject:shoppe];
            }else if (networkPage == 1)
            {
                [self.shoppes addObject:shoppe];
            }
        }
        
        networkPage += 1;
        // 进入首页默认加载加载两次商户数据
        // 这里只需要调用一次sendShoppesRequest
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [self sendShoppesRequest];
        });
        
        // 刷新tableView
        [self.shoppeView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求商户数据失败 error : %@",error);
        networkPage -= 1;
        [self.gobalScrollView.mj_header endRefreshing];
        [self.shoppeView.mj_footer endRefreshing];
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
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    return;
    
    // navigationBar添加子控件
    UIView *cusView = [[UIView alloc] init];
    cusView.frame = CGRectMake(0, 0, 110, 20);
    
    UIImageView *bicycleImg = [[UIImageView alloc] init];
    bicycleImg.frame = CGRectMake(0, 0, 15, 15);
    bicycleImg.image = [UIImage imageNamed:@"bicycle"];
    [cusView addSubview:bicycleImg];
    
    UILabel *label = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
    label.text = @"龙瑞文化广场";
    // 要在设置尺寸之前调用，否则设置尺寸不准确
    [label sizeToFit];
    label.x = CGRectGetMaxX(bicycleImg.frame) + 5;
    label.centerY = bicycleImg.y + bicycleImg.height / 2;
    [cusView addSubview:label];
    
    UIImageView *arrowDown = [[UIImageView alloc] init];
    arrowDown.image = [UIImage imageNamed:@"arrowDown"];
    arrowDown.size = CGSizeMake(7, 7);
    arrowDown.x = CGRectGetMaxX(label.frame) + 5;
    arrowDown.centerY = label.y  + label.height / 2;
    [cusView addSubview:arrowDown];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
    
    if ([scrollView isEqual:self.gobalScrollView]) {
        
        if (scrollView.contentOffset.y < 966) {
            self.gobalScrollView.scrollEnabled = YES;
            self.shoppeView.scrollEnabled = NO;
        }else if (scrollView.contentOffset.y >= 990)
        {
//            NSLog(@"%f",self.gobalScrollView.contentOffset.y);
            self.gobalScrollView.scrollEnabled = NO;
            self.shoppeView.scrollEnabled = YES;
        }
    }
    
    if ([scrollView isEqual:self.shoppeView]) {
//        NSLog(@"%f",self.shoppeView.contentOffset.y);
        if (self.shoppeView.contentOffset.y <= 0.0) {
            self.gobalScrollView.scrollEnabled = YES;
            self.shoppeView.scrollEnabled = NO;
        }else if (self.shoppeView.contentOffset.y > 0)
        {
            self.gobalScrollView.scrollEnabled = NO;
            self.shoppeView.scrollEnabled = YES;
        }
    }
}

#pragma mark - UITableViewDataSource,UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return self.shoppes.count;
    }else if (section == 1)
    {
        return self.yummyShoppes.count;
    }else
    {
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINShoppeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.delegate = self;
    
    if (indexPath.section == 1) {
        cell.shoppe = self.yummyShoppes[indexPath.row];
    }else if (indexPath.section == 0)
    {
        cell.shoppe = self.shoppes[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINShoppeTableViewCell *cell = [self.shoppeView cellForRowAtIndexPath:indexPath];
    
    if (cell.cellHeight != 0) {
        
        return cell.cellHeight;
    }
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

/**
 * 点击cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    SINShoppeViewController *shoppeVC = [[SINShoppeViewController alloc] init];
    SINShoppe *shoppe = self.shoppes[indexPath.row];
    // 传递id
    shoppeVC.shop_id = shoppe.shop_id;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:shoppeVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.frame = CGRectMake(30, 10, 50, 20);
    
    if (section == 0) {
        
        titleLab.text = @"附近商户";
    }else if (section == 1)
    {
        titleLab.text = @"附近美食";
    }
    return titleLab;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"附近商户";
    }else if (section == 1)
    {
        return @"附近美食";
    }else
    {
        return @"";
    }
}

#pragma mark - SINShoppeTableViewCellDelegate
/**
 * 点击了商户cell底部优惠容器的回调
 */
- (void)shoppeCellWelfareContainerClick:(SINShoppeTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.shoppeView indexPathForCell:cell];
    [UIView animateWithDuration:0.35 animations:^{
        
        cell.height = cell.cellHeight;
    }];

    [self.shoppeView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 懒加载
static NSString *const cellID = @"shoppeCell";
- (UITableView *)shoppeView
{
    if (_shoppeView == nil) {
        _shoppeView = [[UITableView alloc] init];
        
        _shoppeView.dataSource = self;
        _shoppeView.delegate = self;
        
        [_shoppeView registerNib:[UINib nibWithNibName:NSStringFromClass([SINShoppeTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
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
        _gobalScrollView.backgroundColor = [UIColor whiteColor];
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
    }
    return _adView;
}

// 选择外卖类型的scrollView
- (SINWMTypeScrollView *)wMTypesView
{
    if (_wMTypesView == nil) {
        
        _wMTypesView = [[SINWMTypeScrollView alloc] init];
        _wMTypesView.backgroundColor = [UIColor whiteColor];
    }
    return _wMTypesView;
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

// 附近商户模型数组
- (NSMutableArray *)shoppes
{
    if (_shoppes == nil) {
        _shoppes = [NSMutableArray array];
    }
    return _shoppes;
}

// 附近美食模型数组
- (NSMutableArray *)yummyShoppes
{
    if (_yummyShoppes == nil) {
        _yummyShoppes = [NSMutableArray array];
    }
    return _yummyShoppes;
}

- (AFHTTPSessionManager *)networkMgr
{
    if (_networkMgr == nil) {
        _networkMgr = [[AFHTTPSessionManager alloc] init];
    }
    return _networkMgr;
}

@end
