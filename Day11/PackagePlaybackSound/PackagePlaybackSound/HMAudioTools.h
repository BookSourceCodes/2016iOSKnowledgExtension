//
//  HMAudioTools.h
//  PackagePlaybackSound
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HMAudioTools : NSObject

/*
 播放系统音效
 */
+ (void)playSystemSoundWithURL:(NSURL *)url;

/*
 播放震动音效
 */
+ (void)playAlertSoundWithURL:(NSURL *)url;

/*
 清空音效文件的内存
 */
+ (void)clearMemory;

@end
