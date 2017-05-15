//
//  SINShoppeViewController.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

/**
 * 进入商户页面
 *
 * typeTableView、foodTableView不能滚动，tabScrollView可以左右滚动，contentScrollView可以往下滚动，gobalView可以向上滚动
 * gobalView增加额外滚动区域145Y值
 * 当gobalView向上滚动到不能滚动时，让typeTableView和foodTableView可以向上滚动，但不能向下，这时候contentScrollView不能滚动
 */

#import "SINShoppeViewController.h"
#import "Masonry.h"
#import "UILabel+Category.h"
#import "AFNetworking.h"
#import "SINShoppeInfo.h"
#import "SINTakeoutMenu.h"
#import "SINFood.h"
#import "SINFoodCell.h"
#import "SINShopCarView.h"
#import "UIImageView+SINWebCache.h"
#import "UIColor+SINRandomColor.h"
#import "SINFoodViewController.h"
#import "SINCommentViewController.h"
#import "SINDiscoveryView.h"
#import "SINShareView.h"
#import "SINAddress.h"
#import "SINOverviewCell.h"
#import "SINCarManager.h"

#define SINWelfareLabH 20 // 优惠信息label高度
#define SINNormalMargin 10 // 普通间距
#define nromalWelfareAppCount 1// 优惠信息默认显示的数量
#define SINTypeTableViewBGColor  [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]
#define DefaultGroups 2 // 一览表默认组数(分袋数)
#define OverViewRate 0.8 // 一览表占整屏高度的最大比例
#define SINOverviewHUDBGColor [UIColor colorWithRed:181/255.0 green:181/255.0 blue:179/255.0 alpha:0.5]

@interface SINShoppeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,SINCarOverviewDelegate,SINOverviewMgrDelegate,SINCarMgrBaseDelegate>

/** 整体scrollView */
@property (nonatomic,strong) UIScrollView *gobalView;

/** 优惠信息容器 */
@property (nonatomic,strong) UIView *welfareV;

/** 顶部模块整体view */
@property (nonatomic,strong) UIView *topModuleV;

@property (nonatomic,strong) UIView *lineV;

/** 内容scrollView */
@property (nonatomic,strong) UIScrollView *contentScrollV;

/** 爱心提醒模块 */
@property (nonatomic,strong) UIView *remindV;

/** 左侧商品类型tableView */
@property (nonatomic,strong) UITableView *typeTableView;

/** 右侧食物tableView */
@property (nonatomic,strong) UITableView *foodTableView;

/** 装tableView的scrollView */
@property (nonatomic,strong) UIScrollView *tabScrollView;

/** 指示条 */
@property (nonatomic,strong) UIView *diactorView;

/** 导航条的子按钮数组 */
@property (nonatomic,strong) NSMutableArray *naviBtns;

/** 当前选中的导航栏按钮 */
@property (nonatomic,strong) UIButton *selNaviBtn;

#pragma 购物车相关
/** 购物车提示view */
@property (nonatomic,strong) SINShopCarView *shopCarView;
/** 购物车一览表蒙板 */
@property (nonatomic,strong) UIView *overviewHUD;
/** 购物车清单tableView */
@property (nonatomic,strong) UITableView *overViewTable;
/** 覆盖顶部的HUD */
@property (nonatomic,strong) UIWindow *tempWindow;
@property (nonatomic,strong) NSArray *foodes;

#pragma mark - 数据
/** 存放所有数据的模型数组 */
@property (nonatomic,strong) SINShoppeInfo *shoppeInfoes;

/** 存放外卖菜单的模型数组 */
@property (nonatomic,strong) NSArray *takeoutMenues;

/** 评论控制器的view */
@property (nonatomic,strong) SINCommentViewController *commentVC;

/** 分享view */
@property (nonatomic,strong) SINShareView *shareView;

/** 当前地址模型 */
@property (nonatomic,strong) SINAddress *curAddress;

/** 保存上一个被选中的商户外卖类型cell */
@property (nonatomic,strong) UITableViewCell *curSelTypeCell;

/** 存放右边食物tableView所有组标题的label */
@property (nonatomic,strong) NSMutableArray *foodTitleLabels;

@property (nonatomic,strong) SINCarManager *carMgr;

@end

