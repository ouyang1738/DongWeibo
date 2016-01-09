//
//  EmotionTool.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/25.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionTool.h"
#import "MJExtension.h"


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

static NSArray *_emojiEmotions,*_defaultEmotions,*_lxhEmotions;
+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions =  [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}
+(NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}
+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}
+ (Emotion *)emtionWithChs:(NSString *)chs
{
    NSArray *defaults = [self defaultEmotions];
    for (Emotion *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    NSArray *lxhs = [self lxhEmotions];
    for (Emotion *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    NSArray *emojis = [self defaultEmotions];
    for (Emotion *emotion in emojis) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}

@end
