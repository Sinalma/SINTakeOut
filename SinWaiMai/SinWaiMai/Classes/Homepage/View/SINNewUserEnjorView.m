//
//  SINNewUserEnjorView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINNewUserEnjorView.h"

@interface SINNewUserEnjorView ()

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation SINNewUserEnjorView
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
    NSLog(@"leftViewClick");
}

- (void)rightViewClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"rightViewClick");
}

+ (instancetype)newUserEnjorView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINNewUserEnjorView" owner:nil options:nil] lastObject];
}

@end
