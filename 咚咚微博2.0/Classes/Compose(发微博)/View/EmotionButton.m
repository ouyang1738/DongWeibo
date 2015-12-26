//
//  EmotionButton.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/13.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionButton.h"

@implementation EmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        //按钮高亮的时候不要显示高亮颜色
        self.adjustsImageWhenHighlighted = YES;
    }
    return self;
}

//- (void)setHighlighted:(BOOL)highlighted{}

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    if (emotion.code) {//Emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:32]];
    }else if(emotion.png){//图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }
    
}

@end
