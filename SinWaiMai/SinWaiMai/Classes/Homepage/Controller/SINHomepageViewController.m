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

/** 首页顶部广告图片数量 */
#define adImageCount 3

/** 首页外卖类型数量 */
#define waiMaitypeCount 19

@interface SINHomepageViewController ()

/** 整体的scrollView */
@property (nonatomic,strong) UIScrollView *gobalScrollView;

/** 顶部广告scrollView */
@property (nonatomic,strong) UIScrollView *adScrollView;

@end

@implementation SINHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化导航栏
    [self setupNavi];
    
    // 初始化整体的scrollView
    [self setupGobalScrollView];
    
    // 给整体的scollView添加子控件
    [self setupGobalScrollViewChildView];
    
    // 给广告scrollView添加子控件
    [self setupAdScrollViewChildView];
    
    // 添加广告底部的外卖类型模块
    [self setupWaiMaiTypeContainer];
}

/**
 * 添加广告底部的外卖类型模块
 */
- (void)setupWaiMaiTypeContainer
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    
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
    
    for (int i = 0; i < adImageCount; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        x = i * w;
        
        imageV.frame = CGRectMake(x, y, w, h);
        
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d",i + 1]];
        
        [self.adScrollView addSubview:imageV];
    }
}

/**
 * 给整体的scrollView添加子控件
 */
- (void)setupGobalScrollViewChildView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.backgroundColor = [UIColor redColor];
    
    scrollView.frame = CGRectMake(0, 0, SINScreenW, 150);
    
    scrollView.contentSize = CGSizeMake(SINScreenW * adImageCount, 0);
    
    scrollView.pagingEnabled = YES;
    
    [self.gobalScrollView addSubview:scrollView];
    
    self.adScrollView = scrollView;
    
    
}

/**
 * 初始化整体的scrollView
 */
- (void)setupGobalScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.view.frame;
    
    scrollView.backgroundColor = [UIColor grayColor];
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    self.gobalScrollView = scrollView;
    
    self.gobalScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
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


//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
