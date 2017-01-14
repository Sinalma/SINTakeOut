//
//  SINSecondModuleView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINSecondModuleView.h"

@implementation SINSecondModuleView

+ (instancetype)secondModuleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINSecondModuleView" owner:nil options:nil] lastObject];
}

@end
