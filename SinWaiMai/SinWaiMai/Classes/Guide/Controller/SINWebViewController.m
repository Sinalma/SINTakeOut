//
//  SINWebViewController.m
//  SinWaiMai
//
//  Created by apple on 08/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWebViewController.h"

@interface SINWebViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) SINHUD *loadHUD;

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
    self.webView.delegate = self;
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    
    SINHUD *hud = [SINHUD showHudAddTo:self.view];
    self.loadHUD = hud;
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if (self.urlStr) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide];
            [self clickBack];
        });
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadHUD hide];
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
    }
    return _webView;
}

@end
