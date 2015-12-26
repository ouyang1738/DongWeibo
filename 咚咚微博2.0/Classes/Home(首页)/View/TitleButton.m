//
//  TitleButton.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "TitleButton.h"
#define kMargin 5

@implementation TitleButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        //设置图标居中
        self.imageView.contentMode=UIViewContentModeCenter ;
    }
    return self;
}

/**
 *  重写的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后再做修改，而且要保证修改成功，一般都是在setFrame中设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.width += kMargin;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //如果仅仅是调整内部TitleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    //1.调整TitleLabel的x
    self.titleLabel.x = self.imageView.x;
    //2.调整ImageView的x
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + kMargin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

/**
 *  设置按钮内部Title的Frame
 *
 *  @param contentRect 按钮的bounds
 *
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x=0;
//    CGFloat y=0;
//    CGFloat width=80;
//    CGFloat height=contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}
///**
// *  设置按钮内部Image的Frame
// *
// *  @param contentRect 按钮的bounds
// *
// */
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x=0;
//    CGFloat y=0;
//    CGFloat width=80;
//    CGFloat height=contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}



@end
