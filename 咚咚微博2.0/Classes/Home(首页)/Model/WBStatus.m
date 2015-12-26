//
//  WBStatus.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBStatus.h"
#import "MJExtension.h"
#import "WBPhoto.h"
#import "NSDate+Extension.h"
#import "DateTransferTool.h"
@implementation WBStatus

/**
 *  指定数组pic_urls中的元素为WBPhoto
 */
+(NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[WBPhoto class]};
}

- (NSString *)created_at
{
    return [DateTransferTool transfer:_created_at];
}

//source = <a href="http://app.weibo.com/t/feed/1sxHP2" rel="nofollow">专业版微博</a>
- (void)setSource:(NSString *)source
{
    _source = source;
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
    _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    
}



@end
