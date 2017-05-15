//
//  SINDiscoveryView.h
//  SinWaiMai
//
//  Created by apple on 25/02/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SINDiscoveryView : UIView

@property (nonatomic,strong) NSArray *shop_photo_info;
@property (nonatomic,strong) NSArray *shop_certification_info;
@property (nonatomic,strong) NSArray *welfare_basic_info;

+ (instancetype)discoveryView;

@end
