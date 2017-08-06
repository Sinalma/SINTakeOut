//
//  SINPlaceholderTextView.h
//  SinWaiMai
//
//  Created by apple on 05/08/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//
// This class is a until class.
// Create a new instance for UITextView,use this instance can set placeholder text,and set placeholder text color.

#import <UIKit/UIKit.h>

@interface SINPlaceholderTextView : UITextView

/** placeholder text */
@property (nonatomic,copy) NSString *placeholder;
/** placeholder color */
@property (nonatomic,strong) UIColor *placeholderColor;

@end
