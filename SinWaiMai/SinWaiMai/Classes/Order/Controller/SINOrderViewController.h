//
//  SINOrderViewController.h
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SINOrderViewControllerDelegate <NSObject>

@optional;
- (void)orderViewDidApper;

@end

@interface SINOrderViewController : UIViewController

@property (nonatomic,weak) id<SINOrderViewControllerDelegate> delegate;

@end
