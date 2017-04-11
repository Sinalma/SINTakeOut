//
//  AppDelegate.h
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordDelegate <NSObject>

@optional
- (void)fullPassword:(NSString *)password;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSString *pwdStr;

@property (nonatomic,weak) id<PasswordDelegate> pwdDelegate;

@end

