//
//  SINGuideViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINGuideViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "UILabel+Category.h"
#import "SINTopic.h"
#import "SINRecommend.h"
#import "SINTopicCell.h"
#import "SINTopTopicCell.h"
#import "SINRecommendViewController.h"
#import "SINFollowViewController.h"
#import "SINFoodieViewController.h"
#import "SINChophandViewController.h"
#import "SINLifeViewController.h"
#import "SINOtherViewController.h"

// 导航条高度
#define GuideNaviViewHeight 30

@interface SINGuideViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;

/** 导航条 */
@property (nonatomic,strong) UIScrollView *naviView;

/** 导航条所有lab */
@property (nonatomic,strong) NSMutableArray *naviLabs;

/** 导航条所有指示条 */
@property (nonatomic,strong) NSMutableArray *naviLines;

/** 当前选中导航条的lab */
@property (nonatomic,strong) UILabel *selLab;

/** 当前需要显示的指示条 */
@property (nonatomic,strong) UIView *selLine;

/** 推荐模块tableView */
@property (nonatomic,strong) UITableView *recommendView;

/** 吃货控制器 */
@property (nonatomic,strong) SINFoodieViewController *foodieVC;

#pragma mark - 数据
/** 存放顶部内容段子数据 */
@property (nonatomic,strong) NSArray *topTopics;

/** 存放内容段子数据 */
@property (nonatomic,strong) NSMutableArray *topics;

/** 导航栏标题数组 */
@property (nonatomic,strong) NSArray *naviTitles;

/** 推荐 */
@property (nonatomic,strong) NSArray *recommendes;

@end

@implementation SINGuideViewController

- (void)setNaviTitles:(NSArray *)naviTitles
{
    _naviTitles = naviTitles;
    
    [self setupNaviViewChildView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    
    [self loadTopData];
    
    [self setupChildView];
    
    [self setupChildVC];
    
    [self loadData];
    
    [self loadOutData];
}

- (void)setupChildVC
{
    SINFollowViewController *followVC = [[SINFollowViewController alloc] init];
    [self addChildViewController:followVC];
    
    SINFoodieViewController *foodieVC =[[SINFoodieViewController alloc] init];
    [self addChildViewController:foodieVC];
    self.foodieVC = foodieVC;
}

- (void)loadOutData
{
    NSDictionary *dict = @{@"lat":@"2557435.496479",@"lng":@"12617386.912297",@"category_id":@"0",@"city_id":@"187",@"history_member":@"96"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getrecommendhistory" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/apple/desktop/guide_outData.plist" atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面 - 后面数据加载失败 = %@",error);
    }];
}

- (void)loadTopData
{
    NSDictionary *dict = @{@"city_id":@"187"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getindex" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [responseObject writeToFile:@"Users/apple/desktop/guide_topData.plist" atomically:YES];
        
        // 导航栏标题
        NSMutableArray *naviLabStrArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"category_list"]) {
            NSString *str = dict[@"category_name"];
            [naviLabStrArrM addObject:str];
        }
        self.naviTitles = naviLabStrArrM;
        
        // 关注模块-推荐
        NSMutableArray *recommendArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"commend_list"]) {
            SINRecommend *recommend = [SINRecommend recommendWithDict:dict];
            [recommendArrM addObject:recommend];
        }
        self.recommendes = recommendArrM;
        
        // 顶部段子数据
        NSMutableArray *topTopicArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"top_content_list"]) {
            SINTopic *topTopic = [SINTopic topicWithDict:dict];
            [topTopicArrM addObject:topTopic];
        }
        self.topTopics = topTopicArrM;
        
        [self.recommendView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面-顶部模块数据加载失败 = %@",error);
    }];
}

/**
 * 获取网络数据
 */
- (void)loadData
{
    NSDictionary *dict = @{@"city_id":@"187"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getrecommendlist" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject writeToFile:@"Users/apple/desktop/guide_contentList.plist" atomically:YES];
        
        for (NSDictionary *dict in responseObject[@"result"][@"content_list"]) {
            SINTopic *topic = [SINTopic topicWithDict:dict];
            [self.topics addObject:topic];
        }
        
        [self.recommendView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面数据加载失败 - %@",error);
    }];
}

- (void)loadContentViewWithCurrentLab:(UILabel *)lab
{
    switch (lab.tag) {
        case 0:
            break;
        case 1:
            
            break;
        case 2:
        {
            self.foodieVC.view.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:self.foodieVC.view];
            [self.foodieVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.naviView);
                make.top.equalTo(self.naviView.mas_bottom);
                make.height.equalTo(@(SINScreenH - CGRectGetMaxY(self.naviView.frame) - 44));
                make.width.equalTo(@(SINScreenW));
            }];
        }
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count + self.topTopics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = NO;
//    UITableViewCell *cell = nil;
    if (indexPath.row < self.topTopics.count) {
        SINTopTopicCell  *cell = (SINTopTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"topTopicCell"];
        cell.topTopic = self.topTopics[indexPath.row];
        return cell;
    }else
    {
        SINTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
        cell.topic = self.topics[indexPath.row - self.topTopics.count];
        return cell;
    }
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.topTopics.count) {
        SINTopTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        NSLog(@"%f",cell.cellHeight);
        return cell.cellHeight?cell.cellHeight:160;
    }else
    {
        SINTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight?cell.cellHeight:100;
    }
}

/**
 * 点击了导航栏lab
 */
