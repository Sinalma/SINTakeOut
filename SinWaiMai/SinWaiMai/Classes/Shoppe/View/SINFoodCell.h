//
//  SINFoodCell.h
//  SinWaiMai
//
//  Created by apple on 24/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINFood.h"

@interface SINFoodCell : UITableViewCell

/** 模型 */
@property (nonatomic,strong) SINFood *food;

/** 当前食物订单数 */
@property (nonatomic,assign) int curOrderCount;
@end
