//
//  SINShoppeViewController.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

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

/** 优惠信息label高度 */
#define welfareLabH 20
/** 普通间距 */
#define normalMargin 10
/** 优惠信息默认显示的数量 */
#define nromalWelfareAppCount 1

@interface SINShoppeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

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

/** 购物车提示view */
@property (nonatomic,strong) SINShopCarView *shopCarView;

#pragma mark - 数据
/** 存放所有数据的模型数组 */
@property (nonatomic,strong) SINShoppeInfo *shoppeInfoes;

/** 存放外卖菜单的模型数组 */
@property (nonatomic,strong) NSArray *takeoutMenues;

/** 评论控制器的view */
@property (nonatomic,strong) SINCommentViewController *commentVC;

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
}

/**
 * 初始化评价模块
 */
- (void)setupCommentModule
{
    [self.tabScrollView addSubview:self.commentVC.view];
    
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
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] init];
    
    NSDictionary *parameters = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557445.993882",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"utm_campaign":@"default",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617395.404390",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"order_id":@"",@"os":@"8.2",@"lat":@"2557445.060520",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617390.304289",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":self.shop_id};
    
    [mgr POST:@"http://client.waimai.baidu.com/shopui/na/v1/shopmenu" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
//        [responseObject[@"result"] writeToFile:@"/Users/apple/desktop/shoppeDetail.plist" atomically:YES];
        
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
        
        // 初始化子控件
        [self setupOrderFoodMoudle];
        [self setupCommentModule];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商户详情数据获取失败 error = %@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.typeTableView]) {
        return 1;
    }else if ([tableView isEqual:self.foodTableView])
    {
        return self.takeoutMenues.count;
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
        
        cell.textLabel.text = menu.catalog;
        
        return cell;
        
    }else if ([tableView isEqual:self.foodTableView])
    {
        SINFoodCell *foodCell = [tableView dequeueReusableCellWithIdentifier:foodTableViewCellID];
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[indexPath.section];
        NSArray *arr = takeoutMenu.data;
        foodCell.food = arr[indexPath.row];
        
        return foodCell;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.foodTableView]) {
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[section];
        return takeoutMenu.catalog;
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
        
        // 点击左侧cell，右侧选择相应组cell
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.foodTableView selectRowAtIndexPath:indexP animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    }else if ([tableView isEqual:self.foodTableView])
    {
        SINFoodViewController *foodVC = [[SINFoodViewController alloc] init];
        
        SINTakeoutMenu *takeoutMenu = self.takeoutMenues[indexPath.section];
        SINFood *food = takeoutMenu.data[indexPath.row];
        foodVC.food = food;
        
        [self presentViewController:foodVC animated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentScrollV]) {
        
        if (scrollView.contentOffset.y > 0) {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y);
//            self.gobalView.scrollEnabled = YES;
//            self.contentScrollV.scrollEnabled = NO;
//            self.gobalView.contentSize = CGSizeMake(SINScreenW, SINScreenH + 150);
        }else
        {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y * 1.5);
        }
    }
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
    
    CGFloat translationY = (welCount - nromalWelfareAppCount) * (welfareLabH + normalMargin);
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
//        self.contentScrollV.contentOffset = CGPointMake(0, -60);
        self.contentScrollV.transform = transform;
    }];
}

/**
 * 初始顶部模块
 */
- (void)setupTopModule
{
    // 优惠数
    NSArray *welfareArr = self.shoppeInfoes.welfare_act_info;
    welCount = welfareArr.count;
    
    // 优惠信息
    CGFloat labW = welfareLabH;
    CGFloat margin = normalMargin;
    
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
        make.top.equalTo(infoLab.mas_bottom).offset(margin);
//        make.height.equalTo(@(normalCount * (labW + margin)));
        make.bottom.equalTo(topModuleView);
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
            // 右边箭头
            UIImageView *arrowImgV = [[UIImageView alloc] init];
            arrowImgV.image = [UIImage imageNamed:@"arrowDown"];
            [welfareV addSubview:arrowImgV];
            [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(welfareV);
                make.width.height.equalTo(@(labW));
            }];
            
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
    voiceImgV.image = [UIImage imageNamed:@"arrowDown"];
    [remindV addSubview:voiceImgV];
    [voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(remindV).offset(10);
        make.height.width.equalTo(@20);
    }];
    
    // 右侧箭头图标
    UIImageView *rightArrV = [[UIImageView alloc] init];
    rightArrV.image = [UIImage imageNamed:@"arrowDown"];
    [remindV addSubview:rightArrV];
    [rightArrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remindV);
        make.top.equalTo(remindV).offset(normalMargin);
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
        make.right.equalTo(rightArrV.mas_left).offset(-normalMargin * 2);
    }];
}

/**
 * 初始化商品模块
 */
- (void)setupShoppeModule
{
    // 创建导航条
    NSInteger count = 3;
    CGFloat offsetX = 0;
    CGFloat btnW = SINScreenW / 3;
    CGFloat btnH = 30;
    CGFloat diactorH = 5;
    
    // 两个tableView宽度的比例
    CGFloat tableViewP = 0.3;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"推荐" forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor whiteColor];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.tag = i;
        
        offsetX = i * btnW;
        
        [self.contentScrollV addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindV.mas_bottom);
            make.left.equalTo(self.contentScrollV).offset(offsetX);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
    }
    
    // 创建指示条
    UIView *diactorV = [[UIView alloc] init];
    diactorV.backgroundColor = [UIColor redColor];
    [self.contentScrollV addSubview:diactorV];
    [diactorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollV);
        make.top.equalTo(self.remindV.mas_bottom).offset(btnH);
        make.height.equalTo(@(diactorH));
        make.width.equalTo(@(btnW));
    }];
    
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
    
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"orangeBG"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"orangeBG"]];
    
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(naviBackBtnClick)];
}

/**
 * 点击了返回
 */
- (void)naviBackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIScrollView *)gobalView
{
    if (_gobalView == nil) {
        _gobalView = [[UIScrollView alloc] init];
        _gobalView.backgroundColor = [UIColor orangeColor];
        _gobalView.frame = self.view.bounds;
        _gobalView.contentSize = CGSizeMake(0, 0);
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
    }
    return _tabScrollView;
}

// 点菜模块-左侧类型tableView
- (UITableView *)typeTableView
{
    if (_typeTableView == nil) {
        _typeTableView = [[UITableView alloc] init];
        _typeTableView.dataSource = self;
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
        
        _foodTableView.estimatedRowHeight = 153;
        _foodTableView.rowHeight = 153;
        
        // 注册cell
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

@end
