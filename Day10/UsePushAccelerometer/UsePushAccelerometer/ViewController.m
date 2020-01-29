//
//  ViewController.m
//  UsePushAccelerometer
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

/* 运动管理器对象 */
@property (nonatomic, strong) CMMotionManager *motionMgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     加速计Push方式
     */
    // 1. 创建CoreMotion对象
    self.motionMgr = [CMMotionManager new];
    
    // 2. 判断加速计是否可用
    if (![self.motionMgr isAccelerometerAvailable]) {
        return;
    }
    
    // 3. 设置采样间隔，单位是秒
    self.motionMgr.accelerometerUpdateInterval = 1;
    
    // 4. 开始采样
    [self.motionMgr startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        NSLog(@"data: %@", accelerometerData);
        // 当前为非主线程，如果需要更新界面，需要在主线程中更新
        dispatch_async(dispatch_get_main_queue(), ^{
            // TODO:  更新UI
        });
    }];
}


@end
