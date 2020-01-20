//
//  MyAnnotationView.m
//  CustomPin
//
//  Created by 覃团业 on 2020/1/20.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "MyAnnotationView.h"
#import "MyAnnotationModel.h"

@implementation MyAnnotationView

/**
 提供快速创建View的方法
 */
+ (instancetype)myAnnotationViewWithMapView:(MKMapView *)mapView {
    // 自定义大头针View --> 跟Cell的创建几乎一样
    static NSString *ID = @"annoView";
    
    //MKAnnotationView：默认image属性没有赋值
    //MKPinAnnotationView：子类是默认有View的
    MyAnnotationView *annoView = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoView == nil) {
        annoView = [[MyAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
//        annoView.image = [UIImage imageNamed:@"苍井空"];
        // 1. 设置可以点击呼唤出来之前设置的标题子标题
        annoView.canShowCallout = YES;
        
        // 2. 设置左边附属视图
        annoView.leftCalloutAccessoryView = [UISwitch new];
        
        // 3. 设置右边附属视图
        annoView.rightCalloutAccessoryView = [UISwitch new];
        
        // 4. iOS9新增 自定义详情 --->子标题
        annoView.detailCalloutAccessoryView = [UISwitch new];
    }
    
    return annoView;
}

#pragma mark - 系统会自动调用该方法 annotation 的 set 方法

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    // 1. 必须调用父类方法
    [super setAnnotation: annotation];
    
    // 2. 设置图像
    MyAnnotationModel *myAnnotation = (MyAnnotationModel *) annotation;
    self.image = [UIImage imageNamed:myAnnotation.icon];
}

@end
