//
//  ViewController.m
//  PackagePlaybackSound
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import "HMAudioTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    // 局部音效需要在这里进行释放
    [HMAudioTools clearMemory];
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 获取URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"yaobuqi.wav" withExtension:nil];
    
    // 2. 调用工具类播放音效
    [HMAudioTools playSystemSoundWithURL:url];
}

@end
