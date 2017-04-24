//
//  SINQRCodeShowController.m
//  QRCode
//
//  Created by apple on 22/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINQRCodeShowController.h"
#import "SINQRCodeConst.h"
#import "SINQRCodeWebView.h"

@interface SINQRCodeShowController () <SINQRCodeWebViewDelegate>

@property (nonatomic,strong) SINQRCodeWebView *webView;

@end

@implementation SINQRCodeShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    
    if (self.Bar_code) {
    
        [self showBar_codeResult];
    }else
    {
        [self showQR_codeResult];
    }
}

- (void)showBar_codeResult
{
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.Bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)showQR_codeResult
{
    CGFloat webViewX = 0;
    CGFloat webViewY = 0;
    CGFloat webViewW = SINScreenW;
    CGFloat webViewH = SINScreenH;
    self.webView = [SINQRCodeWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.QR_code]]];
    _webView.progressViewColor = [UIColor redColor];
    _webView.QRCodeWebViewDelegate = self;
    _webView.isNavigationBarOrTranslucent = NO;
    [self.view addSubview:_webView];
}

#pragma mark - SINQRCodeWebViewDelegate
- (void)webView:(SINQRCodeWebView *)webView didFinishLoadWithURL:(NSURL *)url
{
    NSLog(@"二维码页面加载完成");
    self.title = webView.navigationItemTitle;
}

- (void)setupNavi
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *left_Button = [[UIButton alloc] init];
    [left_Button setTitle:@"back" forState:UIControlStateNormal];
    [left_Button setTitleColor:[UIColor colorWithRed: 21/ 255.0f green: 126/ 255.0f blue: 251/ 255.0f alpha:1.0] forState:(UIControlStateNormal)];
    [left_Button sizeToFit];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
}

- (void)left_BarButtonItemAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)right_BarButtonItemAction
{
    [self.webView reloadData];
}

@end
