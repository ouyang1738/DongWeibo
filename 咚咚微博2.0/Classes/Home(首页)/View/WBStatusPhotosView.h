//
//  WBStatusPhotosView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  Cell上的配图，里面会显示1~9张图片

#import <UIKit/UIKit.h>

@interface WBStatusPhotosView : UIView
@property(nonatomic,strong)NSArray *photos;

+(CGSize)sizeWithCount:(NSInteger)count;

@end
