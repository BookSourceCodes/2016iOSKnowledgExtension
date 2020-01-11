//
//  ViewController.m
//  SinglePositioning
//
//  Created by 覃团业 on 2020/1/11.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建CLLocationManager对象
    self.mgr = [CLLocationManager new];
    
    // 2. 请求用户授权 --> 从iOS8开始，必须在程序中请求用户授权，除了写代码，还要配置plist列表的键值
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // 当用户使用的使用授权
        [self.mgr requestWhenInUseAuthorization];
    }
    
    // 3. 设置代理 --> 获取用户位置
    self.mgr.delegate = self;
    
    // 4. 调用开始定位方法
    [self.mgr startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

/* 当完成位置更新的时候调用 --> 此方法会频繁调用 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    [self.mgr stopUpdatingLocation];
    NSLog(@"location: %@", location);
    /*
     SinglePositioning[12532:709663] location: <+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 1/11/20, 7:46:43 PM China Standard Time
     */
}

@end
