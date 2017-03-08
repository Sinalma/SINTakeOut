//
//  SINRecommendViewController.m
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINRecommendViewController.h"
#import "SINTopic.h"
#import "SINTopTopicCell.h"
#import "SINTopicCell.h"
#import "AFNetworking.h"
#import "SINRecommend.h"
#import "SINWebViewController.h"

@interface SINRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

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

@end

@implementation SINRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self loadTopData];
    
    [self loadData];
}

- (void)setup
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topTopicCell"];
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
        
        [self.tableView reloadData];
        
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
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面数据加载失败 - %@",error);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count + self.topTopics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = NO;
    
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SINTopic *topic = nil;
    if (indexPath.row < self.topTopics.count) {
        topic = self.topTopics[indexPath.row];
    }else
    {
        topic = self.topics[indexPath.row - self.topTopics.count];
    }
    SINWebViewController *webVC = [[SINWebViewController alloc] init];
    webVC.urlStr = topic.detail;
    webVC.naviTitle = topic.title;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.topTopics.count) {
        SINTopTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        return cell.cellHeight?cell.cellHeight:160;
    }else
    {
        SINTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight?cell.cellHeight:100;
    }
}
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
