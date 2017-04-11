//
//  SINChophandViewController.m
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINChophandViewController.h"
#import "AFNetworking.h"
#import "SINTopicCell.h"
#import "SINTopTopicCell.h"
#import "SINTopic.h"
#import "SINWebViewController.h"
#import "SINHUD.h"
#import "MJRefresh.h"

/** 区别加载新数据和更多数据 */
typedef enum : NSUInteger {
    LoadDataTypeUp,// 上拉
    LoadDataTypeDown // 下拉
} LoadDataType;

@interface SINChophandViewController ()

/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;

/** 存放顶部内容段子数据 */
@property (nonatomic,strong) NSArray *topTopics;

/** 存放内容段子数据 */
@property (nonatomic,strong) NSMutableArray *topics;

/** 推荐 */
@property (nonatomic,strong) NSArray *recommendes;

/** 导航栏标题数组 */
@property (nonatomic,strong) NSArray *naviTitles;

/** 保存本获取到的指南的id */
@property (nonatomic,assign) int history_member;

/** HUD */
@property (nonatomic,strong) SINHUD *hud;

/** 保存每一次获取的数据最后一个指南的内容id */
@property (nonatomic,strong) NSString *content_id;

@end

@implementation SINChophandViewController
#pragma mark - 启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self setupHUD];
    
    [self requestHistory_member];
    
    [self setupRefreshView];
}

- (void)setupHUD
{
    SINHUD *hud = [SINHUD showHudAddTo:self.view];
    self.hud = hud;
}

/**
 * 获取首次的history_member
 */
- (void)requestHistory_member
{
    NSDictionary *dict = @{@"lat":@"2557438.450511",@"lng":@"12617391.159687",@"category_id":@"1484558763740833117",@"city_id":@"187"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getcategorylist" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        self.history_member = [responseObject[@"result"][@"history_member"] intValue];
        NSLog(@"2 - history_member -> %d",self.history_member);
        
        [self loadData:LoadDataTypeUp];
        [self loadData:LoadDataTypeUp];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面-首次获取history_member失败 = %@",error);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        
        if (scrollView.contentOffset.y <= -54) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - 自定义方法
/**
 * 获取网络数据
 */
- (void)loadData:(LoadDataType)loadDataType
{
    if (self.history_member != 0) {
        
        if (loadDataType == LoadDataTypeUp) {
            self.history_member -= 1;
            
            
        }else if (loadDataType == LoadDataTypeDown)
        {
            self.history_member += 1;
        }
    }
    
    NSString *strNum = self.history_member <= 0 ? @"" : [NSString stringWithFormat:@"%d",self.history_member];
    
    NSDictionary *dict = @{@"lat":@"2557439.354752",@"lng":@"12617393.708741",@"category_id":@"1484558763740833117",@"city_id":@"187",@"history_member":strNum};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getrecommendhistory" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject writeToFile:@"Users/apple/desktop/guide_contentList.plist" atomically:YES];
//        NSLog(@"%@",responseObject);
        self.history_member = [responseObject[@"result"][@"history_member"] intValue];
        
        for (NSDictionary *dict in responseObject[@"result"][@"content_list"]) {
            SINTopic *topic = [SINTopic topicWithDict:dict];
            if (![self.content_id isEqualToString:topic.content_id]) {
                [self.topics addObject:topic];
                self.content_id = topic.content_id;
            }else
            {
            [self.topics removeLastObject];
            }
        }
        
        [self.hud hide];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面数据加载失败 - %@",error);
    }];
}



- (void)setupRefreshView
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"加载更多指南" forState:MJRefreshStateIdle];
    [header setTitle:@"加载更多指南" forState:MJRefreshStatePulling];
    [header setTitle:@"加载更多指南" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
//    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setup
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topTopicCell"];
}

- (void)loadNewData
{
    [self loadData:LoadDataTypeDown];
}

- (void)loadMoreData
{
    [self loadData:LoadDataTypeUp];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = NO;
    
    SINTopic * topic = self.topics[indexPath.row];
    
    if ([topic.show_big_image isEqualToString:@"0"]) {
        
        SINTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
        cell.topic = topic;
        return cell;
        
        
    }else if ([topic.show_big_image isEqualToString:@"1"])
    {
        SINTopTopicCell  *cell = (SINTopTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"topTopicCell"];
        cell.topTopic = topic;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINTopic *topic = self.topics[indexPath.row];
    if ([topic.show_big_image isEqualToString:@"1"]) {
        SINTopTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        return cell.cellHeight?cell.cellHeight:175;
    }else if ([topic.show_big_image isEqualToString:@"0"])
    {
        SINTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight?cell.cellHeight:100;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SINTopic *topic = self.topics[indexPath.row];
    SINWebViewController *webVC = [[SINWebViewController alloc] init];
    webVC.urlStr = topic.detail;
    webVC.naviTitle = topic.title;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)topics
{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (AFHTTPSessionManager *)networkMgr
{
    if (_networkMgr == nil) {
        _networkMgr = [[AFHTTPSessionManager alloc] init];
    }
    return _networkMgr;
}


@end
