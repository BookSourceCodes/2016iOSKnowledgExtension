//
//  ViewController.m
//  Continuous positioning
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
    
    /*
     要想实现持续定位，我们需要对电量做些优化。
     */
    
    // 5. 距离筛选器， 当位置发生一定的改变之后再调用代理方法，以此节省电量
    // Filter: 筛选/过滤 单位是米
    // 比如这里传10，当位置发生超过10米的变化时，才会调用代理方法
    self.mgr.distanceFilter = 10;
    
    // 6. 设置精准度
    // iPhone中的定位方式：GPS / Wifi / 移动基站
    // GPS：全球卫星定位系统， 24颗卫星进行通讯
    // 我们可以降低定位的精准度，实际上降低了与卫星之间的计算，以此节省电量
    // desired：期望/渴望
    // accuracy:精准度
    self.mgr.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    /*
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyBestForNavigation API_AVAILABLE(ios(4.0), macos(10.7));
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyBest;
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyKilometer;
     CL_EXTERN const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;
     */
    
}

#pragma mark - CLLocationManagerDelegate

/*
 当完成位置更新的时候调用 --> 此方法会频繁调用
 此方法会频繁调用，非常耗电
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
//    [self.mgr stopUpdatingLocation];
    NSLog(@"location: %@", location);
    /*
     SinglePositioning[12532:709663] location: <+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 1/11/20, 7:46:43 PM China Standard Time
     */
}

@end
