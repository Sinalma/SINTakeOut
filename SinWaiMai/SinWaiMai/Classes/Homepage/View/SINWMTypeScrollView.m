//
//  SINWMTypeScrollView.m
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWMTypeScrollView.h"
#import "SINNormalButton.h"
#import "SINWMType.h"
#import "UIButton+SINWebCache.h"

@interface SINWMTypeScrollView ()

@property (nonatomic,strong) NSMutableArray *wMTypeBtns;

@end

@implementation SINWMTypeScrollView

- (NSMutableArray *)wMTypeBtns
{
    if (_wMTypeBtns == nil) {
        _wMTypeBtns = [NSMutableArray array];
    }
    return _wMTypeBtns;
}

- (void)setWMTypes:(NSArray *)wMTypes
{
    _wMTypes = wMTypes;
    
    [self setup];
    
    [self setupGravityBehaviour];
}

- (void)setupGravityBehaviour
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    for (UIButton *btn in self.wMTypeBtns) {
        [gravity addItem:btn];
    }
    gravity.gravityDirection = CGVectorMake(0, 1);
    [animator addBehavior:gravity];
}

/**
 * 初始化子控件
 */
- (void)setup{
    
    NSInteger wMTypeCount = self.wMTypes.count;
    
    CGFloat margin = 10;
    
    int rowCount = 2;
    int columnCount = 5;
    CGFloat colFloat = wMTypeCount % 2;
    NSInteger colInt = wMTypeCount / 2;
    
    if (colFloat > 0) {
        colInt += 1;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.width - (columnCount + 1) * margin) / columnCount;
    CGFloat h = (150 - (rowCount + 1) * margin) / rowCount;
    
    CGFloat contentSizeW = margin + colInt * (w + margin);
    CGFloat contentSizeH = margin + rowCount * (h + margin);
    
    self.contentSize = CGSizeMake(contentSizeW, contentSizeH);
    
    for (int i = 0; i < wMTypeCount; i++) {
        
        SINNormalButton *btn = [[SINNormalButton alloc] init];
        
        SINWMType *wMtype = self.wMTypes[i];
        
        [btn sin_setImageWithURL:[NSURL URLWithString:wMtype.pic] forState:UIControlStateNormal];
        [btn setTitle:wMtype.name forState:UIControlStateNormal];
        
        int row = i / colInt;
        int col = i % colInt;
        
        x = margin + (col * (w + margin));
        y = margin + (row * (h + margin));
        
        btn.frame = CGRectMake(x, y, w, h);
        
        btn.tag = i;
        [btn addTarget:self action:@selector(wMTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [self.wMTypeBtns addObject:btn];
    }
}

- (void)wMTypeBtnClick:(SINNormalButton *)btn
{
    SINLog(@"点击了外卖类型 -> %@",btn.titleLabel.text);
}

@end
