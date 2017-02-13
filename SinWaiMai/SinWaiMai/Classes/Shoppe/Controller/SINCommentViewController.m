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

@interface SINCommentViewController ()

/** 头部view */
@property (nonatomic,strong) SINHeaderView *headerView;

/** 网络管理者 */
@property (nonatomic,strong) AFHTTPSessionManager *networkMgr;

/** 商户的评价模型数组 */
@property (nonatomic,strong) SINShopComment *shopComment;

/** 用户评价模型数组 */
@property (nonatomic,strong) NSArray *comments;

@end

@implementation SINCommentViewController

- (AFHTTPSessionManager *)networkMgr
{
    if (_networkMgr == nil) {
        _networkMgr = [AFHTTPSessionManager manager];
    }
    return _networkMgr;
}

- (void)setShopComment:(SINShopComment *)shopComment
{
    _shopComment = shopComment;
    
    self.headerView.shopComment = shopComment;
}

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SINCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    
    cell.comment = self.comments[indexPath.row];
    
    return cell;
}

- (void)loadData
{
    NSDictionary *parmas = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557440.519947",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"rank":@"0",@"label_id":@"",@"utm_campaign":@"default",@"start":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"filter_tab":@"1",@"count":@"5",@"os":@"8.2",@"lat":@"2557440.291459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.758545",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":@"1613093415",@"":@"",@"":@"",};
    
    [self.networkMgr POST:@"http://client.waimai.baidu.com/mobileui/shop/v1/shopcomment" parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        [responseObject writeToFile:@"/Users/apple/desktop/commetn.plist" atomically:YES];
        
        self.shopComment = [SINShopComment shopCommentWithDict:responseObject[@"result"]];
        
        NSMutableArray *commentArrM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"result"][@"shopcomment_list"]) {
            SINComment *comment = [SINComment commentWithDict:dict];
            [commentArrM addObject:comment];
        }
        self.comments = commentArrM;
        
        self.shopComment.shopcomment_list = self.comments;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求评论数据失败 - %@",error);
        
    }];
}

static NSString *commentCellID = @"commentCellID";
/**
 * 初始化
 */
- (void)setup
{
    SINHeaderView *headerV = [SINHeaderView headerView];
    headerV.frame = CGRectMake(0, 0, 200, 200);
    self.headerView = headerV;
    self.tableView.tableHeaderView = headerV;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SINCommentCell class]) bundle:nil] forCellReuseIdentifier:commentCellID];
 
    self.tableView.estimatedRowHeight = 170;
    self.tableView.rowHeight = 170;
}

@end
