//
//  EmotionTabbar.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/13.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "EmotionTabbar.h"
#import "EmotionTabbarButton.h"

@interface EmotionTabbar()
@property(nonatomic,strong)EmotionTabbarButton *selectedBtn;//记录选中的按钮
@end
@implementation EmotionTabbar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:EmotionTabbarTypeRecent];
        [self setupBtn:@"默认" buttonType:EmotionTabbarTypeDefault];
        [self setupBtn:@"Emoji" buttonType:EmotionTabbarTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:EmotionTabbarTypeLxh];
    }
    return self;
}

/**
 *  创建一个按钮
 *
 *  @param title 按钮标题
 */
-(EmotionTabbarButton *)setupBtn:(NSString *)title buttonType:(EmotionTabbarType)buttonType
{
    EmotionTabbarButton *btn = [[EmotionTabbarButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchDown];
    [btn setTag:buttonType];
    [self addSubview:btn];

    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
//    
//    if (buttonType == EmotionTabbarTypeDefault) {
//        [self btnclick:btn];
//    }
    
    //设置背景图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)setDelegate:(id<EmotionTabbarDelegate>)delegate
{
    _delegate = delegate;
    [self btnclick:(EmotionTabbarButton *)[self viewWithTag:EmotionTabbarTypeDefault]];
}

-(void)btnclick:(EmotionTabbarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionTabbar:didSelectedButton:)]) {
        [self.delegate emotionTabbar:self didSelectedButton:btn.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置所有按钮的Frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width/count;
    CGFloat btnH = self.height;
    for (NSUInteger i=0; i<count; i++) {
        EmotionTabbarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i*btnW;
        btn.height = btnH;
    }
}
@end