@implementation SINShoppeViewController
// 处理嵌套的数据
- (void)setTakeoutMenues:(NSArray *)takeoutMenues
{
    _takeoutMenues = takeoutMenues;
    
    // 嵌套数据转模型
    for (int i = 0; i < takeoutMenues.count; i++) {

        NSMutableArray *foods = [NSMutableArray array];
        
        SINTakeoutMenu *takemenu = (SINTakeoutMenu *)takeoutMenues[i];
        
        NSArray *dataArr = takemenu.data;
        
        for (int j = 0; j < dataArr.count; j++) {
            NSDictionary *dict = dataArr[j];
            
            SINFood *food = [SINFood foodWithDict:dict];
            [foods addObject:food];
        }
        takemenu.data = foods;
    }
}

#pragma mark - 启动入口
- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏
    [self setupNavi];
    
    // 请求网络数据
    [self loadData];
    
    self.gobalView.scrollEnabled = YES;
    self.contentScrollV.scrollEnabled = NO;
    self.typeTableView.scrollEnabled = NO;
    self.foodTableView.scrollEnabled = NO;
    
    [SINNotificationCenter addObserver:self selector:@selector(addressSelect:) name:AddressSelectNotiName object:nil];
    
    self.carMgr.overviewDelegate = self;
    self.carMgr.baseDelegate = self;
}

/**
 * 初始化商家详情界面
 */
- (void)setupDiscoveryModule
{
    SINDiscoveryView *disV = [SINDiscoveryView discoveryView];
    disV.shop_photo_info = self.shoppeInfoes.shop_photo_info;
    disV.shop_certification_info = self.shoppeInfoes.shop_certification_info;
    disV.welfare_basic_info = self.shoppeInfoes.welfare_basic_info;
    [self.tabScrollView addSubview:disV];
    [disV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabScrollView).offset(SINScreenW * 2);
        make.top.equalTo(self.tabScrollView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(SINScreenH+300));
    }];
//    self.tabScrollView.contentSize = CGSizeMake(0, SINScreenH * 3);
}

/**
 * 初始化评价模块
 */
- (void)setupCommentModule
{
    [self.tabScrollView addSubview:self.commentVC.view];
    [self addChildViewController:self.commentVC];
    self.commentVC.shop_id = self.shop_id;
    
    [self.commentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabScrollView).offset(SINScreenW);
        make.top.equalTo(self.tabScrollView);
        make.height.equalTo(@(SINScreenH));
        make.width.equalTo(@(SINScreenW));
    }];
    self.tabScrollView.contentSize = CGSizeMake(SINScreenW * 2, 0);
}

/**
 * 初始化点菜模块
 */
- (void)setupOrderFoodMoudle
{
    // 初始化顶部模块
    [self setupTopModule];
    
    // 初始化内容模块
    [self setupContentModule];
    
    // 初始化商品模块
    [self setupShoppeModule];
    
    // 初始化购物车提示view
    [self setupShopCarView];
}

#pragma mark - 请求数据
- (void)loadData
{
    /**
     * 这里的loc_lng、loc_lat、address暂时是写死的。
     * 貌似这些参数对单个商户没有影响，然后控制器之间传来传去也比较恶心，所以先不做修改。
     * 已经写好的监听通知得到的参数先这样，需要时再办。
     */
    NSString *loc_lng = self.curAddress.lng.length?self.curAddress.lng : @"12617390.304289";//12617390.304289
    NSString *loc_lat = self.curAddress.lat.length ? self.curAddress.lat : @"2557445.993882";//2557445.993882
    NSString *address = self.curAddress.address.length ? self.curAddress.address : @"龙瑞文化广场";//龙瑞文化广场
    
    NSDictionary *parameters = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":loc_lat,@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"utm_campaign":@"default",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617395.404390",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"order_id":@"",@"os":@"8.2",@"lat":@"2557445.060520",@"request_time":@"2147483647",@"address":address,@"loc_lng":loc_lng,@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":self.shop_id};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    [[AFHTTPSessionManager manager] POST:@"http://client.waimai.baidu.com/shopui/na/v1/shopmenu" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 商户基本信息
        NSDictionary *dict = responseObject[@"result"][@"shop_info"];
        SINShoppeInfo *shoppeinfo = [SINShoppeInfo shoppeInfoWithDict:dict];
        self.shoppeInfoes = shoppeinfo;
        
        // 外卖菜单数据
        NSMutableArray *takeoutMenues = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"takeout_menu"]) {
            SINTakeoutMenu *takeoutMenu = [SINTakeoutMenu takeoutMenuWithDict:dict];
            
            [takeoutMenues addObject:takeoutMenu];
        }
        self.takeoutMenues = takeoutMenues;
        
        dispatch_async(dispatch_get_main_queue(), ^{            
            // 初始化子控件
            [self setupOrderFoodMoudle];
            [self setupCommentModule];
            [self setupDiscoveryModule];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"商户详情数据获取失败 error = %@",error);
    }];
    });// 子线程end
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.typeTableView]) {
        return 1;
    }else if ([tableView isEqual:self.foodTableView])
    {
        return self.takeoutMenues.count;
    }else if ([tableView isEqual:self.overViewTable])
    {
        return [self overview_NumberOfSectionsInTableView:tableView];
    }else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.typeTableView]) {
        
        return self.takeoutMenues.count;
    }else if ([tableView isEqual:self.foodTableView])
    {
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[section];
    
        NSArray *arr = takeoutMenu.data;
        
        return arr.count;
    }else if ([tableView isEqual:self.overViewTable])
    {
        return [self overview_TableView:tableView numberOfRowsInSection:section];
    }
    return 10;
}

