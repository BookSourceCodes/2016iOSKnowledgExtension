//
//  HMAudioTools.m
//  PackagePlaybackSound
//
//  Created by 覃团业 on 2020/1/30.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "HMAudioTools.h"

/*
 缓存字典
 */
static NSMutableDictionary *_soundIDDict;

@implementation HMAudioTools

+ (void)initialize
{
    _soundIDDict = [NSMutableDictionary dictionary];
}

+ (void)playSystemSoundWithURL:(NSURL *)url {
    // 不带震动的播放
    AudioServicesPlaySystemSound([self loadSoundIDWithURL:url]);
}

+ (void)playAlertSoundWithURL:(NSURL *)url {
    // 带震动的播放
    AudioServicesPlayAlertSound([self loadSoundIDWithURL:url]);
}

+ (void)clearMemory {
    // 1. 遍历字典
    [_soundIDDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 2. 清空音效文件的内存
        SystemSoundID soundID = [obj intValue];
        AudioServicesDisposeSystemSoundID(soundID);
    }];
}

#pragma mark - 播放音效的公用方法
+ (SystemSoundID)loadSoundIDWithURL:(NSURL *)url {
    // 思路
    // soundID重复创建 --> soundID每次创建，就会有对应的URL地址产生
    // 可以将创建后的soundID及对应的URL进行缓存处理
    
    // 1. 获取URL的字符串
    NSString *urlStr = url.absoluteString;
    
    // 2. 从缓存字典中根据URL来取soundID 系统音效文件
    SystemSoundID soundID = [_soundIDDict[urlStr] intValue];
    
    // 需要在刚进入的时候，判断缓存字典是否有url对应的soundID
    
    // 3, 判断soundID是否为0，如果为0，说明没有找到，需要创建
    if (soundID == 0) {
        // 3.1 创建音效文件
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        // 3.2缓存字典添加键值
        _soundIDDict[urlStr] = @(soundID);
    }
    
    return soundID;
}

@end
