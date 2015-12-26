//
//  UIBarButtonItem+Extension.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/26.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建一个UIBarButtonItem
 *
 *  @param action     点击Item后调用的方法
 *  @param image      图片
 *  @param hightImage 点击时的图片
 *
 *  @return 创建完的Item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image hightImgae:(NSString *)hightImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    //设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}


@end

