//
//  WBStatusTextView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 16/1/2.
//  Copyright © 2016年 J.Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBStatusTextView : UITextView
//存放所有特殊字符串（WBSpecial）
@property(nonatomic,strong)NSArray *specials;
@end
