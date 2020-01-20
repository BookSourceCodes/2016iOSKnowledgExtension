//
//  ViewController.m
//  CustomPin
//
//  Created by 覃团业 on 2020/1/20.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotationModel.h"
#import "MyAnnotationView.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/* 位置管理器 */
@property (nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建位置管理器
    self.mgr = [CLLocationManager new];
    
    // 2. 请求授权
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    // 3. 跟踪用户位置
//    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 4. 设置地图的代理
    self.mapView.delegate = self;
    
    // MKUserLocation ---> 大头针模型
    
    // 1. 添加大头针 ---> 需要自定义大头针模型
    
//    // 2. 创建大头针
//    MyAnnotationModel *annotationModel = [MyAnnotationModel new];
//
//    annotationModel.coordinate = CLLocationCoordinate2DMake(39, 116);
//    annotationModel.title = @"北京市";
//    annotationModel.subtitle = @"北京市一个迷人的城市";
//
//    // 3. 添加到地图上
//    [self.mapView addAnnotation:annotationModel];
//
//    // 添加第二个大头针
//    MyAnnotationModel *annotationModel2 = [MyAnnotationModel new];
//
//    annotationModel2.coordinate = CLLocationCoordinate2DMake(23, 108);
//    annotationModel2.title = @"东莞市";
//    annotationModel2.subtitle = @"东莞市一个令人向往的城市";
//
//    // 3. 添加到地图上
//    [self.mapView addAnnotation:annotationModel2];
}

#pragma mark - 点击添加大头针

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MyAnnotationModel *annotationModel = [MyAnnotationModel new];

    // 将来是从服务器获取属性值
    annotationModel.coordinate = CLLocationCoordinate2DMake(39, 116);
    annotationModel.title = @"北京市";
    annotationModel.subtitle = @"北京市一个迷人的城市";
    annotationModel.icon = @"苍井空";
    
    [self.mapView addAnnotation:annotationModel];

    MyAnnotationModel *annotationModel2 = [MyAnnotationModel new];

    annotationModel2.coordinate = CLLocationCoordinate2DMake(23, 108);
    annotationModel2.title = @"东莞市";
    annotationModel2.subtitle = @"东莞市一个令人向往的城市";
    annotationModel2.icon = @"犀利哥";

    [self.mapView addAnnotation:annotationModel2];
}

#pragma mark - MKMapViewDelegate

/**
 此方法在添加大头针的时候就会调用，并且，在图像出现之前
 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    NSLog(@"count: %zd", views.count);
    for (MKAnnotationView *annoView in views) {
        // 0. 处理显示用户位置的大头针View，不要增加动画
        if ([annoView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // 1. 记录原来的位置
        CGRect endFrame = annoView.frame;
        // 2. 将View的Y值改为0
        annoView.frame = CGRectMake(endFrame.origin.x, 0, endFrame.size.width, endFrame.size.height);
        // 3. 将位置还原
        [UIView animateWithDuration:0.25 animations:^{
            annoView.frame = endFrame;
        }];
    }
}

/**
 只要添加了大头针模型，就会来到这个方法，设置并返回对应的View
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // MKUserLocation: 系统专门显示用户位置的大头针模型
    // MyAnnotationModel：自定义的类
    
    // 如果发现是显示用户位置的大头针模型，就返回nil
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // 2. 自定义大头针View --> 跟Cell的创建几乎一样
    // 封装大头针View， -->跟封装cell的过程几乎一样，唯一一个地方不一样的是，可以不用设置模型属性。
    MyAnnotationView *annoView = [MyAnnotationView myAnnotationViewWithMapView:mapView];
    
    // 设置图像 --> MVC
//    MyAnnotationModel *myAnnotation = (MyAnnotationModel *) annotation;
//    annoView.image = [UIImage imageNamed:myAnnotation.icon];
    
    // 将模型属性放到外面来设置 --> 系统会自动调用此属性的set来设置值
//    annoView.annotation = annotation;
    
    return annoView;
}

///**
// 只要添加了大头针模型，就会来到这个方法，设置并返回对应的View
// */
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    // MKUserLocation: 系统专门显示用户位置的大头针模型
//    // MyAnnotationModel：自定义的类
//
//    // 如果发现是显示用户位置的大头针模型，就返回nil
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//
//
//    // 自定义大头针View --> 跟Cell的创建几乎一样
//    static NSString *ID = @"annoView";
//
//    //MKAnnotationView：默认image属性没有赋值
//    //MKPinAnnotationView：子类是默认有View的
//    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
//
//    if (annoView == nil) {
//        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
////        annoView.image = [UIImage imageNamed:@"苍井空"];
//        // 1. 设置可以点击呼唤出来之前设置的标题子标题
//        annoView.canShowCallout = YES;
//
//        // 2. 设置左边附属视图
//        annoView.leftCalloutAccessoryView = [UISwitch new];
//
//        // 3. 设置右边附属视图
//        annoView.rightCalloutAccessoryView = [UISwitch new];
//
//        // 4. iOS9新增 自定义详情 --->子标题
//        annoView.detailCalloutAccessoryView = [UISwitch new];
//    }
//
//    MyAnnotationModel *myAnnotation = (MyAnnotationModel *)annotation;
//    annoView.image = [UIImage imageNamed:myAnnotation.icon];
//
//    return annoView;
//
//    // 如果返回nil，就代表用户没有自定义的需求，所有的view样式由系统处理
//    return nil;
//}

@end

