//
//  ViewController.m
//  GameKitBT
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKPeerPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/*
 绘话类
 */
@property (nonatomic, strong) GKSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 连接蓝牙
- (IBAction)connectClick:(id)sender {
    // 1. 创建GKPeerPickerController连接控制器
    GKPeerPickerController *picker = [GKPeerPickerController new];
    
    // 2. 设置代理 --> 获取数据
    picker.delegate = self;
    
    // 3. 显示控制器 --> show 此控制器和AlertView很像，不是全屏的，不用pushmodal
    [picker show];
}

#pragma mark - 选择照片
- (IBAction)selectPhotoClick:(id)sender {
    // 1. 判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    // 2. 创建UIImagePickerController
    UIImagePickerController *picker = [UIImagePickerController new];
    
    // 3. 设置类型
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4. 设置代理
    picker.delegate = self;
    
    // 5. 莫泰视图弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 发送照片
- (IBAction)sendPhotoClick:(id)sender {
    // 1. 将image转换成Data
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.5);
    
    // 2. 使用会话类发送数据
    /*
     GKSendDataReliable,    如果发送失败，会重新发送，直到成功
     GKSendDataUnreliable,  发送一次就不管了
     */
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

#pragma mark - UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // 1. 获取照片并显示到界面上
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    
    // 2. 关闭控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GKPeerPickerController代理方法
/**
 此方法在连接到另一台设备时，会调用
 peerID: 另一台设备的ID
 session：回话类，用于接收和发送数据
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    // 1. 保留session
    self.session = session;
    
    // 2. 设置句柄（设置代理） --> 将来一旦收到数据，将由句柄的方法来处理数据
    // 一旦设置了句柄，那么还需要实现另一个方法
    [self.session setDataReceiveHandler:self withContext:nil];
    
    // 3. 消失控制器
    [picker dismiss];
}

#pragma mark - GKSession句柄, 接收到数据的时候，会调用此方法来处理
// yidayida
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    // 1. 将Data转换成image对象
    UIImage *image = [UIImage imageWithData:data];
    
    // 2. 然后设置到界面上
    self.imageView.image = image;
}

@end
