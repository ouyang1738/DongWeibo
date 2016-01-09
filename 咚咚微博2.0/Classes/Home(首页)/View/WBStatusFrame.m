//
//  WBStatusFrame.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/5.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBStatusFrame.h"
#import "WBStatusPhotosView.h"





@implementation WBStatusFrame

/**
 *  为控件设置Frame属性
 *
 *  @param status Cell模型数据
 */
- (void)setStatus:(WBStatus *)status
{
    _status = status;
    WBUser *user = status.user;
    
    //屏幕的宽度为Cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    //头像
    CGFloat iconWH = 50;
    CGFloat iconX = kStatusCellBorderW;
    CGFloat iconY = kStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + kStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:kStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    
    //会员图标
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + kStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF)+kStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:kStatusCellTimeFont];
    self.timeLabelF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    //来源
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF)+kStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:kStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX,sourceY},sourceSize};
    
    //正文
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + kStatusCellBorderW;
    CGFloat maxW = cellW - 2 * kStatusCellBorderW;
    CGSize contentSize = [status.attrText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    
    //配图
    CGFloat originalH = 0;
    if (status.pic_urls.count) {//有配图
//        CGFloat photoWH = 100;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + kStatusCellBorderW;
        CGSize photosSize = [WBStatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewF = (CGRect){{photoX,photoY},photosSize};
        originalH = CGRectGetMaxY(self.photosViewF);
    }else{//没有配图
        originalH = CGRectGetMaxY(self.contentLabelF);
    }
    
    //原创微博整体
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH+kStatusCellBorderW);
    
    CGFloat operationBarY = 0;
    //被转发微博
    if (status.retweeted_status) {//有转发微博
        //数据模型
        WBStatus *retweeted_status = status.retweeted_status;
        WBUser *retweeted_user = retweeted_status.user;
        
        //被转发微博的正文
        CGFloat reweetContentX = kStatusCellBorderW;
        CGFloat reweetContentY = kStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@",retweeted_user.name,retweeted_status.text];
        CGSize retweetContentSize = [status.reweetAttrText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.retweetContentLabelF = (CGRect){{reweetContentX,reweetContentY},retweetContentSize};
        
        //被转发微博的配图
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) {//有配图
            CGFloat retweetPhotoX = reweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + kStatusCellBorderW;
            CGSize retweetPhotosSize = [WBStatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewF = (CGRect){{retweetPhotoX,retweetPhotoY},retweetPhotosSize};
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF)+kStatusCellBorderW;
            
        }else{//没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF)+kStatusCellBorderW;
        }
        
        //被转发微博的整体
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        operationBarY = CGRectGetMaxY(self.retweetViewF) + 0.5;
    }else{//没有转发微博
        operationBarY = CGRectGetMaxY(self.originalViewF) + 0.5;
    }
    
    //操作条
    CGFloat operationBarX = 0;
    CGFloat operationBarW = cellW;
    CGFloat operationBarH = 40;
    self.operationBarF = CGRectMake(operationBarX, operationBarY, operationBarW, operationBarH);
    
    //Cell的总高度
    self.cellHeight = CGRectGetMaxY(self.operationBarF) + kStatusCellMargin;
}


@end
