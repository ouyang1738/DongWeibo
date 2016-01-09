//
//  MainTabBarController.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/24.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "MessageCenterController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "CommonNavContoller.h"
#import "MyTabBar.h"
#import "WBComposeController.h"


@interface MainTabBarController ()<MyTabBarDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化子控制器
    //首页控制器
    HomeViewController *home = [[HomeViewController alloc]init];
    [self addChildVC:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    //消息控制器
    MessageCenterController *message = [[MessageCenterController alloc]init];
    [self addChildVC:message title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    //发现控制器
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    [self addChildVC:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    //我控制器
    ProfileViewController *profile = [[ProfileViewController alloc]init];
    [self addChildVC:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    //更换系统自带的Tabbar(KVC,修改系统只读属性)
//    self.tabBar = [[MyTabBar alloc]init];
    MyTabBar *tabbar=[[MyTabBar alloc]init];
    tabbar.delegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         icon
 *  @param selectedImage 选中icon
 */
-(void)addChildVC:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
//    childVc.tabBarItem.title = title;//设置TabBar的文字
//    childVc.navigationItem.title = title;//设置navigationBar的文字
    childVc.title = title;//同时设定TabBar和navigationBar的文字
    
    //设置子控制器TabBar的图标
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    
    //设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGBColor(123, 123, 123);
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = RandomColor;
    
    //添加为子控制器
    CommonNavContoller *nav = [[CommonNavContoller alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
}

#pragma mark MyTabBarDelegate
- (void)tabBarDidClickPlusButton:(MyTabBar *)tabBar
{
    WBComposeController *vc = [[WBComposeController alloc]init];
    CommonNavContoller *nav = [[CommonNavContoller alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
