//
//  AppDelegate.h
//  SinWaiMai
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>

@protocol PasswordDelegate <NSObject>

@optional
- (void)fullPassword:(NSString *)password;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSString *pwdStr;

@property (nonatomic,weak) id<PasswordDelegate> pwdDelegate;


@end
