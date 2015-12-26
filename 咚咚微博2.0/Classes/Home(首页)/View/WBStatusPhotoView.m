//
//  WBStatusPhotoView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBStatusPhotoView.h"
#import "UIImageView+WebCache.h"

@interface WBStatusPhotoView()
@property(nonatomic,weak)UIImageView *gifView;
@end

@implementation WBStatusPhotoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        /**
         UIViewContentModeScaleToFill,  //图片拉伸至填充整个UIImageView(图片可能变形)
         UIViewContentModeScaleAspectFit,   //等比例压缩至完全显示在UIImageView中（不会变形）
         UIViewContentModeScaleAspectFill,     //图片拉伸至图片的宽度或高度等于UIImageView的高度为止
         UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
         UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         规律：
         1、凡是带有Scale单词的，图片都会拉伸；
         2、凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
         */
        
        
        UIImage *gifImage = [UIImage imageNamed:@"timeline_image_gif"];
        //UIImageView的尺寸等于UIImage的尺寸
        UIImageView *gifView = [[UIImageView alloc]initWithImage:gifImage];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhoto:(WBPhoto *)photo
{
    _photo = photo;
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
   
//    if ([photo.thumbnail_pic hasSuffix:@"gif"]) {
//        self.gifView.hidden = NO;
//    }else{
//        self.gifView.hidden = YES;
//    }
    //考虑到gif/GIF 后缀
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

/**
 *  设置子控件尺寸最好在layoutSubviews方法中
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //将gif图标显示在右下角
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

@end
