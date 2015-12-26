//
//  CommonNavContoller.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/25.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "CommonNavContoller.h"
#import "ItemTool.h"

@implementation CommonNavContoller


+ (void)initialize
{
    //设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //key:NS******AttributeName
    //设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];

    //设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];

}

/**
 *  重写这个方法的目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {//这时push进来的控制器不是根控制器
        [self setupBarButtonItem:viewController];
    }
    
    [super pushViewController:viewController animated:animated];
    
}

/**
 *  添加控制器左上角返回按钮和右上角更多按钮
 *
 */
-(void)setupBarButtonItem:(UIViewController *)viewController
{
    //自动显示和隐藏TabBar
    viewController.hidesBottomBarWhenPushed = YES;
    
    //左上角导航按钮
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:@"navigationbar_back" hightImgae:@"navigationbar_back_highlighted"];
    
    //右上角导航按钮
    viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:@"navigationbar_more" hightImgae:@"navigationbar_more_highlighted"];
    
}

/**
 *  返回上一个控制器
 *
 */
- (void)back:(UIViewController *)viewController
{
    [viewController.navigationController popViewControllerAnimated:YES];
}

/**
 *  返回至根控制器
 *
 */
-(void)more:(UIViewController *)viewController
{
    [viewController.navigationController popToRootViewControllerAnimated:YES];
}


@end
