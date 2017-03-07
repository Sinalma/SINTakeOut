//
//  SINTopicCell.m
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINTopicCell.h"
#import "UIImageView+SINWebCache.h"
#import "SINTopic.h"

@interface SINTopicCell ()

/**图片*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 来源 */
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

/** 主题图标 */
@property (weak, nonatomic) IBOutlet UIImageView *themeIconView;

/** 主题名称 */
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

/** 点赞数 */
@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;

@end

@implementation SINTopicCell

- (void)setTopic:(SINTopic *)topic
{
    _topic = topic;
    
    [self.iconView sin_setImageWithURL:[NSURL URLWithString:topic.image]];
    
    self.titleLabel.text = topic.title;
    
    self.sourceLabel.text = topic.source;
    
    self.themeLabel.text = topic.theme;
    
    [self.themeIconView sin_setImageWithURL:[NSURL URLWithString:topic.theme_logo]];
    
    self.praiseLabel.text = [NSString stringWithFormat:@"点赞 %@",topic.praise_num];
    
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


@end
