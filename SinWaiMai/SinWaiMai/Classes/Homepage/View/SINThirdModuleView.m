//
//  SINThirdModuleView.m
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINThirdModuleView.h"

@interface SINThirdModuleView ()

@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UIView *rightTopView;
@property (weak, nonatomic) IBOutlet UIView *leftBottomView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;


@end

@implementation SINThirdModuleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 添加手势
    UITapGestureRecognizer *leftTopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTopViewClick:)];
    [self.leftTopView addGestureRecognizer:leftTopTap];
    
    UITapGestureRecognizer *leftBottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBottomViewClick:)];
    [self.leftBottomView addGestureRecognizer:leftBottomTap];
    
    UITapGestureRecognizer *rightTopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTopViewClick:)];
    [self.rightTopView addGestureRecognizer:rightTopTap];
    
    UITapGestureRecognizer *rightBottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBottomViewClick:)];
    [self.rightBottomView addGestureRecognizer:rightBottomTap];
}

+ (instancetype)thirdModuleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINThirdModuleView" owner:nil options:nil] lastObject];
}

- (void)leftTopViewClick:(UITapGestureRecognizer *)tap {
    SINLog(@"三-电击了左边顶部");
}

- (void)rightTopViewClick:(UITapGestureRecognizer *)tap {
    SINLog(@"三-电击了右边顶部");
}

- (void)leftBottomViewClick:(UITapGestureRecognizer *)tap {
    SINLog(@"三-点击了左边底部");
}

- (void)rightBottomViewClick:(UITapGestureRecognizer *)tap {
    SINLog(@"三-点击了右边底部");
}

@end
