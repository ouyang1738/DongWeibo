//
//  WBStatusFrame.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/5.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  一个WBStatusFrame模型包含的信息
//  1、存放着一个Cell内部所有子控件的Frame数据
//  2、存放一个Cell的高度
//  3、存放一个数据模型WBStatus
//

#import <Foundation/Foundation.h>
#import "WBStatus.h"

//昵称字体
#define kStatusCellNameFont [UIFont systemFontOfSize:15]
//时间字体
#define kStatusCellTimeFont [UIFont systemFontOfSize:12]
//来源字体
#define kStatusCellSourceFont [UIFont systemFontOfSize:12]
//正文字体
#define kStatusCellContentFont [UIFont systemFontOfSize:15]
//被转发正文字体
#define kStatusCellRetweetContentFont [UIFont systemFontOfSize:13]

#define kStatusCellBorderW 10
#define kStatusCellMargin 10

@interface WBStatusFrame : NSObject

@property(nonatomic,strong)WBStatus *status;
/** 原创微博container视图 */
@property(nonatomic,assign)CGRect originalViewF; 
/** 头像 */
@property(nonatomic,assign)CGRect iconViewF; 
/** vip图标 */
@property(nonatomic,assign)CGRect vipViewF; 
/** 配图 */
@property(nonatomic,assign)CGRect photosViewF;
/** 昵称 */
@property(nonatomic,assign)CGRect nameLabelF; 
/** 时间 */
@property(nonatomic,assign)CGRect timeLabelF; 
/** 来源 */
@property(nonatomic,assign)CGRect sourceLabelF; 
/** 正文 */
@property(nonatomic,assign)CGRect contentLabelF;

/** 转发微博 */
/** 转发微博整体 */
@property(nonatomic,assign)CGRect retweetViewF;
/** 转发微博正文 */
@property(nonatomic,assign)CGRect retweetContentLabelF;
/** 转发微博配图 */
@property(nonatomic,assign)CGRect retweetPhotosViewF;
/** 底部操作条 */
@property(nonatomic,assign)CGRect operationBarF;

/** Cell的高度 */
@property(nonatomic,assign)CGFloat cellHeight;


@end
