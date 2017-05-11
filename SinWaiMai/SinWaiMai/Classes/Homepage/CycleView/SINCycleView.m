//  SINCycleView.m
//
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCycleView.h"
#import "SINImageView.h"
#import "SINWebImageDownloader.h"

#define SIN_ImageView_Count 3 // UIImageView count
#define SIN_Timer_Interval 3.0 // interval for cut image
#define Screen_Width [[UIScreen mainScreen] bounds].size.width

@interface SINCycleView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *cycleView;
@property (nonatomic,strong) UIPageControl *pageControl;
/** deposit imgageViews */
@property (nonatomic,strong) NSMutableArray *imgVs;
/** timer */
@property (nonatomic,strong) NSTimer *cycleTimer;
/** index of current image */
@property (nonatomic,assign) int curIndex;
/** deposit all of images */
@property (nonatomic,strong) NSArray *images;

@end

@implementation SINCycleView

#pragma mark - Override Method
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        self.cycleView.frame = self.bounds;
        self.cycleView.contentSize = CGSizeMake(w*SIN_ImageView_Count, h);
        
        // PageControl default in the bottom.
        CGFloat page_W = 150;
        CGFloat page_H = h * 0.2;
        CGFloat page_X = w * 0.5 - page_W * 0.5;
        CGFloat page_Y = h - page_H;
        self.pageControl.frame = CGRectMake(page_X, page_Y, page_W, page_H);
        [self addSubview:self.pageControl];
        
        for (int i = 0; i < SIN_ImageView_Count; i++) {
            SINImageView *imgV= [[SINImageView alloc] init];
            imgV.frame = CGRectMake(i*w, 0, w, h);
            imgV.identify = i;
            imgV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
            [imgV addGestureRecognizer:tap];
            [self.cycleView addSubview:imgV];
            [self.imgVs addObject:imgV];
        }
    }
    return self;
}

- (void)setIsHidePageControl:(BOOL)isHidePageControl
{
    _isHidePageControl = isHidePageControl;
    self.pageControl.hidden = isHidePageControl;
}

static int downImageIndex = 0;
- (void)setImageUrls:(NSArray *)imageUrls
{
    NSMutableArray *webImages = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    for (int i = 0; i < imageUrls.count; i++) {
        
        NSString *str = nil;
        NSURL *url = nil;
        if ([imageUrls[i] isKindOfClass:[NSString class]]) {
            str = imageUrls[i];
            url = [NSURL URLWithString:str];
        }else if ([imageUrls[i] isKindOfClass:[NSURL class]])
        {
            url = imageUrls[i];
        }
        
            [[SINWebImageDownloader sharedDownloader] downloadImageWithURL:url completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                if (error) {
                    SINLog(@"SINCycleView - The image download fail at %d !",downImageIndex);
                    self.imageUrls = imageUrls;
                }
                if (image) {
                    [webImages addObject:image];
                }
                downImageIndex ++;
                
                if (downImageIndex == imageUrls.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.images = webImages;
                    });
                }
                
            }];
         }
   });
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    self.pageControl.numberOfPages = images.count;

    for (int i = 0; i < SIN_ImageView_Count; i++) {
        SINImageView *imgV = self.imgVs[i];
        switch (i) {
            case 0:
                imgV.image = images[images.count-1];
                break;
            case 1 :
                imgV.image = images[0];
                break;
            case 2:
                imgV.image = images[1];
            default:
                break;
        }
    }
    self.cycleView.contentOffset = CGPointMake(self.cycleView.frame.size.width, 0);
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    
    NSMutableArray *imgArrM = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        UIImage *img = [UIImage imageNamed:imageNames[i]];
        if (img) {
            [imgArrM addObject:img];
        }
    }
    self.images = imgArrM;
}

#pragma mark - Timer
- (void)startCycleTimer
{
    CGFloat interval = self.cycleInterval ? self.cycleInterval : SIN_Timer_Interval;
    self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(changeCycleViewContentOffset) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.cycleTimer forMode:NSRunLoopCommonModes];
}

- (void)stopCycleTimer
{
    [self.cycleTimer invalidate];
    self.cycleTimer = nil;
}

