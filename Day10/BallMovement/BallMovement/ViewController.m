//
//  ViewController.m
//  BallMovement
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ballView;

/**
 运动管理器
 */
@property (nonatomic, strong) CMMotionManager *motionMgr;

/**
 此属性用来记录加速计的值
 */
@property (nonatomic, assign) CGPoint ballPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     思路分析
     1. 涉及到了x, y轴
     2. 加速计的x，y值 来进行叠加 ---> CoreMotion push方式
     3. 叠加之后赋值给frame即可
     4. 需要属性来记录加速计的两个值
     */
    // 1. 创建管理器对象
    self.motionMgr = [CMMotionManager new];
    
    // 2. 判断加速计是否可用
    if (![self.motionMgr isAccelerometerAvailable]) {
        NSLog(@"Accelerometer isn't available.");
        return;
    }
    
    // 3. 设置采样间隔
    self.motionMgr.accelerometerUpdateInterval = 1 / 20.0;
    
    // 4. 开始采样 ---> Push方式， 使用的是下面这种方式
    [self.motionMgr startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
        
        // 5. 调用方法，来完成小球相关的逻辑代码
        [self accelerationUpdate:accelerometerData.acceleration];
    }];
}

#pragma mark - 此方法处理小球相关的逻辑

- (void)accelerationUpdate:(CMAcceleration)acceleration {
    // 更改小球的位置变化 --> 值从加速计的值来获取的
    // Frame   加速计的值 叠加值
    // 100 ---> 1 ---> 101
    // 101 ---> 3 ---> 104
    // 104 ---> 5 ---> 109
    
    // 如果不发生运动，加速计的值，默认在1 ~ -1之间
    
    // 1. 叠加加速计的值 ---> 才能有加速的效果
    _ballPoint.x += acceleration.x;
    _ballPoint.y -= acceleration.y;
    
    // 2. 修改Frame
    CGRect ballFrame = self.ballView.frame;
    ballFrame.origin.x += _ballPoint.x;
    ballFrame.origin.y += _ballPoint.y;
    
    // 判断边界的问题
    if (ballFrame.origin.x < 0) {
        // 99 - 100 = -1?
        // 0 + 100 = 100
        ballFrame.origin.x = 0;
        
        // 在这里将小球的加速值取反 --> 为的是更改下一次的frame --> 模拟了碰撞现象
        // 还要进行*= 0.7 操作，以为着反弹之后，小球不会返回原来的位置 --> 模拟重力现象
        _ballPoint.x *= -0.7;
    }
    if (ballFrame.origin.x > (self.view.frame.size.width - self.ballView.frame.size.width)) {
        // 374 + 100 = 474?
        // 375 - 100 = 275
        ballFrame.origin.x = self.view.frame.size.width - self.ballView.frame.size.width;
        _ballPoint.x *= -0.7;
    }
    if (ballFrame.origin.y < 0) {
        ballFrame.origin.y = 0;
        _ballPoint.y *= -0.7;
    }
    if (ballFrame.origin.y > (self.view.frame.size.height - self.ballView.frame.size.height)) {
        ballFrame.origin.y = self.view.frame.size.height - self.ballView.frame.size.height;
        _ballPoint.y *= -0.7;
    }
    
    // 3. 重设frame
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ballView.frame = ballFrame;
    });
}

@end