static NSString *typeTableViewCellID = @"typeTableViewCell";
static NSString *foodTableViewCellID = @"foodTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.typeTableView]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:typeTableViewCellID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:typeTableViewCellID];
        }
        
        SINTakeoutMenu *menu = self.takeoutMenues[indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = menu.catalog;
        cell.backgroundColor = SINTypeTableViewBGColor;
        
        if (indexPath.row == 0) {
            [self selectTypeCell:cell];
        }
        
        return cell;
        
    }else if ([tableView isEqual:self.foodTableView])
    {
        SINFoodCell *foodCell = [tableView dequeueReusableCellWithIdentifier:foodTableViewCellID];
        foodCell.curOrderCount = 0;
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[indexPath.section];
        NSArray *arr = takeoutMenu.data;
        foodCell.food = arr[indexPath.row];

        return foodCell;
    }else if ([tableView isEqual:self.overViewTable])
    {
        return [self overview_TableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

/**
 * 切换左侧类型tableView的选中
 */
- (void)selectTypeCell:(UITableViewCell *)cell
{
    self.curSelTypeCell.textLabel.textColor = [UIColor darkGrayColor];
    self.curSelTypeCell.backgroundColor = SINTypeTableViewBGColor;
    cell.textLabel.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor whiteColor];
    self.curSelTypeCell = cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.foodTableView]) {
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[section];
        return takeoutMenu.catalog;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.foodTableView) {
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[section];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, self.foodTableView.width, 25);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [UILabel createLabelWithFont:12 textColor:[UIColor redColor]];
        lab.x = 10;
        lab.height = 20;
        lab.width = view.width;
        lab.y = 0;
        lab.text = takeoutMenu.catalog;
        [view addSubview:lab];
        [self.foodTitleLabels addObject:lab];
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, view.height-0.35, view.width, 0.35);
        line.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line];
        return view;
    }
    return nil;
}

