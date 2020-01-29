//
//  ViewController.m
//  StepCounting
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) CMPedometer *pedometer;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 判断硬件是否可用
    if (![CMPedometer isStepCountingAvailable]) {
        return;
    }
    
    // 2. 创建计步器的类
    self.pedometer = [CMPedometer new];
    
    // 3. 开始计步统计
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        // 4. 主线程中更新UI
        NSNumber *number = pedometerData.numberOfSteps;
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:number waitUntilDone:NO];
    }];
}

- (void)updateUI:(NSNumber *)number {
    self.label.text = [NSString stringWithFormat:@"你当前一共走了%@步", number];
}

@end
