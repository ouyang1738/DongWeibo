//
//  EmotionPopView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/13.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "Emotion.h"

@interface EmotionPopView()
@property (weak, nonatomic) IBOutlet EmotionButton *emotionBtn;
@end

@implementation EmotionPopView

/** 
 当控件不是从xib，storyboard中创建时就会调用这个方法
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.emotionBtn.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    return self;
}
/**
 当控件是从xib，storyboard中创建时就会调用这个方法
 */
+ (instancetype)popView{
    return [[[NSBundle mainBundle]loadNibNamed:@"EmotionPopView" owner:nil options:nil]lastObject];
}

//- (void)setEmotion:(Emotion *)emotion
//{
//    _emotion = emotion;
//    self.emotionBtn.emotion = emotion;
//}

-(void)showFrom:(EmotionButton *)btn
{
    if (btn==nil) {
        return;
    }
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    [win addSubview:self];
    
    //计算出被点击的按钮在window中的frame
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
    self.emotionBtn.emotion = btn.emotion;
}

@end
