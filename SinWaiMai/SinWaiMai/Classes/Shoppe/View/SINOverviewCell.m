//
//  SINOverviewCell.m
//  SinWaiMai
//
//  Created by apple on 04/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINOverviewCell.h"
#import "SINFood.h"

@interface SINOverviewCell ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLable;
@property (weak, nonatomic) IBOutlet UIButton *increaseBtn;

@end
@implementation SINOverviewCell

- (void)setFood:(SINFood *)food
{
    _food = food;
    self.foodNameLabel.text = food.name;
    self.foodPriceLabel.text = [NSString stringWithFormat:@"¥%@",food.current_price];
    self.orderCountLable.text = [NSString stringWithFormat:@"%d",self.orderCount];
}

- (IBAction)decrease:(id)sender {
    if (self.orderCount != 0) {
        self.orderCount--;
        self.orderCountLable.text = [NSString stringWithFormat:@"%d",self.orderCount];
    }
}
- (IBAction)increase:(id)sender {
    self.orderCount++;
    self.orderCountLable.text = [NSString stringWithFormat:@"%d",self.orderCount];
}


@end