- (void)naviLabClick:(UITapGestureRecognizer *)tap
{
    UILabel *lab = (UILabel *)tap.view;
    
    self.selLine.hidden = YES;
    UIView *curLine = self.naviLines[lab.tag];
    curLine.hidden = NO;
    self.selLine = curLine;
    
    self.selLab.textColor = [UIColor blackColor];
    lab.textColor = [UIColor redColor];
    self.selLab = lab;
    
    [self naviScrollWithCurrentLab:lab];
    
    [self loadContentViewWithCurrentLab:lab];
}

/**
 * 让导航条滚动到合适位置
 */
- (void)naviScrollWithCurrentLab:(UILabel *)lab
{
    // 滚动到合适位置
    CGFloat labCenterX = lab.x + lab.width * 0.5;
    CGFloat naviW = self.naviView.width;
    CGFloat naviVContentW = self.naviView.contentSize.width;
    CGFloat rightW = naviVContentW - naviW;
    if (labCenterX > naviVContentW * 0.5) {
        
        if (naviVContentW > self.naviView.width) {
            
            CGFloat offx = labCenterX - naviW * 0.5;
            offx  = offx > rightW ? 0 : offx;
            if (offx == 0) {
                [self.naviView setContentOffset:CGPointMake(rightW, 0) animated:YES];
            }else
            {
                [self.naviView setContentOffset:CGPointMake(offx, 0) animated:YES];
            }
        }
    }else if (labCenterX < naviVContentW * 0.5)
    {
        
        [self.naviView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

/**
 * 初始化导航条子控件
 */
- (void)setupNaviViewChildView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    NSArray *labStrArr = self.naviTitles;
    CGFloat labCount = labStrArr.count;
    CGFloat margin = 20;
    CGFloat labH = GuideNaviViewHeight - 2;
    
    UILabel *preLab = nil;
    for (int i = 0; i < labCount; i++) {
        UILabel *lab = [UILabel createLabelWithFont:13 textColor:[UIColor blackColor]];
        lab.text = labStrArr[i];
        lab.tag = i;
        
        if (preLab) {
            lab.x = CGRectGetMaxX(preLab.frame) + 2 * margin;
        }else{
            lab.x = margin * 0.5;
        }
        lab.y = 0;
        lab.height = labH;
        CGFloat labW = [lab.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;

        lab.width = labW;
        [self.naviView addSubview:lab];
        preLab = lab;
        [self.naviLabs addObject:lab];
    
        
        // 底部标记条
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor redColor];
        line.hidden = YES;
        line.x = lab.x;
        line.y = CGRectGetMaxY(lab.frame);
        line.height = GuideNaviViewHeight - labH;
        line.width = lab.width;
        [self.naviView addSubview:line];
        [self.naviLines addObject:line];
        
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(naviLabClick:)];
        [lab addGestureRecognizer:tap];
        if (i == 0) {
            [self naviLabClick:tap];
        }
    }
    self.naviView.contentSize = CGSizeMake(CGRectGetMaxX(preLab.frame) + margin, GuideNaviViewHeight);
}

- (void)setupChildView
{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(GuideNaviViewHeight));
    }];
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(SINScreenH - CGRectGetMaxY(self.naviView.frame) - 44 - 64));
    }];
}

- (void)setupNavi
{
    [self.navigationController.navigationBar setBarTintColor:SINGobalColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"订单";
    lab.font = [UIFont systemFontOfSize:19];
    lab.frame = CGRectMake(0, 0, 20, 50);
    lab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lab;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏夹" style:UIBarButtonItemStylePlain target:self action:@selector(collectPageClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)collectPageClick
{
    NSLog(@"点击了收藏夹");
}

#pragma mark - 懒加载
- (UIScrollView *)naviView
{
    if (_naviView ==nil) {
        _naviView = [[UIScrollView alloc] init];
        _naviView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_naviView];
    }
    return _naviView;
}

- (NSMutableArray *)naviLines
{
    if (_naviLines == nil) {
        _naviLines = [NSMutableArray array];
    }
    return _naviLines;
}

- (NSMutableArray *)naviLabs
{
    if (_naviLabs == nil) {
        _naviLabs = [NSMutableArray array];
    }
    return _naviLabs;
}

- (AFHTTPSessionManager *)networkMgr
{
    if (_networkMgr == nil) {
        _networkMgr = [[AFHTTPSessionManager alloc] init];
    }
    return _networkMgr;
}

- (NSMutableArray *)topics
{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (UITableView *)recommendView
{
    if (_recommendView == nil) {
        _recommendView = [[UITableView alloc] init];
        _recommendView.delegate = self;
        _recommendView.dataSource = self;
        [_recommendView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topicCell"];
        [_recommendView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topTopicCell"];
        [self.view addSubview:_recommendView];
    }
    return _recommendView;
}

#pragma mark - 未知
- (void)temp
{
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] init];
    
    /**
     net_type	wifi
     jailbreak	0
     uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
     loc_lat	2557434.984677
     sv	4.4.0
     cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
     loc_lng	12617401.361003
     channel	appstore
     da_ext
     lng
     aoi_id
     os	8.2
     from	na-iphone
     address
     vmgdb
     model	iPhone5,2
     hot_fix	1
     isp	46001
     screen	320x568
     resid	1001
     city_id
     lat
     request_time	2147483647
     idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
     msgcuid
     alipay	0
     device_name	“Administrator”的 iPhone (4)
     */
    
    NSDictionary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557434.984677",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"os":@"8.2",@"request_time":@"2147483647",@"loc_lng":@"12617401.361003",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"lat":@"",@"lng":@"",@"city_id":@"",@"address":@"",@"return_type":@"launch"};
    
    [mgr POST:@"http://client.waimai.baidu.com/shopui/na/v1/startup" parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"%@",responseObject);
        [responseObject writeToFile:@"/Users/apple/desktop/startup2.plist" atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
