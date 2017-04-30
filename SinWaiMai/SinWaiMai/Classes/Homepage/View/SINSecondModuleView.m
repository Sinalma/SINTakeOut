//
//  SINSecondModuleView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSecondModuleView.h"

#import "UIImageView+SINWebCache.h"

#import "SINActivity.h"

@interface SINSecondModuleView ()

// 手势view
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightTopView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;

// 左边
@property (weak, nonatomic) IBOutlet UIImageView *leftTextImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftOutImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftInnerImageView;

// 右边顶部
@property (weak, nonatomic) IBOutlet UILabel *rightTopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;

// 右边底部
@property (weak, nonatomic) IBOutlet UILabel *rightBottomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;

@end

@implementation SINSecondModuleView

- (void)setActivities:(NSMutableArray *)activities
{
    _activities = activities;
    
    for (int i = 0; i < activities.count; i++) {
        
        SINActivity *act = activities[i];
        
        if (i == 0) { // 设置左边模块数据
            
            [self.leftTextImageView sin_setImageWithURL:[NSURL URLWithString:act.head_icon]];
            
            self.leftTextLabel.text = act.desc;
            // 颜色没设置
            
            [self.leftOutImageView sin_setImageWithURL:[NSURL URLWithString:act.spec_icon]];
            [self.leftInnerImageView sin_setImageWithURL:[NSURL URLWithString:act.img_url]];
            
        }else if (i == 1){
            
            [self.rightTopImageView sin_setImageWithURL:[NSURL URLWithString:act.img_url]];
            
            self.rightTopTitleLabel.text = act.title;
            self.rightTopDescLabel.text = act.desc;
            
        }else if (i == 2)
        {
            [self.rightBottomImageView sin_setImageWithURL:[NSURL URLWithString:act.img_url]];
            
            self.rightBottomTitleLabel.text = act.title;
            self.rightBottomDescLabel.text = act.desc;
        }
    }
}

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

/**
 * 快速加载xib控件
 */
+ (instancetype)secondModuleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINSecondModuleView" owner:nil options:nil] lastObject];
}

#pragma mark - 监听点击事件
- (void)leftViewClick:(UITapGestureRecognizer *)tap
{
    SINLog(@"二-点击了左侧view");
}

- (void)rightTopViewClick:(UITapGestureRecognizer *)tap
{
    SINLog(@"二-点击了右侧顶部view");
    
    // 跳转html页面
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:@"test.html"]]];
}

- (void)rightBottomViewClick:(UITapGestureRecognizer *)tap
{
    SINLog(@"二-点击了右侧底部view");
}

@end
