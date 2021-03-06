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
#import "SINCycleView.h"
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
#import "MJRefresh.h"
#import "UILabel+Category.h"
#import "SINShoppeViewController.h"
#import "SINAddressController.h"
#import "SINAddress.h"
#import "SINNavigationController.h"
#import "SINLoadingHUD.h"

#define margin 10

@interface SINHomepageViewController () <UITableViewDataSource,UIScrollViewDelegate,SINShoppeTableViewCellDelegate,UITableViewDelegate,SINCycleViewDelegate>

#pragma mark - 控件
/** 整体的scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 顶部广告scrollView */
@property (nonatomic,strong) SINCycleView *cycleView;

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

/** 地址label */
@property (nonatomic,strong) UILabel *addressLabel;

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

/** 当前选择的地址模型及单个属性 */
@property (nonatomic,strong) SINAddress *curAddress;

@property (nonatomic,strong) SINLoadingHUD *loadingHUD;

@end

@implementation SINHomepageViewController
#pragma mark - 首页启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNavi];
    [self layoutGobalScrollViewChildView];
    [self setupLoadingHUD];
    [self setupRefreshing];
}

- (void)setupLoadingHUD
{
    SINLoadingHUD *hud = [SINLoadingHUD showHudToView:self.view completion:nil];
    self.loadingHUD = hud;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cycleView startCycleTimer];
    ///<<<
    self.navigationController.navigationBar.alpha = 0.0;
    ///>>>
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.cycleView stopCycleTimer];
}

- (void)dealloc
{
    self.networkMgr = nil;
    [SINNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    SINLog(@"内存就像海绵一样，挤一挤还是能出水的。");
    self.activties = nil;
    self.wMTypes = nil;
    self.adImgUrls = nil;
    self.newuesrentries = nil;
    self.welfareSignUrls = nil;
    self.networkMgr = nil;
    self.curAddress = nil;
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
 * 点击了选择地址
 */
- (void)selectAddress:(UITapGestureRecognizer *)tap
{
    SINAddressController *addressVC = [[SINAddressController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:addressVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

/**
 * 修改地址通知
 */
- (void)addressSelectNoti:(NSNotification *)noti
{
    self.curAddress = noti.object;
    
    self.addressLabel.text = self.curAddress.address.length ? self.curAddress.address : @"龙瑞文化广场";
    CGFloat labW = [self.addressLabel.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
    self.addressLabel.width = labW;
    
    [self setupRefreshing];
}

/**
 * 获取数据:外卖类型模块数据，活动清单数据
 */
- (void)sendOtherRequest
{
    NSString *loc_lng = self.curAddress.lng.length ? self.curAddress.lng : @"12617391.151377";
    NSString *loc_lat = self.curAddress.lat.length ? self.curAddress.lat : @"2557449.874939";
    
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":loc_lat,@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"os":@"8.2",@"request_time":@"2147483647",@"loc_lng":loc_lng,@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"launch",@"lat":@"",@"lng":@"",@"city_id":@"",@"address":@""};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    [self.networkMgr POST:@"http://client.waimai.baidu.com/shopui/na/v1/cliententry" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 广告模块
        NSMutableArray *adArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"activity_mobile"]) {
            [adArrM addObject:dict[@"img"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.adImgUrls = adArrM;
            self.cycleView.imageUrls = adArrM;
        });
        
        // 新人专享模块
//        NSMutableArray *newuserArrM = [NSMutableArray array];
//        if (responseObject[@"result"][@"newuserentry"][@"entries"]) {
//            for (NSDictionary *dict in responseObject[@"result"][@"newuserentry"][@"entries"]) {
//                SINNewuserentry *entry = [SINNewuserentry newuserentryWithDict:dict];
//                [newuserArrM addObject:entry];
//            }
//            self.newuesrentries = newuserArrM;
//            self.newuserEnjorView.newuesrentries = newuserArrM;
//        }
        
        // 外卖类型模块数据
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"eight_entry"]) {
            
            SINWMType *type = [SINWMType wMTypeWithDict:dict];
            [arrM addObject:type];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wMTypes = arrM;
            self.wMTypesView.wMTypes = arrM;
        });
        
        // 活动数据
        // 需要重构这个模块，根据服务器返回的活动数动态创建控件
        NSMutableArray *actArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"activity_list"]) {
            SINActivity *act = [SINActivity activityWithDict:dict];
            [actArrM addObject:act];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activties = actArrM;
            self.secondModuleView.activities = actArrM;
        });
        
        // 优惠信息图标
        NSMutableDictionary *welIconDict = [NSMutableDictionary dictionary];
        [responseObject[@"result"][@"welfare_icon"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString*  _Nonnull url, BOOL * _Nonnull stop) {
            url = [url componentsSeparatedByString:@"@"][0];
            welIconDict[key] = url;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.welfareSignUrls = welIconDict;
        });
        // 将地址字典存到沙盒
        [self.welfareSignUrls writeToFile:ShoppeWelfareIconUrlFilePath.cachePath atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"请求其他数据失败 error : %@",error);
    }];
    });// 子线程end
}

