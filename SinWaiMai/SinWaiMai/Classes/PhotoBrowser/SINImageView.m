//
//  SINImageView.m
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINImageView.h"
#import "UIImageView+SINWebCache.h"

@implementation SINImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.identify = 0;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.bounds;
    [self addSubview:self.imageView];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)sin_setImageWithURL:(NSURL *)url
{
    [self.imageView sin_setImageWithURL:url];
}

@end
