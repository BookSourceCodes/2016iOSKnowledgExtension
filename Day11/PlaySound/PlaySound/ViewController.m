//
//  ViewController.m
//  PlaySound
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

/*
 1. 导入AVFoundation框架
 2. 创建音效文件
 3. 播放音效文件

 音效：非常短的音乐，一般来说30秒以内的声音吗，都算作音效
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 创建URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"yaobuqi.wav" withExtension:nil];
    
    NSLog(@"path: %@", url.absoluteString);
    
    // 2. 系统音效文件 SystemSoundId = UInt32
    SystemSoundID soundId;
    
    // 3. 创建音效文件
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundId);
    
    // 4. 播放音效文件
    // 4.1 不带震动的播放
//    AudioServicesPlaySystemSound(soundId);
    
    // 4.2 带震动的播放 --> 真机才有效果
    AudioServicesPlayAlertSound(soundId);
    
    // 5. 如果不需要播放了，需要释放音效所占用的内存
    AudioServicesDisposeSystemSoundID(soundId);
}

@end
