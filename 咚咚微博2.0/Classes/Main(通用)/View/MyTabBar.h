//
//  MyTabBar.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/27.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTabBar;
//因为MyTabBar继承自UITabBar，所以成为MyTabBar的代理，也必须实现UITabBar的代理协议
@protocol MyTabBarDelegate <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlusButton:(MyTabBar *)tabBar;

@end

@interface MyTabBar : UITabBar

@property(nonatomic,weak)id<MyTabBarDelegate> delegate;

@end
