//
//  SINShoppeViewController.m
//  SinWaiMai
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINShoppeViewController.h"
#import "Masonry.h"
#import "UILabel+Category.h"

/** 优惠信息label高度 */
#define welfareLabH 20
/** 普通间距 */
#define normalMargin 10
/** 优惠信息默认显示的数量 */
#define nromalWelfareAppCount 1

@interface SINShoppeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 整体scrollView */
@property (nonatomic,strong) UIScrollView *gobalView;

/** 优惠信息容器 */
@property (nonatomic,strong) UIView *welfareV;

/** 顶部模块整体view */
@property (nonatomic,strong) UIView *topModuleV;

@property (nonatomic,strong) UIView *lineV;

/** 内容scrollView */
@property (nonatomic,strong) UIScrollView *contentScrollV;

/** 爱心提醒模块 */
@property (nonatomic,strong) UIView *remindV;

@end

@implementation SINShoppeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化导航栏
    [self setupNavi];
    
    // 初始化子控件
    [self setupTopModule];
    
    // 初始化内容模块
    [self setupContentModule];
    
    // 初始化商品模块
    [self setupShoppeModule];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentScrollV]) {
        
        if (scrollView.contentOffset.y > 0) {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y);
//            self.gobalView.scrollEnabled = YES;
//            self.contentScrollV.scrollEnabled = NO;
//            self.gobalView.contentSize = CGSizeMake(SINScreenW, SINScreenH + 150);
        }else
        {
            self.contentScrollV.transform = CGAffineTransformMakeTranslation(0, -scrollView.contentOffset.y * 1.5);
        }
    }
}

static NSInteger welCount = 3;
static int welfareOpenState = 0;
/**
 * 点击了优惠信息容器
 */
- (void)welfareViewClick
{
    // 优惠信息容器的x值
    CGFloat welfareViewX = self.welfareV.y;
    
    NSInteger count = 0;
    
    CGFloat translationY = (welCount - nromalWelfareAppCount) * (welfareLabH + normalMargin);
    CGAffineTransform transform;
    if (welfareOpenState) {
        count = nromalWelfareAppCount;
        transform = CGAffineTransformIdentity;
    }else
    {
        count = welCount;
        transform = CGAffineTransformMakeTranslation(0, translationY);
    }
    
    welfareOpenState = !welfareOpenState;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.topModuleV.height =  welfareViewX + count * 30 + 5;
//        self.contentScrollV.contentOffset = CGPointMake(0, -60);
        self.contentScrollV.transform = transform;
    }];
}

/**
 * 初始顶部模块
 */
- (void)setupTopModule
{
    // 优惠信息
    CGFloat labW = welfareLabH;
    CGFloat margin = normalMargin;
    
    [self.view addSubview:self.gobalView];
    
    // 顶部模块整体
    UIView *topModuleView = [[UIView alloc] init];
    self.topModuleV = topModuleView;
    topModuleView.backgroundColor = [UIColor orangeColor];
    [self.gobalView addSubview:topModuleView];
    [topModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.gobalView);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@(110));
    }];
    
    // 头像
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"shoppeImg"];
    imgV.layer.cornerRadius = 25;
    imgV.clipsToBounds = YES;
    [topModuleView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(topModuleView).offset(20);
        make.width.height.equalTo(@(70));
    }];
    
    // 名称
    UILabel *nameLab = [UILabel createLabelWithFont:14 textColor:[UIColor whiteColor]];
    nameLab.text = @"华莱士（富华店）";
    [topModuleView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV);
        make.left.equalTo(imgV.mas_right).offset(10);
        make.right.equalTo(topModuleView).offset(-10);
        make.height.equalTo(@20);
    }];
    
    // 配送相关信息
    UILabel *infoLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
    infoLab.text = @"起送 ¥50|配送 ¥5|送达 50分钟";
    [topModuleView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab);
        make.centerY.equalTo(imgV);
        make.right.equalTo(nameLab);
        make.height.equalTo(nameLab);
    }];
    
    // 优惠信息容器
    UIView *welfareV = [[UIView alloc] init];
    [topModuleView addSubview:welfareV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(welfareViewClick)];
    [welfareV addGestureRecognizer:tap];
    self.welfareV = welfareV;
    [welfareV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLab);
        make.right.equalTo(topModuleView).offset(-margin);
        make.top.equalTo(infoLab.mas_bottom).offset(margin);
//        make.height.equalTo(@(normalCount * (labW + margin)));
        make.bottom.equalTo(topModuleView);
    }];
    
    // 添加优惠信息
    for (int i = 0; i < welCount; i++) {
        // 优惠信息图标
        UIImageView *welImgV = [[UIImageView alloc] init];
        welImgV.image = [UIImage imageNamed:@""];
        [welfareV addSubview:welImgV];
        [welImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(welfareV).offset((i * (labW + margin)));
            make.left.equalTo(welfareV);
            make.height.width.equalTo(@(labW));
        }];
        
        // 优惠信息描述label
        UILabel *welLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
        welLab.text = @"新用户在线支付立减7元";
        [welfareV addSubview:welLab];
        [welLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(welImgV.mas_right).offset(margin);
            make.top.equalTo(welImgV);
            make.height.equalTo(welImgV);
        }];
        
        // 添加右边提示
        if (i == 0) {
            // 右边箭头
            UIImageView *arrowImgV = [[UIImageView alloc] init];
            arrowImgV.image = [UIImage imageNamed:@"arrowDown"];
            [welfareV addSubview:arrowImgV];
            [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(welfareV);
                make.width.height.equalTo(@(labW));
            }];
            
            // 优惠数提醒label
            UILabel *remindLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
            remindLab.text = @"2种优惠";
            remindLab.textAlignment = NSTextAlignmentRight;
            [welfareV addSubview:remindLab];
            [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(welLab);
                make.left.equalTo(welLab.mas_right).offset(margin);
                make.height.equalTo(welLab);
                make.right.equalTo(arrowImgV.mas_left);
            }];
        }
    }
}

