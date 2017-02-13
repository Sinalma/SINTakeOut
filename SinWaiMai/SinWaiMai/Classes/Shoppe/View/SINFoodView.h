//
//  SINFoodView.h
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  单个食物详情scrollView

#import <UIKit/UIKit.h>
#import "SINFood.h"

typedef void(^Goback)(void);
typedef void(^Shared)(void);

@interface SINFoodView : UIScrollView

// 模型
@property (nonatomic,strong) SINFood *food;

@property (nonatomic,strong) Goback goback;

@property (nonatomic,strong) Shared shared;

@end
