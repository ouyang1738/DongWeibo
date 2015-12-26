//
//  EmotionTool.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/25.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Emotion.h"

@interface EmotionTool : NSObject
+(void)addRecentEmotion:(Emotion *)emotion;
+(NSArray *)recentEmotions;
@end
