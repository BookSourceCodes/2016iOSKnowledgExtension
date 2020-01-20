//
//  ViewController.m
//  MapLine
//
//  Created by 覃团业 on 2020/1/20.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建及授权
    self.mgr = [CLLocationManager new];
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    // 2. 设置代理
    self.mapView.delegate = self;
}

- (IBAction)startLine:(id)sender {
    [self.view endEditing:YES];
    // 1. 创建CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    // 2. 调用地理编码方法
    [geocoder geocodeAddressString:self.addressTF.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 3.1 防错处理
        if (placemarks.count == 0 || error) {
            return;
        }
        
        // 3.2 遍历数组获取数据--> 正地理编码，可能重名，所以数组数量大于1，一定要给列表提示用户选择
        
        // 4. 暂取最后一个
        CLPlacemark *pm = placemarks.lastObject;
        
        // 5. 创建MKPlacemark对象
        MKPlacemark *mkpm = [[MKPlacemark alloc] initWithPlacemark:pm];
        
        // 6. 创建MKMapItem 起点位置
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        
        // 7. 创建一个MKMapItem
        MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:mkpm];
        
        // 实现画线
        // 导航/画线 ---> 跟苹果服务器发送请求
        // 1. 创建方向请求对象
        MKDirectionsRequest *request = [MKDirectionsRequest new];
        // 设置起点
        request.source = sourceItem;
        // 设置终点
        request.destination = destinationItem;
        
        // 2. 创建方向对象
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        // 3. 计算两点之间的路线
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            // 4. 数据处理
            if (response.routes.count == 0 || error) {
                return;
            }
            
            // 5. 获取路线信息
            for (MKRoute *route in response.routes) {
                // 6. 获取折线（多段线）polyline将来显示在地图上的线段
                MKPolyline *polyline = route.polyline;
                
                // 7. 添加到地图上
                // Overlay: 遮盖物
                [self.mapView addOverlay:polyline];
            }
        }];
    
    }];
}

#pragma mark - 设置地图渲染图层

/**
 当给地图添加遮盖物的时候回调用此方法
 设置一个渲染对象，添加到地图上
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    // 1. 创建折线渲染的对象
    MKPolylineRenderer *polyline = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    // 2. 设置线条颜色 --> 必须
    polyline.strokeColor = [UIColor blueColor];
    
    // 设置线宽 --> 随意设置
    polyline.lineWidth = 1;
    
    // 3. 返回对象
    return polyline;
}
@end
