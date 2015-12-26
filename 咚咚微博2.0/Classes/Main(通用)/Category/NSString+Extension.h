//
//  NSString+Extension.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


- (CGSize)sizeWithFont:(UIFont *)font;
/**
 *  获取指定文本、字体大小、最大宽度限制
 *
 *  @param text 传入的文本
 *  @param font 指定传入文本的字体大小
 *  @param maxW 最大宽度限制
 *
 *  @return size大小
 */
-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

@end
