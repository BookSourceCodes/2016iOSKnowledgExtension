//
//  ViewController.m
//  CLLocationIntroduction
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
    
    // 比较两个位置之间的距离
    // 北京和西安的距离
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:40 longitude:116];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:34.27 longitude:108.93];
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    NSLog(@"distance: %f", distance / 1000);
}

#pragma mark - CLLocationManagerDelegate

/*
 当完成位置更新的时候调用 --> 此方法会频繁调用
 此方法会频繁调用，非常耗电
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // CLLocation: 位置对象，最核心的就是经纬度
    // CLLocationCoordinate2D coordinate：2D位置坐标 ---> 经纬度
    // CLLocationDistance altitude：海拔
    // CLLocationAccuracy horizontalAccuracy：水平误差
    // CLLocationAccuracy verticalAccuracy：垂直误差
    // CLLocationDirection course：角度
    // CLLocationSpeed speed：角度
    // NSDate timestamp：时间戳
    
    // CLLocationDegrees latitude:  ---> 纬度
    // CLLocationDegrees longitude: ---> 经度
    
    CLLocation *location = [locations lastObject];
    [self.mgr stopUpdatingLocation];
//    NSLog(@"location: %@", location);
    /*
     SinglePositioning[12532:709663] location: <+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 1/11/20, 7:46:43 PM China Standard Time
     */
    NSLog(@"latitude: %f, logitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}

@end

