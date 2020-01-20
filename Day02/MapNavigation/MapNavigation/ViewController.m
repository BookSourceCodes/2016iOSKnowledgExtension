//
//  ViewController.m
//  MapNavigation
//
//  Created by 覃团业 on 2020/1/20.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *destinationTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)test {
    // 应该使用正确的地理编码
    
    // 创建MKPlacemark --> CLPlacemark --> 地理编码来获取CLPlacemark
//    MKPlacemark *mkpm = [MKPlacemark alloc] initWithPlacemark:<#(nonnull CLPlacemark *)#>
    
    // 创建一个MKMapItem --> 终点的位置
//    MKMapItem *destinationItem = [MKMapItem alloc] initWithPlacemark:<#(nonnull MKPlacemark *)#>
    
    // MKMapItem：地图上的一个点
    // openMapsWithItem：调用此方法就可以打开系统自带地图导航
//    MKMapItem openMapsWithItems:<#(nonnull NSArray<MKMapItem *> *)#> launchOptions:<#(nullable NSDictionary<NSString *,id> *)#>
}

#pragma mark - 导航按钮点击

- (IBAction)navigateClick:(id)sender {
    // 1. 创建CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    // 2. 调用地理编码方法
    [geocoder geocodeAddressString:self.destinationTF.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 3.1 防错处理
        if (placemarks.count == 0 || error) {
            return;
        }
        
        // 3.2 遍历数组获取数据--> 正地理编码，可能重名，所以数组数量大于1，一定要给列表提示用户选择
        
        //4.  暂取最后一个
        CLPlacemark *pm = placemarks.lastObject;
        
        // 5. 创建MKPlacemark对象
        MKPlacemark *mkpm = [[MKPlacemark alloc] initWithPlacemark:pm];
        
        // 6. 创建一个MKMapItem
        MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:mkpm];
        
        // 7. 调用open方法，打开导航
        // withItems: 传入要定位的点
        // launchOptions: 导航参数
        NSDictionary *options = @{
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapTypeKey: @(MKMapTypeHybrid),
            MKLaunchOptionsShowsTrafficKey: @(YES)
        };
        [MKMapItem openMapsWithItems:@[destinationItem] launchOptions:options];
    }];
}

@end