/**
 * 点击cell调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.typeTableView]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectTypeCell:cell];
        
        // 点击左侧cell，右侧选择相应组cell
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.foodTableView selectRowAtIndexPath:indexP animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.foodTableView deselectRowAtIndexPath:indexP animated:YES];
        
    }else if ([tableView isEqual:self.foodTableView])
    {
        SINFoodViewController *foodVC = [[SINFoodViewController alloc] init];
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[indexPath.section];
        SINFood *food = takeoutMenu.data[indexPath.row];
        foodVC.food = food;
        
        [self presentViewController:foodVC animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == self.foodTableView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section inSection:0];
        [self tableView:self.typeTableView didSelectRowAtIndexPath:indexPath];
    }
}

static CGFloat preOffsetY = 0;
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 导航条未至顶部时，gobalView可上滑，contentScrollV可下滑
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    if (self.gobalView.contentOffset.y < 145) {
        
        if (curOffsetY - preOffsetY >= 1) {
            self.gobalView.scrollEnabled = YES;
            self.contentScrollV.scrollEnabled = NO;
        }else
        {
            self.gobalView.scrollEnabled = NO;
            self.contentScrollV.scrollEnabled = YES;
        }
        
    }else if (curOffsetY - preOffsetY < 1)
    {
        self.gobalView.scrollEnabled = NO;
        self.contentScrollV.scrollEnabled = YES;
    }
    
    // gobalView置顶
    if (scrollView == self.gobalView) {
        
        if (scrollView.contentOffset.y >= 145) {
            
            [scrollView setContentOffset:CGPointMake(0, 145)];
            self.foodTableView.scrollEnabled = YES;
            self.typeTableView.scrollEnabled = YES;
        }
    }
    
    if (self.gobalView.contentOffset.y >= 145) {
        
        self.contentScrollV.scrollEnabled = NO;
        self.gobalView.scrollEnabled = YES;
    }
    
    // 两个tableView不能下滚，在offset为0时
    if (scrollView == self.foodTableView || scrollView == self.typeTableView) {
        if (scrollView.contentOffset.y < 0) {
            self.foodTableView.scrollEnabled = NO;
            self.typeTableView.scrollEnabled = NO;
        }
    }
    
    if ([scrollView isEqual:self.contentScrollV]) {
        
        if (scrollView.contentOffset.y > 0) {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y);
        }else
        {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y * 1.5);
        }
    }
    
    // 处理指示条滚动
    if (scrollView == self.tabScrollView) {
        
        self.diactorView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x / 3, 0);
    }
    
    // 粘住购物车view
    if (scrollView == self.tabScrollView) {
        self.shopCarView.transform = CGAffineTransformMakeTranslation(-scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 处理导航条选中
    if (scrollView == self.tabScrollView) {
        NSInteger naviSelCount = scrollView.contentOffset.x / SINScreenW;
        UIButton *selBtn = self.naviBtns[naviSelCount];
        
        [self selectNaviBtn:selBtn];
    }
}

#pragma mark - SINCarOverviewDelegate
//- (void)hideOverview
//{
//    [SINAnimtion sin_animateWithDuration:ShowOverTableAnimTime animations:^{
//        self.overViewTable.transform = CGAffineTransformMakeTranslation(0, SINScreenH);
//    } completion:^{
//        self.overviewHUD.hidden = YES;
//        self.tempWindow.hidden = YES;
//        self.overViewTable.hidden = YES;
//    }];
//}

- (void)carMgr_updateOrder:(NSArray *)foodes totalCount:(NSString *)totalCount
{
    SINLog(@"shopvc - %@",totalCount);
    if ([totalCount isEqualToString:@"0"]) {
        SINLog(@"-----------");
        [self carMgr_willHideOverview];
    }
}

- (void)carMgr_willShowOverview:(NSMutableArray *)foodes
{
    self.foodes = foodes;
    
    // 创建一个模糊的window覆盖导航栏上
    [self.tempWindow makeKeyAndVisible];
    
    self.overviewHUD.hidden = NO;
    self.overViewTable.hidden = NO;
    [self.overViewTable reloadData];
    
    [UIView animateWithDuration:ShowOverTableAnimTime animations:^{
        self.overViewTable.transform = CGAffineTransformIdentity;
    }];
}

- (void)carMgr_willHideOverview
{
    [SINAnimtion sin_animateWithDuration:ShowOverTableAnimTime animations:^{
        self.overViewTable.transform = CGAffineTransformMakeTranslation(0, SINScreenH);
    } completion:^{
        self.overviewHUD.hidden = YES;
        self.tempWindow.hidden = YES;
        self.overViewTable.hidden = YES;
    }];
}

//- (void)showOverviewWithFoodes:(NSArray *)foodes
//{
//    self.foodes = foodes;
//    
//    // 创建一个模糊的window覆盖导航栏上
//    [self.tempWindow makeKeyAndVisible];
//    
//    self.overviewHUD.hidden = NO;
//    self.overViewTable.hidden = NO;
//    [self.overViewTable reloadData];
//    
//    [UIView animateWithDuration:ShowOverTableAnimTime animations:^{
//        self.overViewTable.transform = CGAffineTransformIdentity;
//    }];
//}

- (NSInteger)overview_NumberOfSectionsInTableView:(UITableView *)tableView
{
    return DefaultGroups;
}

- (NSInteger)overview_TableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.foodes.count;
    }
    return 0;
}

static NSString *overViewID = @"overViewID";
- (UITableViewCell *)overview_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:overViewID];
    cell.orderCount = 0;
    SINFood *food = self.foodes[indexPath.row];
    cell.food = food;
    
    return cell;
}

/**
 * 点击了蒙板
 */
