//
//  WBTextPart.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 16/1/2.
//  Copyright © 2016年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  文字的一部分
 */
@interface WBTextPart : NSObject
/**这段文字的内容*/
@property(nonatomic,copy)NSString *text;
/**这段文字的范围*/
@property(nonatomic,assign)NSRange range;
/**是否特殊文字*/
@property(nonatomic,assign,getter=isSpecial) BOOL special;
/**是否表情*/
@property(nonatomic,assign,getter=isEmotion) BOOL emtion;

@end
