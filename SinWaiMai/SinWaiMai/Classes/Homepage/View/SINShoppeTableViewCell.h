//
//  SINShoppeTableViewCell.h
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SINShoppe.h"

@class SINShoppeTableViewCell;

@protocol SINShoppeTableViewCellDelegate <NSObject>

@optional
- (void)shoppeCellWelfareContainerClick:(SINShoppeTableViewCell *)cell;

@end

@interface SINShoppeTableViewCell : UITableViewCell

/** 商户模型 */
@property (nonatomic,strong) SINShoppe *shoppe;

/** cell高度 */
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,weak) id<SINShoppeTableViewCellDelegate> delegate;

@end