- (void)overviewHUDClick
{
    self.tempWindow.userInteractionEnabled = NO;
    self.overviewHUD.userInteractionEnabled = NO;
    [SINAnimtion sin_animateWithDuration:ShowOverTableAnimTime animations:^{
        [self.shopCarView showOrHideOverview];
    } completion:^{
        self.tempWindow.userInteractionEnabled = YES;
        self.overviewHUD.userInteractionEnabled = YES;
    }];
}


#pragma mark - 自定义监听方法
- (void)dealloc
{
    [SINNotificationCenter removeObserver:self];
}

- (void)addressSelect:(NSNotification *)noti
{
    self.curAddress = noti.object;
    [self loadData];
}

/**
 * 处理导航栏按钮的选中
 * curBtn : 传进来当前需要选中的按钮
 */
- (void)selectNaviBtn:(UIButton *)curBtn
{
    [self.selNaviBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [curBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.selNaviBtn = curBtn;
    
    // 几等份
    __block NSInteger por = 0;
    
    // 处理指示条滚动
    [UIView animateWithDuration:0.5 animations:^{
        if (self.selNaviBtn.tag > curBtn.tag) {
            por = -3;
        }else
        {
            por = 3;
        }
        
        self.diactorView.transform = CGAffineTransformMakeTranslation(curBtn.tag * (SINScreenW / por), 0);
    }];
    [self.tabScrollView setContentOffset:CGPointMake(curBtn.tag * SINScreenW, 0) animated:YES];
}

static NSInteger welCount = 3;
static int welfareOpenState = 0;
/**
 * 点击了优惠信息容器
 */
- (void)welfareViewClick
{
    welCount = self.shoppeInfoes.welfare_act_info.count;
    
    // 优惠信息容器的x值
    CGFloat welfareViewX = self.welfareV.y;
    
    NSInteger count = 0;
    
    CGFloat translationY = (welCount - nromalWelfareAppCount) * (SINWelfareLabH + SINNormalMargin);
    CGAffineTransform transform;
    if (welfareOpenState) {
        count = nromalWelfareAppCount;
        transform = CGAffineTransformIdentity;
    }else
    {
        count = welCount;
        transform = CGAffineTransformMakeTranslation(0, translationY);
    }
    
    welfareOpenState = !welfareOpenState;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.topModuleV.height =  welfareViewX + count * 30 + 5;
        self.contentScrollV.transform = transform;
    }];
}

/**
 * 点击了返回
 */
- (void)naviBackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 点击了分享
 */
- (void)shareBtnClick
{
    self.shareView.logo_url = self.shoppeInfoes.logo_url;
    self.shareView.hidden = NO;
    [self.shareView share];
}

#pragma mark - 自定义方法
/**
 * 初始顶部模块
 */
