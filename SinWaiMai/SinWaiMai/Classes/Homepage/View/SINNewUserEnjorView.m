//
//  SINNewUserEnjorView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINNewUserEnjorView.h"
#import "SINNewuserentry.h"
#import "UIImageView+SINWebCache.h"

@interface SINNewUserEnjorView ()

// 左侧模块
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitleLabel;

// 右侧
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitleLabel;

// 手势
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation SINNewUserEnjorView
- (void)setNewuesrentries:(NSArray *)newuesrentries
{
    _newuesrentries = newuesrentries;
    
    for (int i = 0; i < self.newuesrentries.count; i++) {
        
        SINNewuserentry *entry = self.newuesrentries[i];
        
        if (i == 0) { // 左侧
            
            [self.leftImageView sin_setImageWithURL:[NSURL URLWithString:entry.icon]];
            self.leftTitleLabel.text = entry.title;
            self.leftSubTitleLabel.text = entry.sub_title;
            
        }else if (i == 1)// 右侧
        {
            [self.rightImageView sin_setImageWithURL:[NSURL URLWithString:entry.icon]];
            self.rightTitleLabel.text = entry.title;
            self.rightSubTitleLabel.text = entry.sub_title;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 添加手势
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewClick:)];
    [self.leftView addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewClick:)];
    [self.rightView addGestureRecognizer:rightTap];
    
}

- (void)leftViewClick:(UITapGestureRecognizer *)tap
{
    SINLog(@"leftViewClick");
}

- (void)rightViewClick:(UITapGestureRecognizer *)tap
{
    SINLog(@"rightViewClick");
}

+ (instancetype)newUserEnjorView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINNewUserEnjorView" owner:nil options:nil] lastObject];
}

@end
