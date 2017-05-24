//
//  SINOverviewCell.m
//  SinWaiMai
//
//  Created by apple on 04/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINOverviewCell.h"
#import "SINFood.h"
#import "SINBuyView.h"

@interface SINOverviewCell ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel;
@property (nonatomic,strong) SINBuyView *buyView;
@end

@implementation SINOverviewCell
- (void)setFood:(SINFood *)food
{
    _food = food;
    
    self.foodNameLabel.text = food.name;
    [self addSubview:self.buyView];
    self.buyView.food = food;
}

- (SINBuyView *)buyView
{
    if (!_buyView) {
        CGFloat y = 30-self.foodPriceLabel.height;
         self.buyView = [[SINBuyView alloc] initWithFrame:CGRectMake(self.width - 100 - 10, y * 0.5, 100, 30)];
    }
    return _buyView;
}

@end