- (void)setupTopModule
{
    // 优惠数
    NSArray *welfareArr = self.shoppeInfoes.welfare_act_info;
    welCount = welfareArr.count;
    
    // 优惠信息
    CGFloat labW = SINWelfareLabH;
    CGFloat margin = SINNormalMargin;
    
    [self.view addSubview:self.gobalView];
    
    // 顶部模块整体
    UIView *topModuleView = [[UIView alloc] init];
    self.topModuleV = topModuleView;
    topModuleView.backgroundColor = [UIColor orangeColor];
    [self.gobalView addSubview:topModuleView];
    [topModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.gobalView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(105));
    }];
    
    // 头像
    UIImageView *imgV = [[UIImageView alloc] init];
    self.shoppeInfoes.logo_url = [[self.shoppeInfoes.logo_url componentsSeparatedByString:@"@"] firstObject];
    [imgV sin_setImageWithURL:[NSURL URLWithString:self.shoppeInfoes.logo_url]];
    imgV.layer.cornerRadius = 25;
    imgV.clipsToBounds = YES;
    [topModuleView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(topModuleView).offset(20);
        make.width.height.equalTo(@(70));
    }];
    
    // 名称
    UILabel *nameLab = [UILabel createLabelWithFont:14 textColor:[UIColor whiteColor]];
    NSString *nameStr = self.shoppeInfoes.shop_name;
    nameLab.text = nameStr;
    [topModuleView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV);
        make.left.equalTo(imgV.mas_right).offset(10);
        make.right.equalTo(topModuleView).offset(-10);
        make.height.equalTo(@20);
    }];
    
    // 配送相关信息
    UILabel *infoLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
    
    infoLab.text = @"起送 ¥50|配送 ¥5|送达 50分钟";
    infoLab.text = [NSString stringWithFormat:@"起送 ¥%@|配送 ¥%@|送达 %@分钟",self.shoppeInfoes.takeout_price,self.shoppeInfoes.takeout_cost,self.shoppeInfoes.delivery_time];
    [topModuleView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.centerY.equalTo(imgV);
        make.right.equalTo(nameLab);
        make.height.equalTo(nameLab);
    }];
    
    // 优惠信息容器
    UIView *welfareV = [[UIView alloc] init];
    [topModuleView addSubview:welfareV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(welfareViewClick)];
    [welfareV addGestureRecognizer:tap];
    self.welfareV = welfareV;
    [welfareV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLab);
        make.right.equalTo(topModuleView).offset(-margin);
        make.top.equalTo(infoLab.mas_bottom).offset(margin);        make.bottom.equalTo(topModuleView);
    }];
    
    // 添加优惠信息
    for (int i = 0; i < welCount; i++) {
        // 优惠信息图标
        UIImageView *welImgV = [[UIImageView alloc] init];
        NSString *welfareImgUrl = welfareArr[i][@"url"];
        welfareImgUrl = [[welfareImgUrl componentsSeparatedByString:@"@"] firstObject];
        [welImgV sin_setImageWithURL:[NSURL URLWithString:welfareImgUrl]];
        [welfareV addSubview:welImgV];
        [welImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(welfareV).offset((i * (labW + margin)));
            make.left.equalTo(welfareV);
            make.height.width.equalTo(@(labW));
        }];
        
        // 优惠信息描述label
        UILabel *welLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
        welLab.text = welfareArr[i][@"msg"];
        [welfareV addSubview:welLab];
        [welLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(welImgV.mas_right).offset(margin);
            make.top.equalTo(welImgV);
            make.height.equalTo(welImgV);
        }];
        
        // 添加右边提示
        if (i == 0) {
            UILabel *arrowImgV = [UILabel createLabelWithFont:19 textColor:[UIColor whiteColor]];
            arrowImgV.text = @"^";
            arrowImgV.textAlignment = NSTextAlignmentCenter;
            [welfareV addSubview:arrowImgV];
            [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(welfareV).offset(-3);
                make.right.equalTo(welfareV);
                make.width.height.equalTo(@(20));
            }];
            arrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
            
            // 优惠数提醒label
            UILabel *remindLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
            remindLab.text = [NSString stringWithFormat:@"%ld个活动",(long)welCount];
            remindLab.textAlignment = NSTextAlignmentRight;
            [welfareV addSubview:remindLab];
            [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(welLab);
                make.left.equalTo(welLab.mas_right).offset(margin);
                make.height.equalTo(welLab);
                make.right.equalTo(arrowImgV.mas_left);
            }];
        }
    }
}

/**
 * 初始化内容模块
 */
- (void)setupContentModule
{
    // 创建内容scollView
    UIScrollView *contentScrollV = [[UIScrollView alloc] init];
    contentScrollV.backgroundColor = [UIColor orangeColor];
    [self.gobalView addSubview:contentScrollV];
    contentScrollV.contentSize = CGSizeMake(0, SINScreenH + 1);
    contentScrollV.delegate = self;
    self.contentScrollV = contentScrollV;
    [contentScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topModuleV);
        make.top.equalTo(self.topModuleV.mas_bottom);
        make.height.equalTo(@(SINScreenH));
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 分割线
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor whiteColor];
    lineV.alpha = 0.7;
    [contentScrollV addSubview:lineV];
    self.lineV = lineV;
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentScrollV);
        make.left.equalTo(contentScrollV);
        make.height.equalTo(@1);
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 爱心提醒模块
    UIView *remindV = [[UIView alloc] init];
    remindV.backgroundColor = self.topModuleV.backgroundColor;
    [contentScrollV addSubview:remindV];
    self.remindV = remindV;
    [remindV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom);
        make.left.equalTo(lineV);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@40);
    }];
    
    // 声音图标
    UIImageView *voiceImgV = [[UIImageView alloc] init];
    voiceImgV.backgroundColor = [UIColor clearColor];
    voiceImgV.image = [UIImage imageNamed:@"voice"];
    [remindV addSubview:voiceImgV];
    [voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(remindV).offset(10);
        make.height.width.equalTo(@15);
    }];
    [voiceImgV setTintColor:[UIColor whiteColor]];

    UILabel *rightArrV = [UILabel createLabelWithFont:16 textColor:[UIColor whiteColor]];
    rightArrV.text = @">";
    [remindV addSubview:rightArrV];
    [rightArrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remindV).offset(-10);
        make.top.equalTo(remindV).offset(SINNormalMargin);
        make.height.width.equalTo(voiceImgV);
    }];
    
    // 提醒信息label
    UILabel *remindLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
    remindLab.text = @"用餐高峰期请提前30分钟订餐，现在点做更有八折优惠，详情请咨询18124988815";
    [remindV addSubview:remindLab];
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voiceImgV.mas_right).offset(10);
        make.top.equalTo(voiceImgV);
        make.height.equalTo(voiceImgV);
        make.right.equalTo(rightArrV.mas_left).offset(-SINNormalMargin * 2);
    }];
}

