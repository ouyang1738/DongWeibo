//
//  EmotionAttachment.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/20.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionAttachment : NSTextAttachment
@property(nonatomic,strong)Emotion *emotion;
@end
