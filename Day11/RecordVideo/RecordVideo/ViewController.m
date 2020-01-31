//
//  ViewController.m
//  RecordVideo
//
//  Created by 覃团业 on 2020/1/31.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVPlayerViewController *playController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)movieClick:(id)sender {
    // 1. 判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    // 2. 创建图像选择器
    UIImagePickerController *picker = [UIImagePickerController new];
    
    // 3. 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 4. 设置媒体类型
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    // 5. 设置相机检测模式
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    // 6. 设置录制质量
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    // 7. 设置代理
    picker.delegate = self;
    
    // 8. 模态弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"info: %@", info);
    
    // 1. 获取媒体类型
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    // 2. 判断是否是视频的媒体类型
    NSURL *url = (NSURL *)info[UIImagePickerControllerMediaURL];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        if (self.playController == nil) {
            self.playController = [AVPlayerViewController new];
            self.playController.view.frame = CGRectMake(40, 200, 300, 240);
            [self.view addSubview:self.playController.view];
        }
        self.playController.player = [AVPlayer playerWithURL:url];
        [self.playController player];
    }
    
    // 3. 保存视频
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        // 3.1 创建ALAssetsLibrary对象
//        ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
//
//        // 3.2 调用writeVideoAtPathToSavedPhotosAlbum即可
//        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
        // 保存相册核心代码
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    } else {
        NSLog(@"保存视频成功");
    }
}
@end
