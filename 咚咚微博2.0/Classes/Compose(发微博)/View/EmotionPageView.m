//
//  EmotionPageView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/17.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "EmotionPageView.h"
#import "EmotionButton.h"
#import "EmotionPopView.h"
#import "EmotionTool.h"
@interface EmotionPageView()
//点击表情图片后弹出的放大镜
@property(nonatomic,strong)EmotionPopView *popView;
//删除按钮
@property(nonatomic,strong)UIButton *deleteButton;

@end


@implementation EmotionPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.删除按钮
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;
        [self addSubview:deleteButton];
        
        //2.添加长按手势
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];

    }
    return self;
}

-(void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint loc = [recognizer locationInView:recognizer.view];
    EmotionButton *btn = [self emotionButtonWithLocation:loc];
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            //手势结束
            //移除popView
            [self.popView removeFromSuperview];
            if (btn) {
                //发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
        }
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:{
            [self.popView showFrom:btn];
            break;

        }
            
        default:
            break;
    }
}
/**
 *  根据手指所在的位置找出所在的表情按钮
 */
-(EmotionButton *)emotionButtonWithLocation:(CGPoint)loc
{
    //获得手指所在的位置\所在的表情按钮
    NSUInteger count = self.currentPageEmotions.count;
    //遍历所有的表情按钮
    for (int i=0; i<count; i++) {
        EmotionButton *btn = self.subviews[i+1];
        if (CGRectContainsPoint(btn.frame, loc)) {
            //显示popView
            [self.popView showFrom:btn];
            return btn;
        }
    }
    return nil;
}

/*
 监听删除按钮的点击事件
 */
-(void)deleteClick:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:EmotionDidDeleteNotification object:nil];
}

- (EmotionPopView *)popView{
    if (!_popView) {
        _popView = [EmotionPopView popView];
    }
    return _popView;
}

- (void)setCurrentPageEmotions:(NSArray *)currentPageEmotions
{
    _currentPageEmotions = currentPageEmotions;
    NSUInteger count = currentPageEmotions.count;
    for (int i=0; i<count; i++) {
        EmotionButton *btn = [[EmotionButton alloc]init];
        btn.tag = i;
        [self addSubview:btn];
        
        //设置表情数据
        btn.emotion = currentPageEmotions[i];
        
        //监听按钮的点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

/**
 监听表情按钮的点击
 */
-(void)btnClick:(EmotionButton *)btn
{
    //显示popView
    [self.popView showFrom:btn];
    

    //让popview自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    //发出通知
    [self selectEmotion:btn.emotion];
    
    
}

/**
 *  选中某个表情，发出通知
 *
 *  @param emtion
 */
-(void)selectEmotion:(Emotion *)emtion
{
    //将选中的表情存沙盒
    [EmotionTool addRecentEmotion:emtion];
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SelectEmotionKey] = emtion;
    [[NSNotificationCenter defaultCenter]postNotificationName:EmotionDidSelectNotification object:nil userInfo:userInfo];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.currentPageEmotions.count;
    CGFloat margin = 10;
    CGFloat btnW = (self.width - 2 * margin)/EmotionMaxCols;
    CGFloat btnH = (self.height - margin)/EmotionMaxRows;
    for (int i=0; i<count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = margin + (i%7)*btnW;
        btn.y = margin + (i/7)*btnH;
    }
    //删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - margin - btnW;
    
}

@end
