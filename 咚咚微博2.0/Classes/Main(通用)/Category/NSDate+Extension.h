//
//  NSDate+Extension.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  是否为昨天
 */
-(BOOL)isYesterday;
/**
 *  是否是今天
 */
-(BOOL)isToday;

/**
 *  是否是今年
 */
-(BOOL)isThisYear;
@end
