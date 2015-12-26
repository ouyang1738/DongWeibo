//
//  EmotionTabbarButton.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/14.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "EmotionTabbarButton.h"

@implementation EmotionTabbarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        //设置字体
        [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }
    return self;
}
//屏蔽按钮高亮状态
- (void)setHighlighted:(BOOL)highlighted{}

@end