/**
 * 初始化内容模块
 */
- (void)setupContentModule
{
    // 创建内容scollView
    UIScrollView *contentScrollV = [[UIScrollView alloc] init];
    contentScrollV.backgroundColor = [UIColor orangeColor];
    [self.gobalView addSubview:contentScrollV];
    contentScrollV.contentSize = CGSizeMake(0, SINScreenH + 1);
    contentScrollV.delegate = self;
    self.contentScrollV = contentScrollV;
    [contentScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topModuleV);
        make.top.equalTo(self.topModuleV.mas_bottom);
        make.height.equalTo(@(SINScreenH));
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 分割线
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor whiteColor];
    lineV.alpha = 0.7;
    [contentScrollV addSubview:lineV];
    self.lineV = lineV;
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentScrollV);
        make.left.equalTo(contentScrollV);
        make.height.equalTo(@1);
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 爱心提醒模块
    UIView *remindV = [[UIView alloc] init];
    remindV.backgroundColor = self.topModuleV.backgroundColor;
    [contentScrollV addSubview:remindV];
    self.remindV = remindV;
    [remindV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom);
        make.left.equalTo(lineV);
        make.width.equalTo(@(SINScreenW));
        make.height.equalTo(@40);
    }];
    
    // 声音图标
    UIImageView *voiceImgV = [[UIImageView alloc] init];
    voiceImgV.image = [UIImage imageNamed:@"arrowDown"];
    [remindV addSubview:voiceImgV];
    [voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(remindV).offset(10);
        make.height.width.equalTo(@20);
    }];
    
    // 右侧箭头图标
    UIImageView *rightArrV = [[UIImageView alloc] init];
    rightArrV.image = [UIImage imageNamed:@"arrowDown"];
    [remindV addSubview:rightArrV];
    [rightArrV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remindV);
        make.top.equalTo(remindV).offset(normalMargin);
        make.height.width.equalTo(voiceImgV);
    }];
    
    // 提醒信息label
    UILabel *remindLab = [UILabel createLabelWithFont:12 textColor:[UIColor whiteColor]];
    remindLab.text = @"用餐高峰期请提前30分钟订餐，现在点做更有八折优惠，详情请咨询18124988815";
    [remindV addSubview:remindLab];
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voiceImgV.mas_right).offset(10);
        make.top.equalTo(voiceImgV);
        make.height.equalTo(voiceImgV);
        make.right.equalTo(rightArrV.mas_left).offset(-normalMargin * 2);
    }];
}

/**
 * 初始化商品模块
 */
- (void)setupShoppeModule
{
    // 创建导航条
    NSInteger count = 3;
    CGFloat offsetX = 0;
    CGFloat btnW = SINScreenW / 3;
    CGFloat btnH = 30;
    CGFloat diactorH = 5;
    
    // 两个tableView宽度的比例
    CGFloat tableViewP = 0.3;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        [button setTitle:@"推荐" forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor whiteColor];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.tag = i;
        
        offsetX = i * btnW;
        
        [self.contentScrollV addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindV.mas_bottom);
            make.left.equalTo(self.contentScrollV).offset(offsetX);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(btnH));
        }];
    }
    
    // 创建指示条
    UIView *diactorV = [[UIView alloc] init];
    diactorV.backgroundColor = [UIColor redColor];
    [self.contentScrollV addSubview:diactorV];
    [diactorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollV);
        make.top.equalTo(self.remindV.mas_bottom).offset(btnH);
        make.height.equalTo(@(diactorH));
        make.width.equalTo(@(btnW));
    }];
    
    // 创建商品scrollView
    UIScrollView *tabScrollV = [[UIScrollView alloc] init];
    tabScrollV.backgroundColor = [UIColor whiteColor];
    tabScrollV.contentSize = CGSizeMake(SINScreenW * 3, 0);
    [self.contentScrollV addSubview:tabScrollV];
    [tabScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollV);
        make.top.equalTo(diactorV.mas_bottom);
        make.height.equalTo(@(SINScreenH - diactorH - btnH));
        make.width.equalTo(@(SINScreenW));
    }];
    
    // 创建左侧tableView
    UITableView *typeTableV = [[UITableView alloc] init];
    typeTableV.dataSource = self;
    [self.contentScrollV addSubview:typeTableV];
    [typeTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(tabScrollV);
        make.width.equalTo(@(SINScreenW * tableViewP));
        make.height.equalTo(@(SINScreenH - diactorH - btnH));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

static NSString *typeTableViewCellID = @"typeTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *typeCell = [tableView dequeueReusableCellWithIdentifier:typeTableViewCellID];
    
    if (typeCell == nil) {
        typeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:typeTableViewCellID];
    }
    
    typeCell.textLabel.text = @"热销";
    
    return typeCell;
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(naviBackBtnClick)];
}

/**
 * 点击了返回
 */
- (void)naviBackBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIScrollView *)gobalView
{
    if (_gobalView == nil) {
        _gobalView = [[UIScrollView alloc] init];
        _gobalView.backgroundColor = [UIColor orangeColor];
        _gobalView.frame = self.view.bounds;
        _gobalView.contentSize = CGSizeMake(0, 0);
    }
    return _gobalView;
}

@end
