//
//  MyAnnotationModel.h
//  AddPin
//
//  Created by 覃团业 on 2020/1/19.
//  Copyright © 2020 覃团业. All rights reserved.
//

/**
 1. 导入框架 MapKit
 2. 遵守协议 MKAnnotation
 3. 设置属性 直接去协议中拷贝-->删掉readonly
 */
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotationModel : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
