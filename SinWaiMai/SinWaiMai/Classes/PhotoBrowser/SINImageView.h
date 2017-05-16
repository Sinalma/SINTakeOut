//
//  SINImageView.h
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SINImageView : UIView

@property (nonatomic,assign) NSInteger identify;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSString *typeTitle;

- (void)sin_setImageWithURL:(NSURL *)url;

@end
