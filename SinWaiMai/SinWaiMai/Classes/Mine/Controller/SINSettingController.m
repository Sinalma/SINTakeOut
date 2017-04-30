//
//  SINSettingController.m
//  SinWaiMai
//
//  Created by apple on 24/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSettingController.h"

@interface SINSettingController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *data;

@end

@implementation SINSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
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
    
    if (indexPath.row == 3) {// 清理缓存
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self clearCache:cell];
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
            
            // 禁止点击事件
            cell.userInteractionEnabled = NO;
        }];
    }];
}

#pragma mark - 初始化
- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
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
