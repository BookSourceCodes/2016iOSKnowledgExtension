//
//  ViewController.m
//  UseGyro
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

/*
 运动管理器
 */
@property (nonatomic, strong) CMMotionManager *motionMgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     陀螺仪
     */
    // 1. 创建CMMotionManager对象
    self.motionMgr = [CMMotionManager new];
    
    // 2. 判断陀螺仪是否可用
    if (![self.motionMgr isGyroAvailable]) {
        return;
    }
    
    // 3. 设置采样间隔，单位是秒
    self.motionMgr.gyroUpdateInterval = 1;
    
    // 4. 开始采样
    [self.motionMgr startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        // 5. 获取data中的数值
        CMRotationRate rotationRate = gyroData.rotationRate;
        
        NSLog(@"x: %f, y: %f, z: %f", rotationRate.x, rotationRate.y, rotationRate.z);
    }];
}


@end
