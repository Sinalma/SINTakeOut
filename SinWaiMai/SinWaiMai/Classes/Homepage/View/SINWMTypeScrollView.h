//
//  SINWMTypeScrollView.h
//  SinWaiMai
//
//  Created by apple on 16/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  外卖类型模块

#import <UIKit/UIKit.h>

@interface SINWMTypeScrollView : UIScrollView

@property (nonatomic,assign) int wMTypeCount;

@property (nonatomic,strong) NSMutableArray *wMTypeImgNs;

@property (nonatomic,strong) NSArray *wMTypeNames;

@end
