//
//  WBUser.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBUser.h"

@implementation WBUser
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    self.vip = mbtype > 2;
}
- (BOOL)isVip
{
    return self.mbrank > 2;
}

@end
