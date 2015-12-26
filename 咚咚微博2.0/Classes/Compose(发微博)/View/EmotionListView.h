//
//  EmotionListView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/13.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  显示表情的内容

#import <UIKit/UIKit.h>

@interface EmotionListView : UIView
/** 表情数组（里面存放的是Emotion模型） */
@property(nonatomic,strong)NSArray *emotions;
@end
