//
//  WBAccount.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/29.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBAccount.h"

@implementation WBAccount
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    WBAccount *acc = [[WBAccount alloc]init];
    acc.access_token = dict[@"access_token"];
    acc.uid = dict[@"uid"];
    acc.expires_in = dict[@"expires_in"];
    //获得账号存储的时间
    acc.created_time = [NSDate date];
    return acc;
}

/**
 *  当一个对象要归档进沙盒时调用
 *
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.name forKey:@"name"];
}
/**
 *  当从沙盒中解档一个对象时调用
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end
