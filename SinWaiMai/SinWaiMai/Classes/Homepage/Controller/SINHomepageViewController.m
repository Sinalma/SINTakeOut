//
//  SINHomepageViewController.m
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  首页控制器

/**
 * 首页控制器的基本结构
 * 导航栏有中间标题栏为按钮，需要自定义，左边文字，右边为图片;导航栏右侧为按钮，左图右文字
 * 底层使用scrollView，占据整个屏幕，包括状态栏
 * scrollView最顶端是广告，暂时用collectionView实现，页数不确定，根据服务器返回的数据动态确定
 * 往下则是一个整体，整体内包含很多需要自定义的按钮个数不确定，用scrollView实现
 * 往下则是提示新人的模块，用户登录后或者不是新人有无暂未知，UIView实现,有红色背景颜色
 * 往下可能是两个固定的本分，UIView实现
 * 最后是TableView，分两组，一组标题是附近商户，另一组是图片
 */

/**
 * 具体的细节实现:
 * 当整体的scollView向上滑动，广告底部和导航栏底部平行，这个过程导航栏逐渐由透明变为白色，导航栏中间标题栏逐渐透明直至隐藏，当超过时，导航栏左侧变为三个只有图片的按钮，右侧一个UIView，UIView里右侧是textField，占位文字是服务器返回的，textfield左侧为图片。
 * 整体下拉时，最顶部出现空白，内有动画，动画包括太阳旋转，车轮旋转，任何电动车上下摆动，背景图片规律往左平移
 * 广告模块手动滑动结束后，不管是否有翻页，广告的最底部会出现类似波浪向左流动，时间相同，自动翻页时没有此效果
 * 往下的模块，手指往左边滑动时，左边的按钮会向左平移，有弹簧效果，类似甩出去的感觉，右边的按钮则向手指靠拢，效果类似左边的按钮;往右边滑动时效果则相反。
 * 当手指在商品的tableView迅速往上滑动时，并且手指没有离开屏幕，底部新出现商品cell呈现出慢慢向上靠拢手指所在cell的动画
 */

/** ad为广告的缩写 */

#import "SINHomepageViewController.h"

#import "Masonry.h"

#import "SINNormalButton.h"

#import "SINNewUserEnjorView.h"

#import "SINSecondModuleView.h"

/** 首页顶部广告图片数量 */
#define AdImageCount 3

/** 首页外卖类型数量 */
#define WMTypeCount 15

@interface SINHomepageViewController () <UIScrollViewDelegate>

/** 整体的scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 顶部广告scrollView */
@property (nonatomic,strong) UIScrollView *adScrollView;

/** 选择外卖类型的scrollView */
@property (nonatomic,strong) UIScrollView *wMTypesScrollView;

/** 存放外卖所有类型的图片名 */
@property (nonatomic,strong) NSMutableArray *wMTypesImgNs;

/** 存放外卖所有类型类型名 */
@property (nonatomic,strong) NSArray *wMTypesNames;

/** 新人专享view */
@property (nonatomic,strong) SINNewUserEnjorView *newuserEnjorView;

/** 模块二view */
@property (nonatomic,strong) SINSecondModuleView *secondModuleView;

@end

/** 整体的scrollView不能滚动，但是滚动条却能动，是否因为嵌套了scrollView而引发的手势冲突，暂时不知，现在准备改用collectionView */

@implementation SINHomepageViewController
- (SINNewUserEnjorView *)newuserEnjorView
{
    if (_newuserEnjorView == nil) {
        _newuserEnjorView = [SINNewUserEnjorView newUserEnjorView];
    }
    return _newuserEnjorView;
}

- (SINSecondModuleView *)secondModuleView
{
    if (_secondModuleView == nil) {
        _secondModuleView = [SINSecondModuleView secondModuleView];
    }
    return _secondModuleView;
}

#pragma mark - 首页启动入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNavi];
    
    // 添加和布局整体scrollView子控件
    [self layoutGobalScrollViewChildView];
    
    // 给广告scrollView添加子控件
    [self setupAdScrollViewChildView];
    
    // 给外卖类型scrollView添加子控件
    [self setupWMTypeScrollViewChildView];
    
    self.adScrollView.delegate = self;
    self.wMTypesScrollView.delegate = self;
    self.gobalScrollView.delegate = self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.gobalScrollView) {
        
        NSLog(@"gobalScrollView滚动了");
        self.adScrollView.scrollEnabled = NO;
        self.wMTypesScrollView.scrollEnabled = NO;
    }else if (scrollView == self.adScrollView)
    {
        
        NSLog(@"adScrollView滚动了");
    }else
    {
        
        NSLog(@"WMScrollView滚动了");
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
    
    // 设置整体scrollView的内容尺寸
    CGFloat contentH =HomepageAdHeight + HomepageWmTypeHeight + HomepageNewUserHeight + HomepageTwoModuleHeight;
    
    [self.gobalScrollView setContentSize:CGSizeMake(600, contentH * 2)];
    self.gobalScrollView.scrollEnabled = YES;
    self.gobalScrollView.userInteractionEnabled = YES;
}

#pragma mark - 自定义方法
/**
 * 给外卖类型ScrollView添加子控件
 */
