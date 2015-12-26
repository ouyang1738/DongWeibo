//
//  EmotionAttachment.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/20.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"

@implementation EmotionAttachment
- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
    
}
@end
