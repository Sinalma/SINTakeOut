//
//  SINWebViewController.m
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWebViewController.h"

@interface SINWebViewController ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation SINWebViewController
{
    SINWebViewController *_webVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavi];
    
    [self setup];
}


- (void)setup
{
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    
    if (self.urlStr) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }else
    {
        NSLog(@"网页加载失败");
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupNavi
{
    self.title = self.naviTitle;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor orangeColor];
    }
    return _webView;
}

@end
