//
//  ViewController.m
//  VideoScreenshot
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1, URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"YachtRide.mp4" withExtension:nil];
    
    // 2. 获取资源
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    // 3. 创建资源图像生成器
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    // 4. 开始生成图像
    // Times：要截取哪一帧
    // value: 帧数
    // timescale： 当前视频的每秒的帧数
    CMTime time = CMTimeMake(30, 1);
    
    NSValue *value = [NSValue valueWithCMTime:time];
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:@[value] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"获取失败: %@", error);
            return;
        }
        // 5. 主线程中更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithCGImage:image];
        });
    }];
}

@end
