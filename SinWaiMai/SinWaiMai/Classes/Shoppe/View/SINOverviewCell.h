//
//  SINOverviewCell.h
//  SinWaiMai
//
//  Created by apple on 04/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SINFood;

@interface SINOverviewCell : UITableViewCell

@property (nonatomic,assign) int orderCount;

@property (nonatomic,strong) SINFood *food;

@end
