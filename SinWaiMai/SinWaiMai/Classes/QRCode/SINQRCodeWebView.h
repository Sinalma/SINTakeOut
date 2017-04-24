//
//  SINQRCodeWebView.h
//  QRCode
//
//  Created by apple on 22/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SINQRCodeWebView;

@protocol SINQRCodeWebViewDelegate <NSObject>

@optional
/** 页面开始加载时调用 */
- (void)webViewDidStartLoad:(SINQRCodeWebView *)webView;
/** 内容开始返回时调用 */
- (void)webView:(SINQRCodeWebView *)webView didCommitWithURL:(NSURL *)url;
/** 页面加载失败时调用 */
- (void)webView:(SINQRCodeWebView *)webView didFailLoadWithError:(NSError *)error;
/** 页面加载完成之后调用 */
- (void)webView:(SINQRCodeWebView *)webView didFinishLoadWithURL:(NSURL *)url;

@end

@interface SINQRCodeWebView : UIView

/** 代理 */
@property (nonatomic,strong) id<SINQRCodeWebViewDelegate> QRCodeWebViewDelegate;
/** 进度条颜色 */
@property (nonatomic,strong) UIColor *progressViewColor;
/** 导航栏标题 */
@property (nonatomic,copy) NSString *navigationItemTitle;

/** 导航栏存在且有穿透效果(默认导航栏存在且有穿透效果) */
@property (nonatomic, assign) BOOL isNavigationBarOrTranslucent;

+ (instancetype)webViewWithFrame:(CGRect)frame;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)HTMLString;

- (void)reloadData;

@end
