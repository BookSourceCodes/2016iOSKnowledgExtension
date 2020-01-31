//
//  ViewController.m
//  FingerprintRecognition
//
//  Created by 覃团业 on 2020/1/31.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 判断系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 可以使用指纹识别 --> 5S以后的机型
        
        // 2. 判断时候可以使用指纹识别功能
        
        // 2.1 创建LA对象上下文
        LAContext *context = [LAContext new];
        
        NSError *error;
        
        // 2.2 判断是否能使用
        // Evaluate: 评估
        // Policy： 策略
        // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 可以使用指纹识别技术
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            // 可以使用
            
            // 3. 开始启用指纹识别
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹，以打开高级隐藏功能" reply:^(BOOL success, NSError * _Nullable error) {
               
                // 判断是否成功
                if (success) {
                    NSLog(@"验证成功");
                    // 4. 指纹识别在更新UI时， 一定要注意，在主线程更新
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这是标题" message:@"你成功了" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                } else {
                    NSLog(@"验证失败");
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这是标题" message:@"验证失败" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
                
                // 判断错误，如果需要区分不同的错误来提示用户，必须判断error
                if (error) {
                    NSLog(@"error code: %zd", error.code);
                    NSLog(@"error: %@", error.userInfo);
                }
            }];
        } else {
            NSLog(@"error: %@", error);
            NSLog(@"对不起， 5S以上机型才能使用此功能，请卖肾后重试");
        }
    }
}

@end
