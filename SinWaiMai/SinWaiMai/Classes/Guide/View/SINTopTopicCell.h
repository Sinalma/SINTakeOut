//
//  SINTopTopicCell.h
//  SinWaiMai
//
//  Created by apple on 07/03/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINTopic;

@interface SINTopTopicCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) SINTopic *topTopic;

@end
