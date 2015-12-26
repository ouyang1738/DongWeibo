//
//  WBComposePhotosView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBComposePhotosView.h"
@interface WBComposePhotosView()
//@property(nonatomic,strong)NSMutableArray *addedPhotos;
@end
@implementation WBComposePhotosView

//- (NSMutableArray *)addedPhotos
//{
//    if (!_addedPhotos) {
//        _addedPhotos = [NSMutableArray array];
//    }
//    return _addedPhotos;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}


- (void)addPhoto:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self addSubview:imageView];
    [_photos addObject:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片的位置和宽高
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    for (NSUInteger i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        NSUInteger col = i % maxCol;
        NSUInteger row = i / maxCol;
        
        photoView.x = col * (imageWH + imageMargin);
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

//- (NSArray *)photos
//{
////    NSMutableArray *photosArr = [NSMutableArray array];
//    return self.addedPhotos;
//}
@end
