//
//  SINHeaderView.m
//  SinWaiMai
//
//  Created by apple on 12/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINHeaderView.h"
#import "SINShopComment.h"

@interface SINHeaderView ()

/** 平均分 */
@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;

/** 星星 */
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;

/** 评论数 */
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

/** 配送服务评分 */
@property (weak, nonatomic) IBOutlet UILabel *outScoreLabel;

/** 评论类型容器 */
@property (weak, nonatomic) IBOutlet UIView *commentTypeView;

/** 是否显示只有内容的评论按钮 */
@property (weak, nonatomic) IBOutlet UIButton *isShowContentButton;

/** 当前选中的评论类型按钮 */
@property (nonatomic,strong) UIButton *selCommentBtn;

/** 存放所有评论类型按钮的数组 */
@property (nonatomic,strong) NSMutableArray *commentBtns;

@end

@implementation SINHeaderView
- (NSMutableArray *)commentBtns
{
    if (_commentBtns == nil) {
        _commentBtns = [NSMutableArray array];
    }
    return _commentBtns;
}

+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SINHeaderView class]) owner:nil options:nil] firstObject];
}

- (void)setShopComment:(SINShopComment *)shopComment
{
    _shopComment = shopComment;
    
    self.averageScoreLabel.text = shopComment.average_dish_score;
    
//    self.isShowContentButton.layer.cornerRadius = self.isShowContentButton.height*0.5;
//    self.isShowContentButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.isShowContentButton.layer.borderWidth = 0.3;
    
    
    // 星星
//    self.starImgView
    
    // 评论数
    self.commentCountLabel.text = [NSString stringWithFormat:@"商品质量 %@人评价",shopComment.comment_num];
    
    self.outScoreLabel.text = shopComment.average_service_score;
    
    for (int i = 0; i < self.commentTypeView.subviews.count; i++) {
        UIView *v = self.commentTypeView.subviews[i];
        [v removeFromSuperview];
    }
    
    [self setup];
}

#pragma mark - 自定义方法
/**
 * 是否显示有内容评论的按钮
 */
static BOOL isSelHook = YES;
- (IBAction)showConetentBtnClick:(UIButton *)btn {
    isSelHook = !isSelHook;
    if (!btn.selected) {
        btn.selected = YES;
    }else
    {
        btn.selected = NO;
    }
    if (isSelHook) {
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"global_selected_14x14_"] forState:UIControlStateSelected];
    }else
    {
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"getcoupon_21x21_"] forState:UIControlStateNormal];
    }
}

- (void)setup
{
    // 设置评论类型的按钮创建和数据
    NSArray *strArr = self.shopComment.labels;
    
    CGFloat x = 20;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 30;
    
    NSInteger commentTypeCount = strArr.count;
    
    UIButton *preBtn = nil;
    
    for (int i = 0;i < commentTypeCount + 4; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(commentTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str = nil;
        if (i == 0) {
            str = [NSString stringWithFormat:@"全部(%@)",self.shopComment.comment_num];
        }else if (i == 1)
        {
            str = [NSString stringWithFormat:@"好评(%@)",self.shopComment.good_comment_num];
        }else if (i == 2)
        {
            str = [NSString stringWithFormat:@"中评(%@)",self.shopComment.medium_comment_num];
            
        }else if (i == 3)
        {
            str = [NSString stringWithFormat:@"差评(%@)",self.shopComment.bad_comment_num];
        }else
        {
            str = [NSString stringWithFormat:@"%@(%@)",strArr[i - 4][@"content"],strArr[i - 4][@"label_count"]];
        }
        
        [button setTitle:str forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 12;
        button.layer.masksToBounds = YES;
        
        CGRect strFrame = [str boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        
        w = strFrame.size.width + 20;
        button.width = w;
        
        if (preBtn != nil) {
            
            // 当前行不足，显示到下一行
            CGFloat preBtnMaxX = CGRectGetMaxX(preBtn.frame) + 10;
            if ((self.commentTypeView.width - (preBtnMaxX) - w ) >= 0) {
                y = preBtn.y;
                x = preBtnMaxX;
            }else
            {
                y = CGRectGetMaxY(preBtn.frame) + 10;
                x = 20;
            }
        }
        
        button.x = x;
        button.y = y;
        button.height = h;
        
        preBtn = button;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
        
        if (i == 0) {
            [self commentTypeBtnClick:button];
        }
        
        // 设置本身的高度
        if (i == strArr.count - 1 + 4) {
            
            self.height = self.commentTypeView.y + CGRectGetMaxY(button.frame) + 10 + 20 + 10;
        }
        [self.commentTypeView addSubview:button];
        
        [self.commentBtns addObject:button];
    }
}

/**
 * 点击了评论类型按钮
 */
- (void)commentTypeBtnClick:(UIButton *)btn
{
    self.selCommentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.selCommentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.selCommentBtn = btn;
}

@end
