//
//  WBAccountTool.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/30.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  处理账号相关的所有操作：存储账号、取出账号、验证账号

#import <Foundation/Foundation.h>
#import "WBAccount.h"
@interface WBAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(WBAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型
 */
+(WBAccount *)account;

@end
