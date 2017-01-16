//
//  SINSecondModuleView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSecondModuleView.h"

@interface SINSecondModuleView ()

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIView *rightTopView;

@property (weak, nonatomic) IBOutlet UIView *rightBottomView;

@end

@implementation SINSecondModuleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 添加手势
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewClick:)];
    [self.leftView addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTopViewClick:)];
    [self.rightTopView addGestureRecognizer:rightTopTap];
    
    UITapGestureRecognizer *rightBottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBottomViewClick:)];
    [self.rightBottomView addGestureRecognizer:rightBottomTap];
}

+ (instancetype)secondModuleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINSecondModuleView" owner:nil options:nil] lastObject];
}

- (void)leftViewClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"二-点击了左侧view");
}

- (void)rightTopViewClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"二-点击了右侧顶部view");
}

- (void)rightBottomViewClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"二-点击了右侧底部view");
}


@end
