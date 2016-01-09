//
//  WBStatusTextView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 16/1/2.
//  Copyright © 2016年 J.Beyond. All rights reserved.
//

#import "WBStatusTextView.h"
#import "WBSpecial.h"

#define WBStatusTextViewCoverTag 100
@interface WBStatusTextView()

@end

@implementation WBStatusTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textContainerInset = UIEdgeInsetsZero;
        self.editable = NO;
        //禁止文字滚动，让文字完全显示出来
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
//        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //触摸对象
    UITouch *touch = [touches anyObject];
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点找出被触摸的特殊字符串
    //在被触摸的特殊字符串后面显示一段高亮的背景
    WBSpecial *special = [self touchingSpecialWithPoint:point];
    for (NSValue *rectValue in special.rects) {
        UIView *cover = [[UIView alloc]init];
        cover.backgroundColor = [UIColor greenColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = WBStatusTextViewCoverTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
}


-(WBSpecial *)touchingSpecialWithPoint:(CGPoint)point
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (WBSpecial *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {//点中了某个特殊字符串
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView * child in self.subviews) {
        if (child.tag == WBStatusTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)setupSpecialRects
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (WBSpecial *special in specials) {
        self.selectedRange = special.range;
        //获取选中范围的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        //清除选中范围
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            //添加rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
}

/**
 *  告诉系统，触摸点point是否在这个UI控件身上
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    [self setupSpecialRects];
    WBSpecial *special = [self touchingSpecialWithPoint:point];
    if (special) {
        return YES;
    }
    return NO;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return [super hitTest:point withEvent:event];
//}

/**
 
 iOS触摸事件处理
 1、判断触摸点在谁身上，调用所有UI控件的- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
 2、由触摸点所在的UI控件选出处理事件的UI控件：- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 */



@end
