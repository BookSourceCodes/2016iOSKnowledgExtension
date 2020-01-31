//
//  ViewController.m
//  VideoCompression
//
//  Created by 覃团业 on 2020/1/31.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1. 判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    // 2.创建图像选择器
    UIImagePickerController *picker = [UIImagePickerController new];
    
    // 3. 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 4. 设置媒体类型
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    // 5. 设置代理
    picker.delegate = self;
    
    // 6. 模态弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/*
 选中视频的时候，进行压缩处理
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // 1. 获取媒体类型
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    // 2. 获取视频地址
    NSURL *url = (NSURL *)info[UIImagePickerControllerMediaURL];
    
    // 3. 开始导出 --> 压缩
    [self exportWithURL: url];
}

- (void)exportWithURL:(NSURL *)url {
    // 1. 获取资源
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    // 2. 根据资源，创建资源导出会话对象
    // presetName: 压缩的大小
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    
    // 3. 设置导出路径
    session.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"1234.mov"]];
    
    // 4. 设置导出类型
    session.outputFileType = AVFileTypeQuickTimeMovie;
    
    // 5. 开始导出
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"当你看到这句话的时候，恭喜你已经导出成功");
    }];
}
@end