/**
 * 初始化商品模块
 */
- (void)setupShoppeModule
{
    NSArray *btnStrArr = @[@"推荐",@"评论",@"商家"];
    
    // 创建导航条
    NSInteger count = btnStrArr.count;
    CGFloat offsetX = 0;
    CGFloat btnW = SINScreenW / count;
    CGFloat btnH = 30;
    CGFloat diactorH = 3;
    
    // 两个tableView宽度的比例
    CGFloat tableViewP = 0.25;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:btnStrArr[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.tag = i;
        [button addTarget:self action:@selector(selectNaviBtn:) forControlEvents:UIControlEventTouchUpInside];
        offsetX = i * btnW;
        [self.contentScrollV addSubview:button];
        
        // 默认选中首个按钮
        if (i == 0) {
            [self selectNaviBtn:button];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindV.mas_bottom);
            make.left.equalTo(self.contentScrollV).offset(offsetX);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
        
        [self.naviBtns addObject:button];
    }
    
    // 创建指示条
    // 白色
    UIView *diactorBgV = [[UIView alloc] init];
    diactorBgV.backgroundColor = [UIColor whiteColor];
    [self.contentScrollV addSubview:diactorBgV];
    [diactorBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollV);
        make.top.equalTo(self.remindV.mas_bottom).offset(btnH);
        make.height.equalTo(@(diactorH));
        make.width.equalTo(@(SINScreenW));
    }];
    
    UIView *diactorV = [[UIView alloc] init];
    diactorV.backgroundColor = [UIColor redColor];
    [diactorBgV addSubview:diactorV];
    [diactorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diactorBgV);
        make.top.equalTo(diactorBgV);
        make.height.equalTo(@(diactorH));
        make.width.equalTo(@(btnW));
    }];
    self.diactorView = diactorV;
    
    // 创建商品scrollView
    [self.contentScrollV addSubview:self.tabScrollView];
    [self.tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollV);
        make.top.equalTo(diactorV.mas_bottom);
        make.height.equalTo(@(SINScreenH - diactorH - btnH));
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 创建左侧tableView
    [self.tabScrollView addSubview:self.typeTableView];
    [self.typeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.tabScrollView);
        make.width.equalTo(@(SINScreenW * tableViewP));
        make.height.equalTo(@(SINScreenH - diactorH - btnH));
    }];
    
    // 右侧食物tableView
    [self.tabScrollView addSubview:self.foodTableView];
    [self.foodTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeTableView.mas_right);
        make.top.equalTo(self.typeTableView);
        make.width.equalTo(@(SINScreenW * (1 - tableViewP)));
        make.height.equalTo(self.typeTableView);
    }];
}

/**
 * 初始化购物车提示view
 */
