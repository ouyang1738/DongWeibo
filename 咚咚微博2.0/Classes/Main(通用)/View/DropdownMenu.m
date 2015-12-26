//
//  DropdownMenu.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/27.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "DropdownMenu.h"

@interface DropdownMenu()
/**
 *  显示具体内容的容器View
 */
@property(nonatomic,weak)UIImageView *containerView;

@end


@implementation DropdownMenu

/**
 *  懒加载
 *
 */
- (UIImageView *)containerView
{
    if (_containerView == nil) {
        //添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc]init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        containerView.width = 217;
        containerView.height = 250;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc]init];
}

/**
 *  设置内部视图
 *
 *  @param contentView 指定的内部视图
 */
- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    //调整内容的位置
    contentView.x = 10;
    contentView.y = 15;
    
    //设置灰色的高度
    self.containerView.height = CGRectGetMaxY(contentView.frame)+12;
    //设置灰色的宽带
    self.containerView.width = CGRectGetMaxX(contentView.frame) + 10;
    
    [self.containerView addSubview:contentView];
}

/**
 *  设置内部视图控制器
 *
 *  @param contentController 指定控制器
 */
- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.contentView = contentController.view;
}

/**
 *  从指定控制正下方显示
 */
-(void)showFrom:(UIView *)from
{
    //1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //2.添加自己到窗口
    [window addSubview:self];
    
    //3.设置尺寸
    self.frame = window.bounds;
    
    //4.调整自己的位置
    //默认情况下，Frame是以父控件左上角为坐标原点
    //转换坐标系
    //将from.frame的坐标系从from.superview的坐标系 转换到 window的坐标系
    //算一下from.frame在window坐标系中的位置
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    //通知外界，自己被显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
    
}

/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    
    //通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

/**
 *  点击下拉菜单外部范围时将菜单销毁
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


@end
