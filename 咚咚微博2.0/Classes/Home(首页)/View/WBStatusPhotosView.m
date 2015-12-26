//
//  WBStatusPhotosView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#define WBStatusPhotoWH 70
#define WBStatusPhotoMargin 10
#define kStatusPhotoMaxCol(count) ((count==4)?2:3)

#import "WBStatusPhotosView.h"
#import "WBPhoto.h"
#import "WBStatusPhotoView.h"
@implementation WBStatusPhotosView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    //创建足够数量的ImageView
    while (self.subviews.count < photos.count) {
        WBStatusPhotoView *photoView = [[WBStatusPhotoView alloc]init];
        [self addSubview:photoView];
    }
    
    //遍历所有imageView，设置Image
    for (NSInteger i=0; i<self.subviews.count; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        if (i < photos.count) {
            photoView.hidden = NO;
            photoView.photo = photos[i];
        }else{
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSInteger photosCount = self.photos.count;
    int maxCol = kStatusPhotoMaxCol(photosCount);
    for (int i=0; i<photosCount; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        int col = i % maxCol;
        int row = i / maxCol;
        
        photoView.x = col * (WBStatusPhotoWH + WBStatusPhotoMargin);
        photoView.y = row * (WBStatusPhotoWH + WBStatusPhotoMargin);
        photoView.width = WBStatusPhotoWH;
        photoView.height = WBStatusPhotoWH;
    }
}

/**
 *  根据图片个数计算相册的尺寸
 */
+(CGSize)sizeWithCount:(NSInteger)count
{
    int maxCols = kStatusPhotoMaxCol(count);
    //行数
    NSInteger cols = (count >= maxCols)?maxCols:count;
    CGFloat photosW = cols*WBStatusPhotoWH + (cols - 1)* WBStatusPhotoMargin;
    
    //列数
    NSInteger rows = (count + maxCols - 1)/maxCols;
    CGFloat photosH = rows * WBStatusPhotoWH + (rows - 1)* WBStatusPhotoMargin;
    
    
    return CGSizeMake(photosW, photosH);
}
@end