- (void)changeCycleViewContentOffset
{
    // 每次给scrollView加一个屏幕的偏移量 向右无限滚动
    [self.cycleView setContentOffset:CGPointMake(self.cycleView.contentOffset.x+self.cycleView.frame.size.width, 0) animated:YES];
}

- (SINImageView *)imgVWithIdentify:(NSInteger)identify
{
    for (SINImageView *imgV in self.imgVs) {
        if (imgV.identify == identify) return imgV;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
// 当设置偏移量并且带动画效果的时候才会执行该方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 如果是无限向右滚动,由于我们初始时偏移量就在中间,因此一直会执行该段代码
    if (self.cycleView.contentOffset.x > self.cycleView.frame.size.width) {
        
        if (self.curIndex == self.images.count - 1) {
            self.curIndex = 0;
        }else
        {
            self.curIndex ++;
        }
        
    }else
    {
        if (self.curIndex == 0) {
            self.curIndex = (int)self.images.count - 1;
        }else
        {
            self.curIndex --;
        }
    }
    
    // 当我们计算好数组下标之后,把scrollView的偏移量再重新设置回中间
    [self.cycleView setContentOffset:CGPointMake(self.cycleView.frame.size.width, 0) animated:NO];
    
    self.pageControl.currentPage = self.curIndex;
    
    [self changeImageWithIndex:self.curIndex];
}

// 当减速结束时,改变偏移量,并改变需要显示的图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 如果是无限向右滚动,由于我们初始时偏移量就在中间,因此一直会执行该段代码
    if (self.cycleView.contentOffset.x > self.cycleView.frame.size.width) {
        
        if (self.curIndex == self.images.count - 1) {
            self.curIndex = 0;
        }else
        {
            self.curIndex ++;
        }
        
    }else
    {
        if (self.curIndex == 0) {
            self.curIndex = (int)self.images.count - 1;
        }else
        {
            self.curIndex --;
        }
    }
    
    [self.cycleView setContentOffset:CGPointMake(self.cycleView.frame.size.width, 0) animated:NO];
    
    self.pageControl.currentPage = self.curIndex;
    
    [self changeImageWithIndex:self.curIndex];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopCycleTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startCycleTimer];
}

- (void)changeImageWithIndex:(int)curIndex
{
    SINImageView *imgV_Left = [self imgVWithIdentify:0];
    SINImageView *imgV_Middle = [self imgVWithIdentify:1];
    SINImageView *imgV_Right = [self imgVWithIdentify:2];
    
    if (curIndex == self.images.count - 1) {
        
        imgV_Left.image = self.images[curIndex-1];
        imgV_Middle.image = self.images[curIndex];
        imgV_Right.image = self.images[0];
        
    }else if (curIndex == 0){
        
        imgV_Left.image = self.images.lastObject;
        imgV_Middle.image = self.images[curIndex];
        imgV_Right.image = self.images[curIndex+1];
        
    }else
    {
        imgV_Left.image = self.images[curIndex-1];
        imgV_Middle.image = self.images[curIndex];
        imgV_Right.image = self.images[curIndex+1];
    }
}

- (void)imgClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(cycleView:didClickImageAtIndex:)]) {
        [self.delegate cycleView:self didClickImageAtIndex:self.curIndex];
    }
}

#pragma mark -  Lazy loading
- (UIScrollView *)cycleView
{
    if (!_cycleView) {
        _cycleView = [[UIScrollView alloc] init];
        _cycleView.pagingEnabled = YES;
        _cycleView.showsHorizontalScrollIndicator = NO;
        _cycleView.showsVerticalScrollIndicator = NO;
        _cycleView.delegate = self;
        [self addSubview:_cycleView];
    }
    return _cycleView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0 ;
        // 设置未被选中时小圆点颜色
        // set little circle color for no select statue
        _pageControl.pageIndicatorTintColor = [UIColor redColor] ;
        // 设置被选中时小圆点颜色
        // set select circle color for select statue
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor] ;
        // 默认不能手动点小圆点改变页数
        // default can not click little circle to change page
        _pageControl.enabled = NO ;
        // 把导航条设置为半透明状态
        // set navigation bar to translucent statue
        [_pageControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.00001]];
    }
    return _pageControl;
}

- (NSMutableArray *)imgVs
{
    if (!_imgVs) {
        _imgVs = [NSMutableArray array];
    }
    return _imgVs;
}

@end
