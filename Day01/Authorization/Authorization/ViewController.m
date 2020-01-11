//
//  ViewController.m
//  Authorization
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
    
    /*
     1. 请求授权操作，是在iOS8以后才出现，一定要注意适配iOS 7
     2. 授权方法有2种：1种使用期间授权requestWhenInUseAuthorization / 1种永久授权requestAlwaysAuthorization
     3. plist的键：使用期间授权 NSLocationWhenInUseUsageDescription / 永久授权 NSLocationAlwaysUsageDescription
     4. 如果写了使用期间授权，又写了永久授权，会出现授权2次，一般来说一个程序只需要一种授权
     5. 大部分的程序只需要使用 使用期间授权即可，如果程序列表中出现了3行，说明同时实现了2中授权。
     6. plist键值对的值，可以不写，建议大家写上原因，告诉用户为什么要使用定位，提高用户打开的几率。
     */

    //    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0 ) {}

    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // 当用户使用的使用授权
        [self.mgr requestWhenInUseAuthorization];
        
        // 永久授权，不论程序有没有在主界面运行，都会授权
        [self.mgr requestAlwaysAuthorization];
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

