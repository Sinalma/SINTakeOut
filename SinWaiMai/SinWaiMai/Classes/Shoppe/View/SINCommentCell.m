//
//  SINCommentCell.m
//  SinWaiMai
//
//  Created by apple on 13/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINCommentCell.h"
#import "SINComment.h"

@interface SINCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *pass_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *takeoutDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation SINCommentCell

- (void)setComment:(SINComment *)comment
{
    _comment = comment;
    
    self.pass_nameLabel.text = comment.pass_name;
    
    self.takeoutDetailLabel.text = [NSString stringWithFormat:@"配送 %@ 星（%@分钟送达）",comment.service_score,comment.cost_time];
    
    self.contentLabel.text = comment.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
