//
//  DateTransferTool.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "DateTransferTool.h"
#import "NSDate+Extension.h"
@implementation DateTransferTool

+(NSString *)transfer:(NSString *)originalDateStr
{
    //NSString--》NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    //设置日期格式
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createDate = [fmt dateFromString:originalDateStr];
    //当前时间
    NSDate *now = [NSDate date];
    //日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) {//今年
        if ([createDate isToday]) {//今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
            }else if(cmps.minute >= 1){
                return [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
            }else{
                return @"刚刚";
            }
        }else if ([createDate isYesterday]){//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else{//今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
@end