- (void)setupWMTypeScrollViewChildView
{
    // 设置scrollView的内容尺寸
    CGFloat margin = 10;
    
    // 行数
    int rowCount = 2;
    // 一页列数
    int columnCount = 5;
    
    // 求出总共的列数
    // 这里可以用公式
    CGFloat colFloat = WMTypeCount % 2;
    int colInt = WMTypeCount / 2;
    NSLog(@"%f %d",colFloat,colInt);
    if (colFloat > 0) {
        colInt += 1;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.view.width - (columnCount + 1) * margin) / columnCount;
    CGFloat h = (150 - (rowCount + 1) * margin) / rowCount;
    
    
    CGFloat contentSizeW = margin + colInt * (w + margin);
    CGFloat contentSizeH = margin + rowCount * (h + margin);
    self.wMTypesScrollView.contentSize = CGSizeMake(contentSizeW, contentSizeH);
    
    for (int i = 0; i < WMTypeCount; i++) {
        
        SINNormalButton *btn = [[SINNormalButton alloc] init];
        
        [btn setImage:[UIImage imageNamed:self.wMTypesImgNs[i]] forState:UIControlStateNormal];
        [btn setTitle:self.wMTypesNames[i] forState:UIControlStateNormal];

        
        int row = i / colInt;
        int col = i % colInt;
        
        x = margin + (col * (w + margin));
        y = margin + (row * (h + margin));
        
        btn.frame = CGRectMake(x, y, w, h);
        
        btn.tag = i;
        [btn addTarget:self action:@selector(wMTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.wMTypesScrollView addSubview:btn];
    }
}

- (void)wMTypeBtnClick:(UIButton *)btn
{
    NSLog(@"点击了外卖类型->%@",btn.titleLabel.text);
}

/**
 * 添加和布局整体scrollView子控件
 */
- (void)layoutGobalScrollViewChildView
{
    
    // 1. 添加子控件
    [self.view addSubview:self.gobalScrollView];
    
    [self.gobalScrollView addSubview:self.adScrollView];
    
    [self.gobalScrollView addSubview:self.wMTypesScrollView];
    
    // 添加新人专享view
    [self.gobalScrollView addSubview:self.newuserEnjorView];
    
    // 模块二
    [self.gobalScrollView addSubview:self.secondModuleView];
    
    
    // 2. 布局子控件
    [self.gobalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(HomepageAdHeight));
    }];
    
    [self.wMTypesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adScrollView.mas_bottom);
        make.left.right.equalTo(self.adScrollView);
        make.height.equalTo(@(HomepageWmTypeHeight));
    }];
    
    // 新人专享view
    [self.newuserEnjorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wMTypesScrollView.mas_bottom).offset(10);
        make.left.right.equalTo(self.wMTypesScrollView);
        make.height.equalTo(@(HomepageNewUserHeight));
    }];
    
    // 模块二
    [self.secondModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newuserEnjorView.mas_bottom).offset(10);
        make.left.right.equalTo(self.newuserEnjorView);
        make.height.equalTo(@(HomepageTwoModuleHeight));
    }];
}


/**
 * 给广告scrollView添加子控件
 */
- (void)setupAdScrollViewChildView
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.adScrollView.width;
    CGFloat h = self.adScrollView.height;
    
    for (int i = 0; i < AdImageCount; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        x = i * w;
        
        imageV.frame = CGRectMake(x, y, w, h);
        
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d",i + 1]];
        
        [self.adScrollView addSubview:imageV];
    }
}

/**
 * 初始化导航栏
 */
- (void)setupNavi
{
    // 把状态栏文字改为白色
    // -[UIViewController preferredStatusBarStyle]
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


#pragma mark - 懒加载
// 整体的scrollView
- (UIScrollView *)gobalScrollView
{
    if (_gobalScrollView == nil) {
        
        _gobalScrollView = [[UIScrollView alloc] init];
        
        _gobalScrollView.showsHorizontalScrollIndicator = NO;
        _gobalScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _gobalScrollView;
}

// 广告scrollView
- (UIScrollView *)adScrollView
{
    if (_adScrollView == nil) {
        _adScrollView = [[UIScrollView alloc] init];
        
        
        _adScrollView.frame = CGRectMake(0, 0, SINScreenW, 150);
        
        _adScrollView.contentSize = CGSizeMake(SINScreenW * AdImageCount, 0);
        
        _adScrollView.pagingEnabled = YES;
        
    }
    return _adScrollView;
}

// 选择外卖类型的scrollView
- (UIScrollView *)wMTypesScrollView
{
    if (_wMTypesScrollView == nil) {
        _wMTypesScrollView = [[UIScrollView alloc] init];
        _wMTypesScrollView.showsHorizontalScrollIndicator = NO;
        _wMTypesScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _wMTypesScrollView;
}

// 存放所有外卖类型名称的数组
- (NSArray *)wMTypesNames
{
    if (_wMTypesNames == nil) {
        _wMTypesNames = @[@"餐饮",@"超市购",@"百度专送",@"早餐",@"品牌馆",@"百度糯米",@"鲜花蛋糕",@"土豪特供",@"新店特惠",@"水果生鲜",@"质享生活",@"领券",@"火锅",@"商务快食",@"送药上门"];
    }
    return _wMTypesNames;
}

// 存放所有外卖类型的图片名的数组
- (NSMutableArray *)wMTypesImgNs
{
    if (_wMTypesImgNs == nil) {
        
        _wMTypesImgNs = [NSMutableArray array];
        
        for (int i = 0; i < WMTypeCount; i++) {
            
            NSString *str = [NSString stringWithFormat:@"WMType0%d",i + 1];
            
            [_wMTypesImgNs addObject:str];
        }
    }
    
    return _wMTypesImgNs;
}

@end
