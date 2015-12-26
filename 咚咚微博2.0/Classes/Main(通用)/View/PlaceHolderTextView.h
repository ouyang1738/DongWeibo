//
//  PlaceHolderTextView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  增强版的textView【带占位文字】

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView

@property(nonatomic,copy)NSString *placeHolder;//占位文字
@property(nonatomic,strong)UIColor *placeHolderColor;//占位文字颜色

@end
