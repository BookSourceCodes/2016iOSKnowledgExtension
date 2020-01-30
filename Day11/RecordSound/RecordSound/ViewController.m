//
//  ViewController.m
//  RecordSound
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建录音对象
    // 1. 获取URL地址 --> 具体的文件名路径 --> 注意之前是获取资源地址，这里是指要讲录音存放到哪里
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"record.wav"];;
    
    // 2. 将path字符串转换成NSURL --> file://
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 3. 配置设置字典
    // 如果传空，默认就是高质量
    // 录音的参数值
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    
//    // settings 设置参数  录音相关参数  声道   速率   采样率
//    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
//    // 音频格式
//    settings[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
//    // 音频采样率
//    settings[AVSampleRateKey] = @(600.0);
//    // 音频通道数
//    settings[AVNumberOfChannelsKey] = @(1);
//    // 线性音频的位深度
//    settings[AVLinearPCMBitDepthKey] = @(8);
    
    // 4. 创建Error对象 __autoreleasing 可以不加，加上之后是最标准写法
    NSError *error;
    
    // 5. 创建录音对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (error) {
        NSLog(@"录音失败：%@", error);
    }
    
    // 6. 打开分贝的检查
    self.recorder.meteringEnabled = YES;
    
    // 7. 如果要在真机运行，还需要一个session类，并且制定分类为录音
    AVAudioSession *session = [AVAudioSession new];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
}

- (IBAction)recordClick:(id)sender {
    NSLog(@"start record");
    // 1. 准备录音
    [self.recorder prepareToRecord];
    
    // 2. 开始录音 --> 如果同一路径再次录音，则会覆盖之前的文件
    [self.recorder record];
    
    // 3. 进行分贝的循环检测 --> 添加计时器
    [self updateMetering];
}

- (IBAction)pauseClick:(id)sender {
    NSLog(@"Pause record");
    // 暂停录音 --> 如果用户只是暂停了，应该提示用户进行保护操作
    [self.recorder pause];
    
    // 暂停循环
    self.displayLink.paused = YES;
}

- (IBAction)stopClick:(id)sender {
    NSLog(@"stop record");
    // 停止录音 --> 之后停止录音时，最终的录音文件才会生成
    [self.recorder stop];
    
    // 暂停循环
    self.displayLink.paused = YES;
    
    NSLog(@"停止录音");
}

#pragma mark - 添加计时器
- (void)updateMetering {
    // 如果没有displayLink就创建
    if (self.displayLink == nil) {
        // 1. 创建displayLink
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
        
        // 2. 添加到运行循环中
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    // 判断如果暂停了循环，就打开
    if (self.displayLink.isPaused) {
        self.displayLink.paused = NO;
    }
}

#pragma mark - 循环调用的方法
- (void)updateMeter {
    // 需求：自动停止录音 --> 根据分贝的大小来判断
    
    // 1. 我们需要获取分贝信息
    // 2. 设置分贝如果小于某个值，一定时间后，自动停止
    
    // 1. 更新分贝信息
    [self.recorder updateMeters];
    
    // 2. 获取分贝信息 --> iOS直接传0
    // 0 ~ -160, 最大是0， 最小是-160，系统返回的是负值
    CGFloat power = [self.recorder averagePowerForChannel:0];
    
    // 3. 实现2S自动停止
    static NSInteger number;
    
    // displayLink, 一秒默认是60次， 如果120次时调用都小于某个分贝值，我们就可以认为要自动停止
    // 3.1 先判断用户是否小于某个分贝值 --> 用户是否没说话
    if (power < -30) {
        // 3.2 如果发现很安静，我们就可以记录一下，number进行叠加
        number++;
        // 3.3 如果发现120次了， 都小于设定的分贝值
        if (number / 60 >= 2) {
            // 调用停止方法
            [self stopClick:nil];
        }
    }
    
    NSLog(@"power: %f", power);
}
@end
