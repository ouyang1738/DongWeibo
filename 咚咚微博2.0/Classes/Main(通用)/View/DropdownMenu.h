//
//  DropdownMenu.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/27.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;
/**
 *  代理协议：提供显示和销毁的协议方法
 */
@protocol DropdownMenuDelegate <NSObject>

@optional
-(void)dropdownMenuDidDismiss:(DropdownMenu *)dropMenu;
-(void)dropdownMenuDidShow:(DropdownMenu *)dropMenu;
@end

@interface DropdownMenu : UIView

/**
 *  下拉菜单内部视图
 */
@property(nonatomic,strong)UIView *contentView;

/**
 *  下拉菜单内部控制器
 */
@property(nonatomic,strong)UIViewController *contentController;

/**
 *  代理
 */
@property(nonatomic,weak)id<DropdownMenuDelegate> delegate;

+(instancetype)menu;

/**
 *  显示方法
 *
 *  @param from 位于指定控件下方
 */
-(void)showFrom:(UIView *)from;

/**
 *  销毁
 */
-(void)dismiss;

@end
