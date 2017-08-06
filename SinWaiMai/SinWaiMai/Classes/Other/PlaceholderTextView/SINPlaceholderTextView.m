//
//  SINPlaceholderTextView.m
//  SinWaiMai
//
//  Created by apple on 05/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINPlaceholderTextView.h"

@interface SINPlaceholderTextView ()

/** placeholder label */
@property (nonatomic,weak)  UILabel *placeholderLabel;

@end

@implementation SINPlaceholderTextView

#pragma mark - Notification
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        // create a UILabel instance to placeholder.
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // set color and size to placeholder text
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:15];
        
        // 发布通知（当空间的内容发生改变时）
        // send notification when zoom content is changed.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeholderLabel.x = 4;
    self.placeholderLabel.y = 8;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    // 自适应
    [self.placeholderLabel sizeToFit];
}

- (void)textDidChange:(NSNotification *)note{
    // 是否隐藏
    self.placeholderLabel.hidden = self.hasText;
}

// 移除监听者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    self.placeholderLabel.textColor = placeholderColor;
}

#pragma mark - 重新计算placeholderLabel的尺寸
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = self.font;
    // 重新布局
    [self setNeedsLayout];
}

- (void)setPlaceholder:(NSString *)placeholder{
    self.placeholderLabel.text = [placeholder copy];
    // 重新布局
    [self setNeedsLayout];
}

#pragma mark - 隐藏placeholderLabel
- (void)setText:(NSString *)text{
    [super setText:text];
    // 隐藏
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    // 隐藏
    self.placeholderLabel.hidden = self.hasText;
}


@end
