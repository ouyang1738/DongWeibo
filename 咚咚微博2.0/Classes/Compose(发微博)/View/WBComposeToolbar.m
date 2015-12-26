//
//  WBComposeToolbar.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBComposeToolbar.h"
@interface WBComposeToolbar()

@property(nonatomic,weak)UIButton *emotionButton;

@end

@implementation WBComposeToolbar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化按钮
        [self setupButton:@"compose_camerabutton_background" highImgae:@"compose_camerabutton_background_highlighted" type:WBComposeToolbarTypeCarema];
        [self setupButton:@"compose_toolbar_picture" highImgae:@"compose_toolbar_picture_highlighted" type:WBComposeToolbarTypePicture];
        [self setupButton:@"compose_mentionbutton_background" highImgae:@"compose_mentionbutton_background_highlighted" type:WBComposeToolbarTypeMention];
        [self setupButton:@"compose_trendbutton_background" highImgae:@"compose_trendbutton_background_highlighted" type:WBComposeToolbarTypeTrend];
        self.emotionButton = [self setupButton:@"compose_emoticonbutton_background" highImgae:@"compose_emoticonbutton_background_highlighted" type:WBComposeToolbarTypeEmotion];
    }
    
    return self;
}

/**
 *  创建一个按钮
 *
 *  @param image     按钮的图片
 *  @param highImage 按钮高亮的图片
 *
 *  @return 创建的按钮
 */
-(UIButton *)setupButton:(NSString *)image highImgae:(NSString *)highImage type:(WBComposeToolbarType)type
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:type];
    [self addSubview:btn];
    return btn;
}

-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
//        NSUInteger index = (NSUInteger)(btn.x/btn.width);
        [self.delegate composeToolbar:self didClickButton:(WBComposeToolbarType)btn.tag];
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
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i*btnW;
        btn.height = btnH;
    }
}
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    NSString *image = @"compose_mentionbutton_background";
    NSString *hightImage = @"compose_mentionbutton_background_highlighted";

    if (showKeyboardButton) {
        //显示键盘图标
        image = @"compose_keyboardbutton_background";
        hightImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    
}

@end
