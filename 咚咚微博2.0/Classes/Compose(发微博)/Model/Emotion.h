//
//  Emotion.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/15.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject<NSCoding>
//表情的文字描述
@property(nonatomic,copy)NSString *chs;
//表情的PNG图片名
@property(nonatomic,copy)NSString *png;
//emoji表情的16进制的编码
@property(nonatomic,copy)NSString *code;

@end