- (void)setupShopCarView
{
    SINShopCarView *shopCarV = [SINShopCarView shopCarView];
    shopCarV.shopInfo = self.shoppeInfoes;
    shopCarV.delegate = self;
    self.shopCarView = shopCarV;
    [self.view addSubview:shopCarV];
    [shopCarV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(44));
    }];
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStyleDone target:self action:@selector(naviBackBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark - 懒加载
// 最底层scrollView
- (UIScrollView *)gobalView
{
    if (_gobalView == nil) {
        _gobalView = [[UIScrollView alloc] init];
        _gobalView.backgroundColor = [UIColor orangeColor];
        _gobalView.frame = self.view.bounds;
        _gobalView.contentSize = CGSizeMake(0, SINScreenH+145);
        _gobalView.delegate = self;
    }
    return _gobalView;
}

// 商品scrollView
- (UIScrollView *)tabScrollView
{
    if (_tabScrollView == nil) {
        _tabScrollView = [[UIScrollView alloc] init];
        _tabScrollView.backgroundColor = [UIColor whiteColor];
        _tabScrollView.contentSize = CGSizeMake(SINScreenW * 3, 0);
        _tabScrollView.pagingEnabled = YES;
        _tabScrollView.delegate = self;
    }
    return _tabScrollView;
}

// 点菜模块-左侧类型tableView
- (UITableView *)typeTableView
{
    if (_typeTableView == nil) {
        _typeTableView = [[UITableView alloc] init];
        _typeTableView.backgroundColor = SINTypeTableViewBGColor;
        _typeTableView.dataSource = self;
        _typeTableView.separatorStyle = NO;
        _typeTableView.delegate = self;
    }
    return _typeTableView;
}

// 点菜模块-右侧食物tableView
- (UITableView *)foodTableView
{
    if (_foodTableView == nil) {
        _foodTableView = [[UITableView alloc] init];
        _foodTableView.dataSource = self;
        _foodTableView.delegate = self;
        _foodTableView.separatorStyle = NO;
        _foodTableView.estimatedRowHeight = 153;
        _foodTableView.rowHeight = 153;
        [_foodTableView registerNib:[UINib nibWithNibName:@"SINFoodCell" bundle:nil] forCellReuseIdentifier:foodTableViewCellID];
    }
    return _foodTableView;
}

- (SINCommentViewController *)commentVC
{
    if (_commentVC == nil) {
        _commentVC = [[SINCommentViewController alloc] init];
    }
    return _commentVC;
}

- (NSMutableArray *)naviBtns
{
    if (_naviBtns == nil) {
        _naviBtns = [NSMutableArray array];
    }
    return _naviBtns;
}

- (SINShareView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[SINShareView alloc] init];
        _shareView.frame = CGRectMake(0, 0, SINScreenW, SINScreenH);
        [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
        _shareView.hidden = YES;
    }
    return _shareView;
}

- (NSMutableArray *)foodTitleLabels
{
    if (!_foodTitleLabels) {
        _foodTitleLabels = [NSMutableArray array];
    }
    return _foodTitleLabels;
}

#pragma mark - 购物车一览表懒加载
- (UIView *)overviewHUD
{
    if (!_overviewHUD) {
        _overviewHUD = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SINScreenW,SINScreenH-64-self.shopCarView.height)];
        _overviewHUD.hidden = YES;
        _overviewHUD.backgroundColor = SINOverviewHUDBGColor;
        [self.view insertSubview:_overviewHUD belowSubview:self.shopCarView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overviewHUDClick)];
        [_overviewHUD addGestureRecognizer:tap];
    }
    return _overviewHUD;
}

- (UIWindow *)tempWindow
{
    if (!_tempWindow) {
        _tempWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SINScreenW, 64)];
        _tempWindow.backgroundColor = SINOverviewHUDBGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overviewHUDClick)];
        [_tempWindow addGestureRecognizer:tap];
    }
    return _tempWindow;
}

- (UITableView *)overViewTable
{
    if (!_overViewTable) {
        _overViewTable = [[UITableView alloc] init];
        _overViewTable.delegate = self;
        _overViewTable.dataSource = self;
        _overViewTable.frame = CGRectMake(0, (1-OverViewRate)*SINScreenH, self.overviewHUD.width, OverViewRate*SINScreenH);//self.overviewHUD.height
        _overViewTable.rowHeight = 55;
        _overViewTable.estimatedRowHeight = 65;
        
        [self.overviewHUD addSubview:_overViewTable];
        _overViewTable.transform = CGAffineTransformMakeTranslation(0, +OverViewRate*_overViewTable.height);
        [_overViewTable registerNib:[UINib nibWithNibName:NSStringFromClass([SINOverviewCell class]) bundle:nil] forCellReuseIdentifier:overViewID];
    }
    return _overViewTable;
}

- (SINCarManager *)carMgr
{
    if (!_carMgr) {
        _carMgr = [[SINCarManager alloc] init];
    }
    return _carMgr;
}

@end
