//
//  SINFoodViewController.m
//  SinWaiMai
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//  单个食物详情控制器

#import "SINFoodViewController.h"
#import "SINFoodView.h"
#import "SINShareView.h"

@interface SINFoodViewController ()

@property (nonatomic,strong) SINFoodView *foodView;

@end

@implementation SINFoodViewController

- (void)setFood:(SINFood *)food
{
    _food = food;
    
    [self viewDidLoad];
    
    self.foodView.food = food;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SINFoodView *foodView = [[SINFoodView alloc] init];
    foodView.backgroundColor = [UIColor whiteColor];
    foodView.frame = self.view.bounds;
    [self.view addSubview:foodView];
    self.foodView = foodView;
    
    __weak typeof(self) welSelf = self;
    
    self.foodView.goback = ^{
        
        [welSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.foodView.shared = ^{
        
        SINShareView *shareView = [[SINShareView alloc] init];
        shareView.logo_url = welSelf.food.url;
        shareView.hidden = NO;
        [shareView share];
    };
}

@end
