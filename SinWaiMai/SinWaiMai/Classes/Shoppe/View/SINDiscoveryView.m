//
//  SINDiscoveryView.m
//  SinWaiMai
//
//  Created by apple on 25/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINDiscoveryView.h"
#import "UILabel+Category.h"
#import "UIImageView+SINWebCache.h"
#import "SINPhotoBrowserController.h"
#import "SINImageView.h"
#import "SINAccount.h"

#define DiscoveryIconWH 20
#define DiscoveryMargin 10
#define DiscoveryImgVW 90
#define DiscoveryImgVH 60
#define DiscoveryLabFont 12

@interface SINDiscoveryView ()

// 子控件动态创建模块的共同view
@property (weak, nonatomic) IBOutlet UIView *dynamicContentView;
// 电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
// 举报
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;

@property (nonatomic,assign) CGFloat tangY;

@property (nonatomic,assign) CGFloat zhengY;

@end

@implementation SINDiscoveryView

+ (instancetype)discoveryView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINDiscoveryView class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)];
    self.phoneLabel.userInteractionEnabled = YES;
    [self.phoneLabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(report)];
    self.reportLabel.userInteractionEnabled = YES;
    [self.reportLabel addGestureRecognizer:reportTap];
}

- (void)setShop_phone:(NSString *)shop_phone
{
    _shop_phone = shop_phone;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ >",shop_phone];
}

- (void)setWelfare_basic_info:(NSArray *)welfare_basic_info
{
    _welfare_basic_info = welfare_basic_info;
    
    CGFloat stayY = [self createLabImgModuleWithIconUrl:@"tang" labStr:@"堂景食堂" imgUrls:_shop_photo_info supV:self.dynamicContentView startY:0] + 10;
    self.tangY = stayY;
    CGFloat endY = [self createLabImgModuleWithIconUrl:@"zheng" labStr:@"资质证书" imgUrls:_shop_certification_info supV:_dynamicContentView startY:stayY] + 10;
    self.zhengY = endY;
    
    // 封底线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor darkGrayColor];
    line.frame = CGRectMake(0, endY + 50, self.dynamicContentView.width, 0.3);
    [self.dynamicContentView addSubview:line];
}

// 返回最后一个的最大Y值
- (CGFloat)createLabImgModuleWithIconUrl:(NSString *)iconUrl labStr:(NSString *)labStr imgUrls:(NSArray *)imgUrls supV:(UIView *)supV startY:(CGFloat)startY
{
    NSInteger tangImgCount = imgUrls.count;
    // 图标
    UIImageView *tangIconV = [[UIImageView alloc] init];
    tangIconV.image = [UIImage imageNamed:iconUrl];
    [supV addSubview:tangIconV];
    tangIconV.frame = CGRectMake(0, startY, DiscoveryIconWH, DiscoveryIconWH);
    
    // 类别lab
    UILabel *tangLab = [UILabel createLabelWithFont:DiscoveryLabFont textColor:[UIColor darkGrayColor]];
    tangLab.text = labStr;
    [supV addSubview:tangLab];
    tangLab.x = CGRectGetMaxX(tangIconV.frame) + DiscoveryMargin;
    tangLab.y = tangIconV.y;
    tangLab.height = DiscoveryIconWH;
    tangLab.width = 100;
    
    // 正图
    SINImageView *preTangImgV = nil;
    for (int i = 0; i < tangImgCount; i++) {
        SINImageView *imgV = [[SINImageView alloc] initWithFrame:CGRectMake(i * (DiscoveryImgVW + DiscoveryMargin), CGRectGetMaxY(tangIconV.frame) + DiscoveryMargin, DiscoveryImgVW, DiscoveryImgVH)];
        NSString *str = [[imgUrls[i] componentsSeparatedByString:@"@"] firstObject];
        NSURL *url = [NSURL URLWithString:str];
        [imgV sin_setImageWithURL:url];
        [supV addSubview:imgV];
        imgV.identify = i;
        imgV.typeTitle = labStr;
        UITapGestureRecognizer *tap = nil;
        if ([iconUrl isEqualToString:@"tang"]) {
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookTangBigPicture:)];
        }else if ([iconUrl isEqualToString:@"zheng"])
        {
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookZhengBigPicture:)];
        }
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
        if (i == tangImgCount - 1) {
            preTangImgV = imgV;
        }
    }
    return CGRectGetMaxY(preTangImgV.frame);
}

- (void)jumpToBrowserVC:(NSArray *)imageUrls index:(NSInteger)index typeTitle:(NSString *)typeTitle
{
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naviVC = (UINavigationController *)rootVC.presentedViewController;
    
    SINPhotoBrowserController *pbVC = [[SINPhotoBrowserController alloc] init];
    pbVC.index = index;
    pbVC.typeTitle = typeTitle;
    pbVC.imageUrls = imageUrls;
    pbVC.isSuportPinch = YES;
    pbVC.isSupportLongpress = YES;
    pbVC.isSupportDoubleTap = YES;
    UINavigationController *curNaviVC = [[UINavigationController alloc] initWithRootViewController:pbVC];
    [naviVC presentViewController:curNaviVC animated:YES completion:nil];
}

- (void)lookZhengBigPicture:(UITapGestureRecognizer *)tap
{
    SINImageView *imgV = (SINImageView *)tap.view;
    [self jumpToBrowserVC:_shop_certification_info index:imgV.identify typeTitle:imgV.typeTitle];
}

- (void)lookTangBigPicture:(UITapGestureRecognizer *)tap
{
    SINImageView *imgV = (SINImageView *)tap.view;
    
    [self jumpToBrowserVC:_shop_photo_info  index:imgV.identify typeTitle:imgV.typeTitle];
}

- (void)report
{
    BOOL isLogin = [[SINAccount sharedAccount] viewJumpToLoginVc];
    if (!isLogin) {
        return;
    }
    // 进入举报界面
}

- (void)callPhone
{
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",self.shop_phone];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

@end
