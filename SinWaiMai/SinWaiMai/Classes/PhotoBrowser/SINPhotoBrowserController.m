//
//  SINPhotoBrowserController.m
//  SinWaiMai
//
//  Created by apple on 15/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINPhotoBrowserController.h"
#import "UIImageView+SINWebCache.h"
#import "SINImageView.h"

@interface SINPhotoBrowserController () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSArray *images;

@property (nonatomic,strong) UIPinchGestureRecognizer *pinch;
@property (nonatomic,strong) UIRotationGestureRecognizer *rotation;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;

@end

@implementation SINPhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override Method
- (void)setTypeTitle:(NSString *)typeTitle
{
    _typeTitle = typeTitle;
    self.title = [NSString stringWithFormat:@"%@ %ld/%ld",typeTitle,self.index+1,self.imageUrls.count];
}

- (void)setIsSupportTap:(BOOL)isSupportTap
{
    _isSupportTap = isSupportTap;
    
    if (!isSupportTap) {
        [_scrollView removeGestureRecognizer:self.tap];
    }else
    {
        [_scrollView addGestureRecognizer:self.tap];
    }
}

- (void)setIsSupportDoubleTap:(BOOL)isSupportDoubleTap
{
    _isSupportDoubleTap = isSupportDoubleTap;
    
    if (!isSupportDoubleTap) {
        [_scrollView removeGestureRecognizer:self.doubleTap];
    }else
    {
        [_scrollView addGestureRecognizer:self.doubleTap];
    }
}

- (void)setIsSuportPinch:(BOOL)isSuportPinch
{
    _isSuportPinch = isSuportPinch;
    
    if (!isSuportPinch) {
        [_scrollView removeGestureRecognizer:self.pinch];
    }else
    {
        [_scrollView addGestureRecognizer:self.pinch];
    }
}

- (void)setIsSupportRotation:(BOOL)isSupportRotation
{
    _isSupportRotation = isSupportRotation;
    
    if (!isSupportRotation) {
     
        [_scrollView removeGestureRecognizer:self.rotation];
    }else
    {
        [_scrollView addGestureRecognizer:self.rotation];
    }
}

- (void)setIsSupportLongpress:(BOOL)isSupportLongpress
{
    _isSupportLongpress = isSupportLongpress;
    
    if (!isSupportLongpress) {
        [_scrollView addGestureRecognizer:self.longPress];
    }else
    {
        [_scrollView addGestureRecognizer:self.longPress];
    }
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    self.title = [NSString stringWithFormat:@"%@ %ld/%ld",self.typeTitle,self.index+1,self.imageUrls.count];
    
    CGFloat margin = 50;// 上下间隙
    for (int i = 0; i < imageUrls.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        NSString *str = [[imageUrls[i] componentsSeparatedByString:@"@"] firstObject];
        NSURL *url = [NSURL URLWithString:str];
        [imgV sin_setImageWithURL:url];
        imgV.x = i * SINScreenW;
        imgV.width = SINScreenW;
        imgV.y = margin;
        imgV.height = SINScreenH - 2 * margin - 64;
        [self.scrollView addSubview:imgV];
    }
    _scrollView.contentSize = CGSizeMake(imageUrls.count * SINScreenW,SINScreenH - 64);
    _scrollView.contentOffset = CGPointMake(SINScreenW * _index, 0);
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *name in imageNames) {
        UIImage *image = [UIImage imageNamed:name];
        [arr addObject:image];
    }
    
    _images = arr;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _scrollView.transform = CGAffineTransformIdentity;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x/scrollView.width) + 1;
    self.title = [NSString stringWithFormat:@"%@ %d/%ld",self.typeTitle,index,self.imageUrls.count];
}

#pragma mark - Event Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
//    UIImageWriteToSavedPhotosAlbum(self.QRCodeView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    SINLog(@"长按");
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //    SINLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    _scrollView.transform = CGAffineTransformRotate(_scrollView.transform, rotation.rotation);
    rotation.rotation = 0;
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    _scrollView.transform = CGAffineTransformScale(_scrollView.transform,pinch.scale,pinch.scale);
    pinch.scale = 1;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    _scrollView.transform = CGAffineTransformIdentity;
}

// 默认放大倍数
#define DefaultScale 1.5
static BOOL doubleTapStatue = NO;
- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    doubleTapStatue = !doubleTapStatue;
    if (doubleTapStatue) {
        _scrollView.transform = CGAffineTransformIdentity;
    }else
    {
        _scrollView.transform = CGAffineTransformScale(_scrollView.transform, DefaultScale, DefaultScale);
    }
}

#pragma mark - Lazy Load
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        self.isSuportPinch = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    }
    return _longPress;
}

- (UIPinchGestureRecognizer *)pinch
{
    if (!_pinch) {
        _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    }
    return _pinch;
}

- (UIRotationGestureRecognizer *)rotation
{
    if (!_rotation) {
        _rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
        _rotation.delegate = self;
    }
    return _rotation;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_tap setNumberOfTapsRequired:1];
    }
    return _tap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        [_doubleTap setNumberOfTapsRequired:2];
    }
    return _doubleTap;
}
@end
