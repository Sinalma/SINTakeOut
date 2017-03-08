//
//  SINTopTopicCell.m
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINTopTopicCell.h"
#import "SINTopic.h"
#import "UIImageView+SINWebCache.h"

@interface SINTopTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIImageView *themeIconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;

@end

@implementation SINTopTopicCell

- (void)setTopTopic:(SINTopic *)topTopic
{
    _topTopic = topTopic;
    
    [self.iconView sin_setImageWithURL:[NSURL URLWithString:topTopic.image]];
    
    self.titleLabel.text = topTopic.title;
    
    [self.themeIconView sin_setImageWithURL:[NSURL URLWithString:topTopic.theme_logo]];
    
    self.themeLabel.text = topTopic.theme;
    
    self.sourceLabel.text = topTopic.source;
    
    self.praiseLabel.text = [NSString stringWithFormat:@"点赞 %@",topTopic.praise_num];
    
    self.height = CGRectGetMaxY(self.praiseLabel.frame) + 10;
    self.cellHeight = CGRectGetMaxY(self.praiseLabel.frame) + 10;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setup];
    
}

- (void)setup
{
    
    self.themeIconView.layer.cornerRadius = 7.5;
    self.themeIconView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
