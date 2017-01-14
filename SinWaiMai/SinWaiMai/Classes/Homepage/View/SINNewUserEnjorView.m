//
//  SINNewUserEnjorView.m
//  SinWaiMai
//
//  Created by apple on 13/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINNewUserEnjorView.h"

@interface SINNewUserEnjorView ()

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;


@end

@implementation SINNewUserEnjorView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.height = 120;
        NSLog(@"initWithFrame%f",self.height);
    }
    return self;
}

+ (instancetype)newUserEnjorView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SINNewUserEnjorView" owner:nil options:nil] lastObject];
}

@end
