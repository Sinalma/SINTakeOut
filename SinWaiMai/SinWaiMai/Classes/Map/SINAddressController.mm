//
//  SINAddressController.m
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINAddressController.h"
#import "Masonry.h"
#import "SINMapViewController.h"
#import "AFNetworking.h"
#import "SINAddress.h"
#import "SINLoginViewController.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

typedef enum : NSUInteger {
    KAddressSearch,
    KAddressNear,
} AddressType;

@interface SINAddressController ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,BMKLocationServiceDelegate>

/** 导航条 */
@property (nonatomic,strong) UIView *naviBar;

/** 选择城市地址按钮 */
@property (nonatomic,strong) UIButton *choiceCityBtn;

/** 竖直分割线 */
@property (nonatomic,strong) UIView *verLine;

/** textField搜索框 */
@property (nonatomic,strong) UITextField *searchField;

/** 搜索按钮 */
@property (nonatomic,strong) UIButton *searchBtn;

/** 查看地图按钮 */
@property (nonatomic,strong) UIButton *lookMapBtn;

/** 地址tableView */
@property (nonatomic,strong) UITableView *addressView;

#pragma mark - 对象数据
/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;

/** 存放当前的地址模型 */
@property (nonatomic,strong) SINAddress *currentAddress;

/** 存放附近的地址模型数组 */
@property (nonatomic,strong) NSArray *nearAddressArr;

/** 检索对象 */
@property (nonatomic,strong) BMKPoiSearch *searcher;

/** 定位服务 */
@property (nonatomic,strong) BMKLocationService *locService;

/** 存放定位信息 */
@property (nonatomic,strong) BMKUserLocation *userLocation;

/** 当前tableView显示地址的类型 */
@property (nonatomic,assign) AddressType curAddressType;

@end

@implementation SINAddressController
#pragma mark - 程序启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setup];
    [self layoutChildView];
    
    [self startLoctionService];
    
    [self requestNearAddress];
}

#pragma mark - BMKLocationServiceDelegate,定位
/**
 * 开启定位
 */
- (void)startLoctionService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    SINLog(@"heading is %@",userLocation.heading);
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
//    SINLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/**
 * 请求网络数据
 */
- (void)requestNearAddress
{
    self.curAddressType = KAddressNear;
    
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557434.984677",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"os":@"8.2",@"request_time":@"2147483647",@"loc_lng":@"12617401.361003",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"lat":@"",@"lng":@"",@"city_id":@"",@"address":@"",@"return_type":@"launch"};
    
    [self.networkMgr POST:@"http://client.waimai.baidu.com/shopui/na/v1/startup" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [responseObject writeToFile:@"/Users/apple/desktop/startup2.plist" atomically:YES];
        
        self.currentAddress = [SINAddress addressWithDict:responseObject[@"result"][@"geo_info"][@"current_address"]];
        
        NSMutableArray *addressArrM = [NSMutableArray array];
        [addressArrM addObject:self.currentAddress];
        for (NSDictionary *dict in responseObject[@"result"][@"geo_info"][@"nearby_address"]) {
            SINAddress *address = [SINAddress addressWithDict:dict];
            [addressArrM addObject:address];
        }
        self.nearAddressArr = addressArrM;
        
        [self.addressView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"NSURLSessionDataTask-%@",error);
    }];
}

#pragma mark - <BMKPoiSearchDelegate>,检索
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSMutableArray *arrM = [NSMutableArray array];
        for (BMKPoiInfo *info in poiResultList.poiInfoList) {
            SINLog(@"%@",info.name);
            SINAddress *address = [[SINAddress alloc] init];
            address.address = info.name;
            [arrM addObject:address];
        }
        self.nearAddressArr = arrM;
        [self.addressView reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        SINLog(@"起始点有歧义");
    } else {
        SINLog(@"抱歉，未找到结果");
    }
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
}

static int curPage = 0;
#pragma mark - 点击事件
/**
 * 检索
 */
- (void)searchBtnClick
{
    self.curAddressType = KAddressSearch;
    [self.searchField endEditing:YES];
    
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = curPage;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2D{self.userLocation.location.coordinate.latitude, self.userLocation.location.coordinate.longitude};
    option.keyword = self.searchField.text.length ? self.searchField.text : @"粥";
    BOOL flag = [_searcher poiSearchNearBy:option];
//    [option release];
    if(flag)
    {
        SINLog(@"周边检索发送成功");
    }
    else
    {
        SINLog(@"周边检索发送失败");
    }
    
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 添加收货地址
 */
- (void)addBtnClick
{
    SINAccount *account = [SINAccount sharedAccount];
    if (account.isLogin) {
        [self goBack];
    }else
    {
        SINLoginViewController *loginVC = [[SINLoginViewController alloc] init];
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naviVC animated:YES completion:nil];
    }
}

