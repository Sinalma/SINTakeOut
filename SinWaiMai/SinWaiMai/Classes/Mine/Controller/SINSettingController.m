//
//  SINSettingController.m
//  SinWaiMai
//
//  Created by apple on 24/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSettingController.h"
#import "SINFeedbackController.h"
#import "SINAboutUsController.h"
#import "SINPushViewController.h"

@interface SINSettingController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *data;

@end

@implementation SINSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)data
{
    return @[@"意见反馈",@"推送信息",@"服务条款",@"清理缓存",@"关于我们",@"去APP Store打赏个好评"];
}

#pragma mark - TableView Delegate,TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

static NSString * const SINDefaultText = @"清除缓存";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    NSString *str = self.data[indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.text = str;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor darkTextColor];
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        if (indexPath.row == 3) {
            
            cell.accessoryView = loadingView;
            [self countingCacheSize:cell];
        }else
        {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)countingCacheSize:(UITableViewCell *)cell
{
    // 计算大小
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        // 计算缓存大小
        NSInteger size = [@"default" cachePath].fileSize;
        CGFloat unit = 1000.0;
        NSString *sizeText = nil;
        if (size >= unit * unit * unit) { // >= 1GB
            sizeText = [NSString stringWithFormat:@"%.1fGB", size / unit / unit / unit];
        } else if (size >= unit * unit) { // >= 1MB
            sizeText = [NSString stringWithFormat:@"%.1fMB", size / unit / unit];
        } else if (size >= unit) { // >= 1KB
            sizeText = [NSString stringWithFormat:@"%.1fKB", size / unit];
        } else { // >= 0B
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        NSString *text = [NSString stringWithFormat:@"%@(%@)", SINDefaultText, sizeText];
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.textLabel.text = text;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
            // 允许点击事件
            cell.userInteractionEnabled = YES;
        }];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) { // 意见反馈
        SINFeedbackController *feedbackVC = [[SINFeedbackController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (indexPath.row == 1){ // 推送消息
        SINPushViewController *pushVC = [[SINPushViewController alloc] init];
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){ // 清理缓存
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self clearCache:cell];
    }else if (indexPath.row == 4) { // 关于我们
        SINAboutUsController *aboutUsVC = [[SINAboutUsController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if (indexPath.row == 5) {
        // 跳转到appstore百度外卖下载界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/%E7%99%BE%E5%BA%A6%E5%A4%96%E5%8D%96-%E5%93%81%E8%B4%A8%E7%94%9F%E6%B4%BB-%E5%AE%89%E5%85%A8%E9%80%81%E8%BE%BE/id911686788?l=en&mt=8"]];
    }
}

- (void)clearCache:(UITableViewCell *)cell
{
    SINHUD *hud = [SINHUD showHUDAddedTo:self.tableView animated:YES];
    hud.label.text = @"正在清除缓存";
    [hud showAnimated:YES];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:[@"default" cachePath] error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.label.text = @"清除成功";
                [hud hideAnimated:YES];
            });
            
            cell.textLabel.text = SINDefaultText;
            cell.userInteractionEnabled = NO;
        }];
    }];
}

#pragma mark - 初始化
- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_icon_white_nomal_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    self.tableView.rowHeight = 55;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, 55*self.data.count+64);
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
