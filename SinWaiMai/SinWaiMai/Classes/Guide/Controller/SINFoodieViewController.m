//
//  SINFoodieViewController.m
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINFoodieViewController.h"
#import "AFNetworking.h"
#import "SINTopicCell.h"
#import "SINTopTopicCell.h"
#import "SINTopic.h"
#import "SINWebViewController.h"
#import "SINHUD.h"

@interface SINFoodieViewController ()

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

@implementation SINFoodieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self loadData];
}

- (void)setup
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINTopTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topTopicCell"];
}

- (void)loadOutData
{
    NSDictionary *dict = @{@"lat":@"2557435.496479",@"lng":@"12617386.912297",@"category_id":@"0",@"city_id":@"187",@"history_member":@"96"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getrecommendhistory" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [responseObject writeToFile:@"/Users/apple/desktop/guide_outData.plist" atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面 - 后面数据加载失败 = %@",error);
    }];
}

/**
 * 获取网络数据
 */
- (void)loadData
{
    SINHUD *hud = [SINHUD showHudAddTo:self.view];
    
    NSDictionary *dict = @{@"lat":@"2557434.78176",@"lng":@"12617394.561978",@"category_id":@"1484558763740833116",@"city_id":@"187"};
    [self.networkMgr GET:@"http://waimai.baidu.com/strategyui/getcategorylist" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [responseObject writeToFile:@"Users/apple/desktop/guide_contentList.plist" atomically:YES];
        
        for (NSDictionary *dict in responseObject[@"result"][@"content_list"]) {
            SINTopic *topic = [SINTopic topicWithDict:dict];
            [self.topics addObject:topic];
        }
        
        [hud hide];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"指南界面数据加载失败 - %@",error);
    }];
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
        
        return cell.cellHeight?cell.cellHeight:210;
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
