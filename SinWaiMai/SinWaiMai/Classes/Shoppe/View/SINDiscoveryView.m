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

#define DiscoveryIconWH 20
#define DiscoveryMargin 10
#define DiscoveryImgVW 90
#define DiscoveryImgVH 60
#define DiscoveryLabFont 12

@interface SINDiscoveryView ()

// 子控件动态创建模块的共同view
@property (weak, nonatomic) IBOutlet UIView *dynamicContentView;

@end

@implementation SINDiscoveryView

+ (instancetype)discoveryView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINDiscoveryView class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setWelfare_basic_info:(NSArray *)welfare_basic_info
{
    _welfare_basic_info = welfare_basic_info;
    
    CGFloat stayY = [self createLabImgModuleWithIconUrl:@"tang" labStr:@"堂景食堂" imgUrls:_shop_photo_info supV:self.dynamicContentView startY:0] + 10;
    CGFloat endY = [self createLabImgModuleWithIconUrl:@"zheng" labStr:@"资质证书" imgUrls:_shop_certification_info supV:_dynamicContentView startY:stayY] + 10;
    
    // 封底线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor darkGrayColor];
    line.frame = CGRectMake(0, endY + 50, self.dynamicContentView.width, 0.3);
    [self.dynamicContentView addSubview:line];
}

// 返回最后一个的最大Y值
- (CGFloat)createLabImgModuleWithIconUrl:(NSString *)iconUrl labStr:(NSString *)labStr imgUrls:(NSArray *)imgUrls supV:(UIView *)supV startY:(CGFloat)startY
{
    NSInteger tangImgCount = 2;
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
    UIImageView *preTangImgV = nil;
    for (int i = 0; i < tangImgCount; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        NSString *str = [[imgUrls[i] componentsSeparatedByString:@"@"] firstObject];
        NSURL *url = [NSURL URLWithString:str];
        [imgV sin_setImageWithURL:url];
        [supV addSubview:imgV];
        imgV.x = i * (DiscoveryImgVW + DiscoveryMargin);
        imgV.y = CGRectGetMaxY(tangIconV.frame) + DiscoveryMargin;
        imgV.size = CGSizeMake(DiscoveryImgVW, DiscoveryImgVH);
        if (i == tangImgCount - 1) {
            preTangImgV = imgV;
        }
    }
    return CGRectGetMaxY(preTangImgV.frame);
}

@end
