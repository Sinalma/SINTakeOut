//
//  SINTopicCell.h
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINTopic;

@interface SINTopicCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) SINTopic *topic;

@end
