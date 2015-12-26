//
//  PlaceHolderTextView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加文字改变监听
        //当UITextView文字发生改变，UITextView自己会发出一个UITextFieldTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = [placeHolder copy];
    [self setNeedsDisplay];
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
/**
 *  监听文字改变通知
 */
-(void)textDidChange
{
    //重绘，触发调用drawRect
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //如果有输入文字，直接返回，不画占位文字
    if (self.hasText) return;
    
    if (self.placeHolder) {
        //文字属性
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = self.font;
        if (self.placeHolderColor) {
            attrs[NSForegroundColorAttributeName] = self.placeHolderColor;
        }else{
            attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        }
        //画文字
        CGFloat x = 5;
        CGFloat w = rect.size.width - 2 * x;
        CGFloat y = 8;
        CGFloat h = rect.size.height - 2 * y;
        CGRect container = CGRectMake(x, y, w, h);
        [self.placeHolder drawInRect:container withAttributes:attrs];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
