//
//  WBAccount.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/29.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccount : NSObject<NSCoding>

@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSNumber *expires_in;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSDate *created_time;

+(instancetype)accountWithDict:(NSDictionary *)dict;

@end
