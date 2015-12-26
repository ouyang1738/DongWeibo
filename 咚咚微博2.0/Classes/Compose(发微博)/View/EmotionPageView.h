//
//  EmotionPageView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/17.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  用来表示一页的表情（里面显示0-20个表情）

#import <UIKit/UIKit.h>
//一行中最多7列
#define EmotionMaxCols 7
//一页中最多三行
#define EmotionMaxRows 3
//一页的表情个数
#define EmotionPageSize 20

@interface EmotionPageView : UIView
/** 这一页显示的表情（里面都是Emotion表情） */
@property(nonatomic,strong)NSArray *currentPageEmotions;

@end
