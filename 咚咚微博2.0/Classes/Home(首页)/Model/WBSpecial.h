//
//  WBSpecial.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 16/1/2.
//  Copyright © 2016年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSpecial : NSObject
/**这段特殊文字的内容*/
@property(nonatomic,copy)NSString *text;
/**这段特殊文字的范围*/
@property(nonatomic,assign)NSRange range;
/**这段特殊文字的rects*/
@property(nonatomic,strong)NSArray *rects;

@end