// 本方法请求数据page参数的值
static int networkPage = 1;
- (void)sendShoppesRequest
{
    // 暂定只有4页
    if (networkPage > 4) {
        return;
    }
    
    NSString *loc_lng = self.curAddress.lng.length ? self.curAddress.lng : @"12617387.766884";
    NSString *loc_lat = self.curAddress.lat.length ? self.curAddress.lat : @"2557429.095533";
    NSString *address = self.curAddress.address.length ? self.curAddress.address : @"龙瑞文化广场";
    
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":loc_lat,@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.3.3",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617387.766717",@"from":@"na-iphone",@"page":@(networkPage),@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557429.324021",@"request_time":@"2147483647",@"address":address,@"loc_lng":loc_lng,@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"paging"};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新tableView
            [self.shoppeView reloadData];
            [self.loadingHUD hideHud];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"请求商户数据失败 error : %@",error);
        networkPage -= 1;
        [self.gobalScrollView.mj_header endRefreshing];
        [self.shoppeView.mj_footer endRefreshing];
    }];
    });// 子线程end
}

/**
 * 添加和布局整体scrollView子控件
 */
- (void)layoutGobalScrollViewChildView
{
    [self.view addSubview:self.gobalScrollView];
    [self.gobalScrollView addSubview:self.cycleView];
    [self.gobalScrollView addSubview:self.wMTypesView];
    [self.gobalScrollView addSubview:self.newuserEnjorView];
    [self.gobalScrollView addSubview:self.secondModuleView];
    [self.gobalScrollView addSubview:self.thirdModuleView];
    [self.gobalScrollView addSubview:self.shoppeView];
    
    // 广告scrollView
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.gobalScrollView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(HomepageAdHeight));
    }];
    
    // 外卖类型模块
    [self.wMTypesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom);
        make.left.equalTo(self.cycleView);
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
    
    // 使模块二、三两根竖直线不对称不那么显眼浅灰色的水平分割条
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [self.gobalScrollView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondModuleView);
        make.top.equalTo(self.secondModuleView.mas_bottom);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@10);
    }];
    
    // 模块三
    [self.thirdModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom).offset(10);
        make.left.equalTo(lineV);
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
    
    // navigationBar添加子控件
    UIView *cusView = [[UIView alloc] init];
    cusView.frame = CGRectMake(0, 0, 110, 20);
    
    // 小车图标
    UIImageView *bicycleImg = [[UIImageView alloc] init];
    bicycleImg.frame = CGRectMake(0, 0, 15, 15);
    bicycleImg.image = [UIImage imageNamed:@"home_navi_address_16x16_"];
    [cusView addSubview:bicycleImg];
    
    // 地址label，需要能点击
    UILabel *label = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
    label.text = @"龙瑞文化广场";
    // 要在设置尺寸之前调用，否则设置尺寸不准确
    CGFloat labW = [label.text boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
    label.width = labW;
    label.height = 21;
    label.x = CGRectGetMaxX(bicycleImg.frame) + 5;
    label.centerY = bicycleImg.y + bicycleImg.height / 2;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress:)];
    [label addGestureRecognizer:tap];
    self.addressLabel = label;
    [cusView addSubview:label];
    
    // 向下的箭头
//    UIImageView *arrowDown = [[UIImageView alloc] init];
//    arrowDown.image = [UIImage imageNamed:@"arrowDown"];
//    arrowDown.size = CGSizeMake(7, 7);
//    arrowDown.x = CGRectGetMaxX(label.frame) + 5;
//    arrowDown.centerY = label.y  + label.height / 2;
//    [cusView addSubview:arrowDown];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setup
{
    [SINNotificationCenter addObserver:self selector:@selector(addressSelectNoti:) name:AddressSelectNotiName object:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.gobalScrollView]) {
        
        if (scrollView.contentOffset.y < 966) {
            self.gobalScrollView.scrollEnabled = YES;
            self.shoppeView.scrollEnabled = NO;
        }else if (scrollView.contentOffset.y >= 990)
        {
            self.gobalScrollView.scrollEnabled = NO;
            self.shoppeView.scrollEnabled = YES;
        }
        
        ///<<<
        CGFloat alpha = scrollView.contentOffset.y / 100;
        if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y < 64) {
            self.navigationController.navigationBar.alpha = alpha;
        }
        ///>>>>>
    }
    
    if ([scrollView isEqual:self.shoppeView]) {
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

#pragma mark - SINCycleViewDelegate
- (void)cycleView:(SINCycleView *)cycleView didClickImageAtIndex:(int)index
{
    SINLog(@"点击了广告%d",index);
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
    SINNavigationController *navi = [[SINNavigationController alloc] initWithRootViewController:shoppeVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont systemFontOfSize:14];
//    titleLab.frame = CGRectMake(30, 10, 50, 20);
    
    if (section == 0) {
        
        titleLab.text = @"   附近商户";
    }else if (section == 1)
    {
        titleLab.text = @"   附近美食";
    }
    return titleLab;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"   附近商户";
    }else if (section == 1)
    {
        return @"   附近美食";
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

- (SINCycleView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [[SINCycleView alloc] initWithFrame:CGRectMake(0, 0, SINScreenW,HomepageAdHeight)];
    }
    return _cycleView;
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
