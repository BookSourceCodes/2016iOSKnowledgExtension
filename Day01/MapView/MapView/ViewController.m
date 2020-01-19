//
//  ViewController.m
//  MapView
//
//  Created by 覃团业 on 2020/1/19.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建位置管理器
    self.mgr = [CLLocationManager new];
    
    // 2. 请求授权 --> plist
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    // 3. 设置显示用户位置
    // Tracking: 跟踪
    /**
        MKUserTrackingModeNone = 0,
        MKUserTrackingModeFollow,   定位
        MKUserTrackingModeFollowWithHeading API_UNAVAILABLE(tvos), 定位并且显示方向
     */
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 4. 设置代理 --> 获取用户位置信息
    self.mapView.delegate = self;
    
    /* iOS 9新增属性 */
    
    // 1. 设置交通状况
    self.mapView.showsTraffic = YES;
    
    // 2. 设置指南针（默认就是YES），屏幕旋转后会出现，如果点击会校正方向
    self.mapView.showsCompass = YES;
    
    // 3. 设置比例尺
    self.mapView.showsScale = YES;
}

- (IBAction)mapTypeChangeClick:(UISegmentedControl *)sender {
    /*
     MKMapTypeStandard = 0, 默认
     MKMapTypeSatellite,    卫星
     MKMapTypeHybrid,       混合
     MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),   下面两个属性，中国区无用
     MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     MKMapTypeMutedStandard
     */
    // 设置地图类型，一般要使用默认，要么使用混合，单纯的卫星图没有意义。
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        case 3:
            self.mapView.mapType = MKMapTypeSatelliteFlyover;
            break;
            
        case 4:
            self.mapView.mapType = MKMapTypeHybridFlyover;
            break;
            
        case 5:
            if (@available(iOS 11.0, *)) {
                self.mapView.mapType = MKMapTypeMutedStandard;
            }
            break;
    }
}

- (IBAction)zoomInClick:(id)sender {
    // 1. Delta缩小一倍
    // region: 是当前地图显示的区域
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 0.5;
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 0.5;
    
    // 2. 重设region属性
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, MKCoordinateSpanMake(latitudeDelta, longitudeDelta)) animated:YES];
}

- (IBAction)zoomOutClick:(id)sender {
    // 1. Delta放大一倍
    // region: 是当前地图显示的区域
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 2;
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 2;
    
    // 2. 重设region属性
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, MKCoordinateSpanMake(latitudeDelta, longitudeDelta)) animated:YES];
}

#pragma mark - 点击此按钮，返回用户所在的位置

- (IBAction)backUserLocationClick:(id)sender {
    // 1. 设置中心点坐标
//    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    
    // 2. 设置范围的属性
    // 2.1 获取坐标
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    
    // 2.2 设置显示范围 --> 为了跟系统默认跨度保持一致，我们可以打印region的span值来获取，然后设置即可
    // 1° ~ 111KM
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025415, 0.016093);
    
    // 2.3 设置范围属性
//    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    // 设置范围方法，可以设置动画
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

#pragma mark - MKMapViewDelegate

/**
 完成用户位置更新的时候调用
 MKUserLocation：大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"location:%@", userLocation.location);
//    userLocation.title = @"黑马程序员";
//    userLocation.subtitle = @"北京海淀区西三旗建材城西路";
    // 需求：显示大头针信息 --> 反地理编码实现
    
    // 1. 创建一个CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    // 2. 实现反地理编码方法
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 3.1 放错处理
        if (placemarks.count == 0 || error) {
            return;
        }
        
        // 3.2 获取对象
        CLPlacemark *placemark = placemarks.lastObject;
        
        // 3.3 设置标题为城市信息
        userLocation.title = placemark.locality;
        
        // 3.4 设置子标题为详细地址
        userLocation.subtitle = placemark.name;
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // 获取默认的显示大小 --> span
    NSLog(@"latitudeDelta: %f, longitudeDelta: %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    // latitudeDelta: 0.025415, longitudeDelta: 0.016093
}

@end
