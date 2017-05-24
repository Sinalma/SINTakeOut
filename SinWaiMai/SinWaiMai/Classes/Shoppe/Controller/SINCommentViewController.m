//
//  SINCommentViewController.m
//  SinWaiMai
//
//  Created by apple on 12/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCommentViewController.h"
#import "SINHeaderView.h"
#import "AFNetworking.h"
#import "SINShopComment.h"
#import "SINComment.h"
#import "SINCommentCell.h"
#import "MJRefresh.h"

@interface SINCommentViewController ()
/** 头部view */
@property (nonatomic,strong) SINHeaderView *headerView;
/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;
/** 商户的评价模型数组 */
@property (nonatomic,strong) SINShopComment *shopComment;
/** 用户评价模型数组 */
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSMutableArray *rowHeightArr;
@end

@implementation SINCommentViewController
#pragma mark - 懒加载
- (AFHTTPSessionManager *)networkMgr
{
    if (_networkMgr == nil) {
        _networkMgr = [AFHTTPSessionManager manager];
    }
    return _networkMgr;
}

- (NSMutableArray *)comments
{
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)rowHeightArr
{
    if (!_rowHeightArr) {
        _rowHeightArr = [NSMutableArray array];
    }
    return _rowHeightArr;
}

#pragma mark - 重写方法
- (void)setShopComment:(SINShopComment *)shopComment
{
    _shopComment = shopComment;
    
    self.headerView.shopComment = shopComment;
}

- (void)setShop_id:(NSString *)shop_id
{
    _shop_id = shop_id;
    
    [self loadData];
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView.mj_footer beginRefreshing];
}

- (void)loadMoreData
{
    [self dataWithShop_id:self.shop_id commentCount:(int)self.comments.count+5];
}

#pragma 启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

static CGFloat cellHeight = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    cell.comment = self.comments[indexPath.row];
    cellHeight = cell.cellHeight;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

// 这个方法不懂
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == self.comments.count-1) {
//        SINLog(@"需要加载新数据->%ld",indexPath.row);
//        
//        [self dataWithShop_id:self.shop_id commentCount:(int)self.comments.count + 5];
//    }
//}

- (void)loadData
{
    NSString *shopID = self.shop_id.length?self.shop_id:@"";
    
    NSDictionary *parmas = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557440.519947",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"rank":@"0",@"label_id":@"",@"utm_campaign":@"default",@"start":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"filter_tab":@"1",@"count":@"5",@"os":@"8.2",@"lat":@"2557440.291459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.758545",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":shopID};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    [self.networkMgr POST:@"http://client.waimai.baidu.com/mobileui/shop/v1/shopcomment" parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *dict in responseObject[@"result"][@"shopcomment_list"]) {
            SINComment *comment = [SINComment commentWithDict:dict];
            [self.comments addObject:comment];
        }
        
        self.shopComment = [SINShopComment shopCommentWithDict:responseObject[@"result"]];
        self.shopComment.shopcomment_list = self.comments;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"请求评论数据失败 - %@",error);
    }];
    });//子线程end
}

#pragma mark - 自定义方法
- (void)dataWithShop_id:(NSString *)shop_id commentCount:(int)commentCount
{
    NSString *shopID = self.shop_id.length?self.shop_id:@"";
    
    NSDictionary *parmas = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557440.519947",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"rank":@"0",@"label_id":@"",@"utm_campaign":@"default",@"start":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"filter_tab":@"1",@"count":@(commentCount),@"os":@"8.2",@"lat":@"2557440.291459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.758545",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":shopID};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    [self.networkMgr POST:@"http://client.waimai.baidu.com/mobileui/shop/v1/shopcomment" parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self.comments removeAllObjects];
        self.comments = nil;
    
        NSMutableArray *commentArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"shopcomment_list"]) {
            SINComment *comment = [SINComment commentWithDict:dict];
            [commentArrM addObject:comment];
        }
        self.comments = commentArrM;
        
        NSArray *commentArr = responseObject[@"result"][@"shopcomment_list"];
        NSInteger orCount = self.comments.count;
        NSInteger count = commentArr.count - orCount;
        for (NSInteger i = orCount; i < count; i++) {
            NSDictionary *dict = commentArr[i];
            SINComment *comment = [SINComment commentWithDict:dict];
            [self.comments addObject:comment];
        }
        
        self.shopComment = [SINShopComment shopCommentWithDict:responseObject[@"result"]];
        self.shopComment.shopcomment_list = self.comments;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SINLog(@"请求评论数据失败 - %@",error);
    }];// 请求结束
    });// 子线程end
}

static NSString *commentCellID = @"commentCellID";
- (void)setup
{
    SINHeaderView *headerV = [SINHeaderView headerView];
    headerV.frame = CGRectMake(0, 0, 200, 200);
    self.headerView = headerV;
    self.tableView.tableHeaderView = headerV;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINCommentCell class]) bundle:nil] forCellReuseIdentifier:commentCellID];
}

@end
