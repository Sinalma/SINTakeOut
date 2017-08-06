//
//  SINPushView.m
//  SinWaiMai
//
//  Created by apple on 06/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//
// height = 80

#import "SINPushView.h"
#import "UILabel+Category.h"
#import "Masonry.h"

@interface SINPushView ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UIView *line;

@end

@implementation SINPushView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self setup];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)itemSelected:(UIButton *)btn
{
    [UIView animateWithDuration:1.0 animations:^{
        btn.selected = !btn.selected;
    }];
}

- (void)setup
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.selectBtn];
    [self addSubview:self.line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@52);
        make.height.equalTo(@32);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitleLabel);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithFont:15 textColor:[UIColor darkTextColor]];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel createLabelWithFont:14 textColor:[UIColor darkGrayColor]];
    }
    return _subTitleLabel;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"no_password_sign_close_52x32_"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"no_password_sign_open_52x32_"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

@end
