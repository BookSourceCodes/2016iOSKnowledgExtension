//
//  ViewController.m
//  PlayVideoWithView
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVPlayerViewController *pVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)moviePlayerViewController:(id)sender {
    // 带View的播放器的控制器
    
    // 1. 获取URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SampleVideo.mp4" withExtension:nil];
    
    // 2. AV播放视图控制器
    self.pVC = [AVPlayerViewController new];
    
    // 3. 创建player --> 设置时需要传入网址
    self.pVC.player = [AVPlayer playerWithURL:url];
    
    // 4. 开始播放
    [self.pVC.player play];
    
    // 5. 模态视图弹出 --> 模态视图的切换应该在View完全展示之后进行
//    [self presentViewController:pVC animated:YES completion:nil];
    
    // 5. 如果想要自定义播放器的大小，应该自定义 --> 设置frame / 添加到视图中
    // 注意：使用这种方式播放视频，AVPlayerViewController必须是强引用，否则无法播放
    self.pVC.view.frame = CGRectMake(40, 200, 300, 400);
    [self.view addSubview:self.pVC.view];
}

@end
