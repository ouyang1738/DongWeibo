//
//  EmotionTabbar.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/13.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  表情键盘底部的选项卡

#import <UIKit/UIKit.h>

typedef enum{
    EmotionTabbarTypeRecent,
    EmotionTabbarTypeDefault,
    EmotionTabbarTypeEmoji,
    EmotionTabbarTypeLxh
} EmotionTabbarType;

@class EmotionTabbar;
@protocol EmotionTabbarDelegate<NSObject>
@optional
-(void)emotionTabbar:(EmotionTabbar *)tabbar didSelectedButton:(EmotionTabbarType)type;
@end
@interface EmotionTabbar : UIView
@property(nonatomic,weak)id<EmotionTabbarDelegate> delegate;
@end
