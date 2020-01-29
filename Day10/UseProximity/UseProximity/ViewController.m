//
//  ViewController.m
//  UseProximity
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

/**
 注意：在真机上开启距离传感器，当物体靠近传感器时，屏幕会自动灭屏。
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 开启距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 2. 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChangeNotification) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)dealloc
{
    // 4. 在退出界面后移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通知的方法

- (void)proximityStateDidChangeNotification {
    // 3. 获取通知的值
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
}
@end
