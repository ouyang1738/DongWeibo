//
//  LoadMoreFooter.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter
+ (instancetype)footer
{
    return [[[NSBundle mainBundle]loadNibNamed:@"LoadMoreFooter" owner:nil options:nil]lastObject];
}
@end
