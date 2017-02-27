//
//  SINDiscoveryView.m
//  SinWaiMai
//
//  Created by apple on 25/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINDiscoveryView.h"
#import "UIView+Category.h"
#import "UILabel+Category.h"

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
    
    [self setup];
}

- (void)setup
{

    [self createLabImgModuleWithIconUrl:nil labStr:@"堂景食堂" imgUrls:nil supV:self.dynamicContentView startY:0];
}


- (void)createLabImgModuleWithIconUrl:(NSString *)iconUrl labStr:(NSString *)labStr imgUrls:(NSArray *)imgUrls supV:(UIView *)supV startY:(CGFloat)startY
{
    NSInteger tangImgCount = 2;
    // 图标
    UIImageView *tangIconV = [[UIImageView alloc] init];
    tangIconV.image = [UIImage imageNamed:@""];
    [supV addSubview:tangIconV];
    tangIconV.frame = CGRectMake(0, startY, DiscoveryIconWH, DiscoveryIconWH);
    
    // 类别lab
    UILabel *tangLab = [UILabel createLabelWithFont:DiscoveryLabFont textColor:[UIColor darkGrayColor]];
    tangLab.text = @"堂景食堂";
    [supV addSubview:tangLab];
    tangLab.x = CGRectGetMaxX(tangIconV.frame) + DiscoveryMargin;
    tangLab.y = tangIconV.y;
    
    // 正图
    UIImageView *preTangImgV = nil;
    for (int i = 0; i < tangImgCount; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@""];
        [supV addSubview:imgV];
        imgV.x = i * (DiscoveryImgVW + DiscoveryMargin);
        imgV.y = tangIconV.y + DiscoveryMargin;
        imgV.size = CGSizeMake(DiscoveryImgVW, DiscoveryImgVH);
        if (i == tangImgCount - 1) {
            preTangImgV = imgV;
        }
    }

}

@end
