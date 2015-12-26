//
//  WBComposePhotosView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  键盘Tab之上的部分：ScrollView + pageControl

#import <UIKit/UIKit.h>

@interface WBComposePhotosView : UIView
-(void)addPhoto:(UIImage *)image;
@property(nonatomic,strong,readonly)NSMutableArray *photos;
@end
