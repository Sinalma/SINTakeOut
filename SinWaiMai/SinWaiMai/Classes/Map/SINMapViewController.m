//
//  SINMapViewController.m
//  SinWaiMai
//
//  Created by apple on 12/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINMapViewController.h"

@interface SINMapViewController ()

@end

@implementation SINMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    // 定位显示位置的模式
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.zoomLevel = 17;// 显示的比例尺
    //普通态
    //以下_mapView为BMKMapView对象
    mapView.showsUserLocation = YES;//显示定位图层
    [mapView updateLocationData:self.userLocation];
    self.mapView = mapView;
    self.view = mapView;
    
    UIBarButtonItem *hideMapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(hideMap)];
    self.navigationItem.leftBarButtonItem = hideMapItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)hideMap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
