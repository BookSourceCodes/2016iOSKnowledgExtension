//
//  ViewController.m
//  UsePullAccelerometer
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
     加速计Pull方式
     */
    // 1. 创建CMMotionManager对象
    self.motionMgr = [CMMotionManager new];
    
    // 2. 判断加速计是否可用
    if (![self.motionMgr isAccelerometerAvailable]) {
        return;
    }
    
    // 3. 开始采样
    [self.motionMgr startAccelerometerUpdates];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 点击是获取加速计的值
    // 运动管理器会记录所有的值，在自己的属性中
    CMAcceleration acceleration = self.motionMgr.accelerometerData.acceleration;
    NSLog(@"x: %f, y: %f, z: %f", acceleration.x, acceleration.y, acceleration.z);
}


@end
