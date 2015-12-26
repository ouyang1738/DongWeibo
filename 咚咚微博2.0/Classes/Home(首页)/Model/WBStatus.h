//
//  WBStatus.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

@interface WBStatus : NSObject
/** 微博id */
@property(nonatomic,copy)NSString *idstr;
/** 微信信息内容 */
@property(nonatomic,copy)NSString *text;
/** 微博作者的用户信息 */
@property(nonatomic,strong)WBUser *user;
/** 微博创建时间 */
@property(nonatomic,copy)NSString *created_at;
/** 微博来源 */
@property(nonatomic,copy)NSString *source;
/** 微博配图URL数组 */
@property(nonatomic,strong)NSArray *pic_urls;
/** 被转发的微博 */
@property(nonatomic,strong)WBStatus *retweeted_status;

/** 转发数 */
@property(nonatomic,assign)int reposts_count;
/** 评论数 */
@property(nonatomic,assign)int comments_count;
/** 表态数 */
@property(nonatomic,assign)int attritutes_count;


@end
