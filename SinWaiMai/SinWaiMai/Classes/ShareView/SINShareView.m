//
//  SINShareView.m
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation SINShareView
- (instancetype)init
{
    if (self = [super init]) {
        
        [self setup];
        
        [self share];
    }
    return self;
}

- (void)share
{
    //1、创建分享参数
    NSString *imgStr = [NSString stringWithFormat:@"%@",self.logo_url];
    NSArray *imageArray = @[imgStr];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"小伙伴们，帮你们物色了一家很nice的店，赶紧打开app吧......" images:imageArray url:[NSURL URLWithString:@"http://mob.com"] title:@"In my life." type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil /*要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响*/ items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state,SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
    switch (state) {
        case SSDKResponseStateSuccess:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            break;
        }
        case SSDKResponseStateFail:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}
         ];}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
}

@end
