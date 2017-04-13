//
//  SINMapViewController.h
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface SINMapViewController : UIViewController

/** 地图 */
@property (nonatomic,strong) BMKMapView* mapView;

@property (nonatomic,strong) BMKUserLocation *userLocation;
@end
