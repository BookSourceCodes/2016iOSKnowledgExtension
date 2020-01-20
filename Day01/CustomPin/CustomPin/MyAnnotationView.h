//
//  MyAnnotationView.h
//  CustomPin
//
//  Created by 覃团业 on 2020/1/20.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotationView : MKAnnotationView

/**
 提供快速创建View的方法
 */
+ (instancetype)myAnnotationViewWithMapView:(MKMapView *)mapView;

@end
