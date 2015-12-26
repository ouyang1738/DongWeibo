//
//  Emotion.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/15.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "Emotion.h"

@implementation Emotion

/**
 *  从文件中解析对象时调用
 *
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.chs = [coder decodeObjectForKey:@"chs"];
        self.png = [coder decodeObjectForKey:@"png"];
        self.code = [coder decodeObjectForKey:@"code"];
    }
    return self;
}

/**
 *  将对象写入文件中调用
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.chs forKey:@"chs"];
    [coder encodeObject:self.png forKey:@"png"];
    [coder encodeObject:self.code forKey:@"code"];
}


/**
 *  用来比较两个对象是否一样
 */
- (BOOL)isEqual:(id)object
{
    Emotion *other = object;
    if ([self.chs isEqualToString: other.chs] || [self.code isEqualToString:other.code]) {
        return YES;
    }
    return NO;
}

@end
