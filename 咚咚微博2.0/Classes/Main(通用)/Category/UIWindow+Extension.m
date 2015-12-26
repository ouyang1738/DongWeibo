//
//  UIWindow+Extension.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/30.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainTabBarController.h"
#import "NewFeatureController.h"

@implementation UIWindow (Extension)

+ (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    //上一次使用的版本号（存储在沙盒）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    //获得当前软件的版本号（Info.plist中获取）
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *appVersion = infoDict[@"CFBundleVersion"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([appVersion isEqual:lastVersion]) {//同一版本
        //直接进入应用
        window.rootViewController = [[MainTabBarController alloc]init];
    }else{
        //显示新特性
        window.rootViewController = [[NewFeatureController alloc]init];
        //将当前版本号存储至沙盒
        [[NSUserDefaults standardUserDefaults]setObject:appVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
