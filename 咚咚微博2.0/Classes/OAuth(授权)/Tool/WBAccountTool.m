//
//  WBAccountTool.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/30.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBAccountTool.h"
#import "WBAccount.h"

//账号的存储路径
#define WBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation WBAccountTool

+(void)saveAccount:(WBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:WBAccountPath];
}

+ (WBAccount *)account
{
    //将沙盒存储的账号信息转为WBAccount对象
    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WBAccountPath];
    //验证账号是否过期
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间 (dateByAddingTimeInterval:返回以当前NSDate对象为基准，偏移多少秒后得到的新NSDate对象。)
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //当前日期
    NSDate *now = [NSDate date];
    //比较当前时间与过期时间的大小
    NSComparisonResult result = [expiresTime compare:now];
    
    /**
        NSOrderedAscending:升序： 左边 < 右边
        NSOrderedDescending:降序：左边 > 右边
        NSOrderedSame：相等
     */
    if (result != NSOrderedDescending) {//过期
        return nil;
    }
    return account;
}

@end
