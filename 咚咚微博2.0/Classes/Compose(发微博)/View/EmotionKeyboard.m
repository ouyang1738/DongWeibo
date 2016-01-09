//
//  EmotionKeyboard.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/13.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "Emotion.h"
#import "EmotionTool.h"


@interface EmotionKeyboard()<EmotionTabbarDelegate>

@property(nonatomic,strong)EmotionListView *recentView;
@property(nonatomic,strong)EmotionListView *defaultView;
@property(nonatomic,strong)EmotionListView *emojiView;
@property(nonatomic,strong)EmotionListView *lxhView;
/** 容纳表情内容的控件 */
@property(nonatomic,weak)UIView *contentView;

@property(nonatomic,weak)EmotionTabbar *tabbar;
@end

@implementation EmotionKeyboard
#pragma mark - 懒加载
- (EmotionListView *)recentView
{
    if (!_recentView) {
        self.recentView = [[EmotionListView alloc]init];
        self.recentView.emotions = [EmotionTool recentEmotions];
    }
    return _recentView;
}

- (EmotionListView *)defaultView
{
    if (!_defaultView) {
        self.defaultView = [[EmotionListView alloc]init];
        NSArray *defaultEmotions = [EmotionTool defaultEmotions];
        [_defaultView setEmotions:defaultEmotions];
    }
    return _defaultView;
}

- (EmotionListView *)emojiView
{
    if (!_emojiView) {
        self.emojiView = [[EmotionListView alloc]init];
        NSArray *emojiEmotions = [EmotionTool emojiEmotions];
        [self.emojiView setEmotions:emojiEmotions];
    }
    return _emojiView;
}

- (EmotionListView *)lxhView
{
    if (!_lxhView) {
        self.lxhView = [[EmotionListView alloc]init];
        NSArray *lxhEmotions = [EmotionTool lxhEmotions];
        [self.lxhView setEmotions:lxhEmotions];

    }
    return _lxhView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.设置contentView
        UIView *contentView = [[UIView alloc]init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        //2.TabBar
        EmotionTabbar *tabbar = [[EmotionTabbar alloc]init];
        tabbar.delegate = self;
        [self addSubview:tabbar];
        self.tabbar = tabbar;
        
        //监听表情选中的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionSelect) name:EmotionDidSelectNotification object:nil];
        
    }
    return self;
}

-(void)emotionSelect
{
    self.recentView.emotions = [EmotionTool recentEmotions];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.tabbar
    self.tabbar.height = 37;
    self.tabbar.x = 0;
    self.tabbar.y = self.height - self.tabbar.height;
    self.tabbar.width = self.width;
    
    //2.计算contentView的Frame
    self.contentView.x = self.contentView.y = 0;
    self.contentView.width = self.width;
    self.contentView.height = self.tabbar.y;
    
    //3.设置listView的Frame
    UIView *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;
}

#pragma mark - EmotionTabbarDelegate
- (void)emotionTabbar:(EmotionTabbar *)tabbar didSelectedButton:(EmotionTabbarType)type
{
    //移除contentView之前显示的控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //根据点击的按钮类型，切换contentView上面的listView
    switch (type) {
        case EmotionTabbarTypeRecent://最近
            [self.contentView addSubview:self.recentView];
            break;
        
        case EmotionTabbarTypeDefault://默认
            Log(@"默认");
            [self.contentView addSubview:self.defaultView];

            break;
        
        case EmotionTabbarTypeEmoji://Emoji
            Log(@"Emoji");
            [self.contentView addSubview:self.emojiView];

            break;
        
        case EmotionTabbarTypeLxh://浪小花
            Log(@"浪小花");
            [self.contentView addSubview:self.lxhView];

            break;
    }
    
    //重新计算子控件的Frame(setNeedsLayout方法内部会在恰当的时候重新调用layoutsubviews，重新布局子控件)
    [self setNeedsLayout];
    
}

@end
