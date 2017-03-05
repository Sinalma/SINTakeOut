//
//  SINGuideViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINGuideViewController.h"

#import "AFNetworking.h"

@interface SINGuideViewController ()

@property (nonatomic,strong) UIScrollView *scV;

@end

@implementation SINGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"指南";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:246/255.0 green:46/255.0 blue:66/255.0 alpha:1.0]];
    
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
//        [responseObject writeToFile:@"/Users/apple/desktop/startup2.plist" atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
