//
//  SINNetWorkingManager.h
//  SinWaiMai
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  网络管理类，请求数据统一调用这里的接口

/**
  调用单粒方法获取对象
  对象调用网络方法
 */

#import <Foundation/Foundation.h>

@interface SINNetWorkingManager : NSObject

+ (instancetype)manager;

@end