- (void)lookMap
{
    SINMapViewController *mapVC = [[SINMapViewController alloc] init];
    mapVC.userLocation = self.userLocation;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearAddressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINAddress *address = self.nearAddressArr[indexPath.row];
    
    NSString *cellID = @"addressCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0 && self.curAddressType == KAddressNear) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"subtitleCellID"];
            cell.detailTextLabel.text = @"当前定位地址";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageNamed:@"icon_address_location_h_18x18_"];
        }
        cell.textLabel.text = address.address;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.curAddressType == KAddressNear) {
        
        return @"附近";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SINAddress *address = nil;
    if (indexPath.row == 0) {
        address = self.currentAddress;
    }else
    {
        address = self.nearAddressArr[indexPath.row];
    }
    
    [SINNotificationCenter postNotificationName:AddressSelectNotiName object:address];
    
    [self goBack];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.addressView) {
        [self.searchField endEditing:YES];
    }
}

- (void)layoutChildView
{
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    
    [self.choiceCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.equalTo(self.naviBar);
        make.width.equalTo(@60);
    }];
    
    [self.verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choiceCityBtn.mas_right).offset(5);
        make.top.equalTo(self.naviBar).offset(5);
        make.width.equalTo(@1);
        make.height.equalTo(self.naviBar).offset(-10);
    }];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verLine.mas_right).offset(5);
        make.width.equalTo(@140);
        make.top.height.equalTo(self.naviBar);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchField.mas_right);
        make.top.height.equalTo(self.naviBar);
        make.width.equalTo(@45);
    }];
    
    [self.lookMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBtn.mas_right);
        make.top.height.equalTo(self.naviBar);
        make.width.equalTo(@60);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.naviBar.mas_bottom);
        make.height.equalTo(@(SINScreenH - CGRectGetMaxY(self.naviBar.frame)));
    }];
}

- (void)setup
{
    [self.navigationController.navigationBar setBarTintColor:SINGobalColor];
    self.title = @"选择收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

#pragma mark - Lazy Load 
- (UIView *)naviBar
{
    if (!_naviBar) {
        _naviBar = [[UIView alloc] init];
        _naviBar.backgroundColor = SINGobalColor;
        [self.view addSubview:_naviBar];
    }
    return _naviBar;
}

- (UIButton *)choiceCityBtn
{
    if (!_choiceCityBtn)
    {
        _choiceCityBtn = [[UIButton alloc] init];
        [_choiceCityBtn setTitle:@"中山市" forState:UIControlStateNormal];
        [_choiceCityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _choiceCityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.naviBar addSubview:_choiceCityBtn];
    }
    return _choiceCityBtn;
}

- (UIView *)verLine
{
    if (!_verLine) {
        _verLine = [[UIView alloc] init];
        _verLine.backgroundColor = [UIColor darkGrayColor];
        [self.naviBar addSubview:_verLine];
    }
    return _verLine;
}

- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] init];
        _searchField.placeholder = @"请输入你的送货地址";
        _searchField.font = [UIFont systemFontOfSize:13];
        [self.naviBar addSubview:_searchField];
    }
    return _searchField;
}

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.naviBar addSubview:_searchBtn];
    }
    return _searchBtn;
}

- (UIButton *)lookMapBtn
{
    if (!_lookMapBtn) {
        _lookMapBtn = [[UIButton alloc] init];
        [_lookMapBtn setTitle:@"查看地图" forState:UIControlStateNormal];
        _lookMapBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_lookMapBtn addTarget:self action:@selector(lookMap) forControlEvents:UIControlEventTouchUpInside];
        [self.naviBar addSubview:_lookMapBtn];
    }
    return _lookMapBtn;
}

- (UITableView *)addressView
{
    if (!_addressView) {
        _addressView = [[UITableView alloc] init];
        _addressView.delegate = self;
        _addressView.dataSource = self;
        [self.view addSubview:_addressView];
    }
    return _addressView;
}

- (AFHTTPSessionManager *)networkMgr
{
    if (!_networkMgr) {
        _networkMgr = [[AFHTTPSessionManager alloc] init];
    }
    return _networkMgr;
}

@end
