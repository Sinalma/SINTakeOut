//
//  SINNetWorkingManager.m
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  网络管理类，请求数据统一调用这里的接口

#import "SINNetWorkingManager.h"

#import "AFNetworking.h"

@interface SINNetWorkingManager ()

@property (nonatomic,strong) AFHTTPSessionManager *mgr;


@end

@implementation SINNetWorkingManager
{
    AFHTTPSessionManager *_mgr;
}
- (AFHTTPSessionManager *)mgr
{
    if (_mgr == nil) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

/**
 * 统一用管理者调用接口方法
 */
+ (instancetype)manager
{
    return [[AFHTTPSessionManager class] manager];
}
/*
- (void)post:(NSString *)urlStr paramters:(NSDictionary *)parameters progress:(^))
{
    self.mgr POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>
}
*/
@end
