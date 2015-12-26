//
//  NSDate+Extension.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/**
 *  是否为昨天
 */
-(BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    
    //格式化时间，将后面的时分秒去掉
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    NSDate *date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    //日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    //计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 00 && cmps.day == 1;
    
}
/**
 *  是否是今天
 */
-(BOOL)isToday
{
    NSDate *now = [NSDate date];
    
    //格式化时间，将后面的时分秒去掉
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

/**
 *  是否是今年
 */
-(BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //只获取年
    NSCalendarUnit unit = NSCalendarUnitYear;
    //获取某个时间的年
    NSDateComponents *dateCmps = [calendar components:unit fromDate:self];
    //当前时间的年
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
    
}
@end
