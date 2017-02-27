//
//  SINCommentCell.h
//  SinWaiMai
//
//  Created by apple on 13/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINComment;

@interface SINCommentCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong) SINComment *comment;

@property (nonatomic,assign) CGFloat cellHeight;

@end
/**
 // 点赞评论
 NSInteger recommentDishCount = comment.recommend_dishes.count;
 if (recommentDishCount) {
 // 赞图标
 UIImageView *likeImgV = [[UIImageView alloc] init];
 likeImgV.image = [UIImage imageNamed:@"Commentlike"];
 likeImgV.frame = CGRectMake(0, 0, 20, 20);
 [self.commentContentView addSubview:likeImgV];
 
 CGFloat labX = 0;
 CGFloat labY = 0;
 CGFloat labW = 0;
 CGFloat labH = likeImgV.height;
 CGFloat margin = 10;
 
 UILabel *preLabel = nil;
 for (int i = 0; i < recommentDishCount*2; i++) {
 UILabel *recLabel = [UILabel createLabelWithFont:12 textColor:[UIColor darkGrayColor]];
 recLabel.text = comment.recommend_dishes[i][@"dish_name"];
 
 if (i != recommentDishCount - 1) {
 
 recLabel.text = [recLabel.text stringByAppendingString:@"、"];
 }
 
 labW = [recLabel.text boundingRectWithSize:CGSizeMake(500, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
 
 CGFloat preLabMaxX = CGRectGetMaxX(preLabel.frame);
 CGFloat maxW = SINScreenW - CGRectGetMaxX(likeImgV.frame) - margin - 30;
 
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
 preLabel = recLabel;
 }
 
 // 标签评论
 NSInteger tagCommentCount = comment.comment_labels.count;
 if (tagCommentCount) {
 
 }
 }
 */
