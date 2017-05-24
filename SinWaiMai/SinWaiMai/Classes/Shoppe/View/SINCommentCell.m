//
//  SINCommentCell.m
//  SinWaiMai
//
//  Created by apple on 13/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCommentCell.h"
#import "SINComment.h"
#import "UILabel+Category.h"
#import "Masonry.h"

@interface SINCommentCell ()

/** 用户名label */
@property (weak, nonatomic) IBOutlet UILabel *pass_nameLabel;

/** 外送评分label */
@property (weak, nonatomic) IBOutlet UILabel *takeoutDetailLabel;

/** 用户评论内容view */
@property (weak, nonatomic) IBOutlet UIView *commentContentView;

/** 保存遍历创建中的上一个赞label */
@property (nonatomic,strong) UILabel *previousLikeLab;

/** 保存遍历创建中的上一个标签label */
@property (nonatomic,strong) UILabel *previousTagLab;

@end

@implementation SINCommentCell
- (void)setComment:(SINComment *)comment
{
    _comment = comment;
    
    self.pass_nameLabel.text = comment.pass_name;
    
    self.takeoutDetailLabel.text = [NSString stringWithFormat:@"配送 %@ 星（%@分钟送达）",comment.service_score,comment.cost_time];
    
    [self tempMethod];
}

- (void)tempMethod
{
    for (UIView *subV in self.commentContentView.subviews) {
        [subV removeFromSuperview];
    }
    
    self.previousTagLab = nil;
    self.previousLikeLab = nil;
    
    // 评论类型上下间距
    CGFloat commentTypeMargin = 5;
    CGFloat labFontSizeW = 12;
    
    // 处理评论类容
    // 用户手写评论
    UILabel *contentLabel = [UILabel createLabelWithFont:labFontSizeW textColor:[UIColor darkGrayColor]];
    contentLabel.text = self.comment.content;
    contentLabel.numberOfLines = 0;
    [self.commentContentView addSubview:contentLabel];
    CGFloat contentLabH = [self.comment.content boundingRectWithSize:CGSizeMake(self.commentContentView.width, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:labFontSizeW]} context:nil].size.height;
    // 安全处理
    if (!contentLabel.text.length) {
        contentLabH = 0;
        contentLabel.text = nil;
    }
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.commentContentView);
//        make.width.equalTo(@290);
//        make.height.equalTo(@(contentLabH));
//    }];
    contentLabel.frame = CGRectMake(0, 0, self.commentContentView.width, contentLabH);
    // 点赞评论
    NSInteger recommentDishCount = self.comment.recommend_dishes.count;
    if (recommentDishCount) {
        
        NSMutableArray *likeLabTexts = [NSMutableArray array];
        for (int i = 0; i < recommentDishCount; i++) {
            
            [likeLabTexts addObject:self.comment.recommend_dishes[i][@"dish_name"]];
        }
    
        CGFloat dishStartY = contentLabel.text.length?contentLabH+commentTypeMargin:0;
        UILabel *lab = [[UILabel alloc] init];
        self.previousLikeLab = lab;
        UILabel *recLab = [self alignmentWithLabStrs:likeLabTexts imgN:@"Commentlike" startY:dishStartY superV:self.commentContentView];
        self.previousLikeLab = recLab;
    }
    
    // 标签评论
    NSInteger commentLabelsCount = self.comment.comment_labels.count;
    if (commentLabelsCount) {
        
        NSMutableArray *tagTests = [NSMutableArray array];
        for (int i = 0; i < commentLabelsCount; i++) {
            [tagTests addObject:self.comment.comment_labels[i][@"content"]];
        }
        
        CGFloat startY = 0;
        if (recommentDishCount) {
            startY = CGRectGetMaxY(self.previousLikeLab.frame)+ commentTypeMargin;
        }else
        {
            startY = self.comment.content?CGRectGetMaxY(contentLabel.frame)+commentTypeMargin:0;
        }
        
        self.previousTagLab = [self alignmentWithLabStrs:tagTests imgN:@"commentTag" startY:startY superV:self.commentContentView];
    }
    
    // 时间
    CGFloat timeStartY = 0;
    if (contentLabel.text.length) {
        
    }
    if (commentLabelsCount) {
        timeStartY = CGRectGetMaxY(self.previousTagLab.frame)+5;
    }else
    {
        if (recommentDishCount) {
            timeStartY = CGRectGetMaxY(self.previousLikeLab.frame)+commentTypeMargin;
        }else
        {
            timeStartY = self.comment.content.length?CGRectGetMaxY(contentLabel.frame)+commentTypeMargin:0;
        }
    }
    UILabel *timeLab = [self alignmentWithLabStrs:@[self.comment.create_time] imgN:@"shopfind_deliverytime_18x18_" startY:timeStartY superV:self.commentContentView];
    self.cellHeight = CGRectGetMaxY(timeLab.frame) + self.commentContentView.y + commentTypeMargin*2;
}

/**
 * @Method   固定宽度的控件内动态创建多个label，排列label不换行并且能完全显示
 * @Return Value 返回一个label用于获取到本次动态创建的最后一个label
 *
 * @P labStrs   字符串数组
 * @P imgN  第一个控件imageView的图片名称
 * @P startY   相对父控件约束的起始Y值
 * @p superV   需要添加到的父控件
 */
- (UILabel *)alignmentWithLabStrs:(NSArray *)labStrs imgN:(NSString *)imgN startY:(CGFloat)startY superV:(UIView *)superV;
{
    // 图片
    UIImageView *likeImgV = [[UIImageView alloc] init];
    likeImgV.image = [UIImage imageNamed:imgN];
    likeImgV.frame = CGRectMake(0, startY, 20, 20);
    [superV addSubview:likeImgV];
    
    CGFloat labX = 0;
    CGFloat labY = 0;
    CGFloat labW = 0;
    CGFloat labH = likeImgV.height;
    CGFloat margin = 10;
    
    UILabel *preLabel = nil;
    NSInteger count = labStrs.count;
    
    for (int i = 0; i < count; i++) {
        UILabel *recLabel = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
        recLabel.text = labStrs[i];
        
        if (i != count - 1) {
            recLabel.text = [recLabel.text stringByAppendingString:@"、"];
        }
        
        labW = [recLabel.text boundingRectWithSize:CGSizeMake(500, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
        
        CGFloat preLabMaxX = CGRectGetMaxX(preLabel.frame);
        CGFloat maxW = superV.width - CGRectGetMaxX(likeImgV.frame) - margin;// 右侧空出30
        
        if (preLabel == nil) {
            
            labX = CGRectGetMaxX(likeImgV.frame) + margin;
            labY = likeImgV.y;
        }else
        {
            if (maxW - preLabMaxX >= labW) {
                labX = CGRectGetMaxX(preLabel.frame);
                labY = preLabel.y;
            }else
            {
                labX = CGRectGetMaxX(likeImgV.frame) + margin;
                labY = CGRectGetMaxY(preLabel.frame) + margin*0.5;
            }
        }
        
        recLabel.frame = CGRectMake(labX, labY, labW, labH);
        [self.commentContentView addSubview:recLabel];
        
//        if (i == count-1) {
            preLabel = recLabel;
//        }
    }
    return preLabel;
}

@end
