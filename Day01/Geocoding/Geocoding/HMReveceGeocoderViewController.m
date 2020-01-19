//
//  HMReveceGeocoderViewController.m
//  Geocoding
//
//  Created by 覃团业 on 2020/1/19.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "HMReveceGeocoderViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HMReveceGeocoderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longitideTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation HMReveceGeocoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)reveceGeocoderClick:(id)sender {
    // 1. 创建一个CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    // 2. 创建一个CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitudeTF.text doubleValue] longitude:[self.longitideTF.text doubleValue]];
    
    // 3. 实现反地理编码方法
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       // 4.1 防错误处理
        if (placemarks.count == 0 || error) {
            NSLog(@"解析没有数据或者出错");
        }
        
        // 4.2 遍历数组，获取数据 --> 一般来讲就一个值
        for (CLPlacemark *placemark in placemarks) {
            self.cityLabel.text = placemark.locality;
        }
    }];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end
