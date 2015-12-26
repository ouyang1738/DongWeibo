//
//  EmotionTextView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/19.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "PlaceHolderTextView.h"
@class Emotion;
@interface EmotionTextView : PlaceHolderTextView
-(void)insertEmotion:(Emotion *)emotion;
-(NSString *)fullText;
@end
