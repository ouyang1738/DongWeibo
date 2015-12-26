//
//  EmotionTool.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/25.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionTool.h"

//最近使用的表情路径
#define RecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

@implementation EmotionTool

static NSMutableArray *_recentEmotions;
+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+(void)addRecentEmotion:(Emotion *)emotion
{
    //加载沙盒中的表情数据
        //删除重复的表情
//    for (NSUInteger i = 0; i<emotions.count; i++) {
//        Emotion *e = emotions[i];
//        if([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString:emotion.code]){
//            [emotions removeObject:emotion];
//            break;
//        }
//    }
    [_recentEmotions removeObject:emotion];
    
    //将表情添加到数组最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentEmotionsPath];
}

/**
 *  返回装着Emotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}
@end
