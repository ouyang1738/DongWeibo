//
//  WBStatusCell.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/5.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBStatusCell.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
#import "WBPhoto.h"
#import "WBOperationBar.h"
#import "WBStatusPhotosView.h"
#import "WBIconView.h"

@interface WBStatusCell()
/**
 *  原创微博container视图
 */
@property(nonatomic,weak)UIView *originalView;
/** 头像 */
@property(nonatomic,weak)WBIconView *iconView;
/** vip图标 */
@property(nonatomic,weak)UIImageView *vipView;
/** 配图 */
@property(nonatomic,weak)WBStatusPhotosView *photosView;
/** 昵称 */
@property(nonatomic,weak)UILabel *nameLabel;
/** 时间 */
@property(nonatomic,weak)UILabel *timeLabel;
/** 来源 */
@property(nonatomic,weak)UILabel *sourceLabel;
/** 正文 */
@property(nonatomic,weak)UILabel *contentLabel;

/** 转发微博 */
/** 转发微博整体 */
@property(nonatomic,weak)UIView *retweetView;
/** 转发微博正文 */
@property(nonatomic,weak)UILabel *retweetContentLabel;
/** 转发微博配图 */
@property(nonatomic,weak)WBStatusPhotosView *retweetPhotosView;

/** 转发、评论、赞操作条 */
@property(nonatomic,weak)WBOperationBar *operationBar;

@end

@implementation WBStatusCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIndentifer = @"Cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifer];
    if (cell == nil) {
        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifer];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //点击Cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置选中时的背景
//        UIView *bg = [[UIView alloc]init];
//        bg.backgroundColor = [UIColor lightTextColor];
//        self.selectedBackgroundView = bg;
        
        //初始化原创微博
        [self setupOriginal];
        
        //初始化转发微博
        [self setupRetweet];
        
        //初始化操作条
        [self setupOperationBar];
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += kStatusCellMargin;
    [super setFrame:frame];
}

/**
 * 初始化操作条
 */
-(void)setupOperationBar
{
    WBOperationBar *operationBar = [WBOperationBar operationBar];
    [self.contentView addSubview:operationBar];
    self.operationBar = operationBar;
}

/**
 *  初始化转发微博
 */
-(void)setupRetweet
{
    //1.转发微博整体
    UIView *retweetView = [[UIView alloc]init];
    [retweetView setBackgroundColor:RGBColor(245, 245, 245)];
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    //2.转发微博正文
    UILabel *retweetContentLabel = [[UILabel alloc]init];
    retweetContentLabel.font = kStatusCellRetweetContentFont;
    retweetContentLabel.numberOfLines = 0;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    //3.转发微博的配图
    WBStatusPhotosView *retweetPhotoView = [[WBStatusPhotosView alloc]init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotosView = retweetPhotoView;
    
}

/**
 *  初始化原创微博
 */
-(void)setupOriginal
{
    //1.原创微博整体
    UIView *originalView = [[UIView alloc]init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    //2.头像
    WBIconView *iconView = [[WBIconView alloc]init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    //3.会员图标
    UIImageView *vipView = [[UIImageView alloc]init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    //4.配图
    WBStatusPhotosView *photoView = [[WBStatusPhotosView alloc]init];
    [originalView addSubview:photoView];
    self.photosView = photoView;
    
    //5.昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = kStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //6.时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = kStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //7.来源
    UILabel *sourceLabel = [[UILabel alloc]init];
    sourceLabel.font = kStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    //8.正文
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = kStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;

}

/**
 *  为Cell绑定数据模型
 *
 *  @param statusFrame Cell的数据模型（元数据、Frame模型）
 */
- (void)setStatusFrame:(WBStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    //微博元数据
    WBStatus *status = statusFrame.status;
    WBUser *user = status.user;
    
    //原创微博整体
    self.originalView.frame = statusFrame.originalViewF;
    
    //头像
    self.iconView.frame = statusFrame.iconViewF;
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.iconView.user = user;
    
    //会员图标
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    
    //配图
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        self.photosView.photos = status.pic_urls;
        self.photosView.hidden = NO;
    }else{
        self.photosView.hidden = YES;
    }
    
    //昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    //时间会经常刷新，导致长度变化，因此需要重新计算Frame
    //时间
    NSString *time = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF)+kStatusCellBorderW;
    CGSize timeSize = [time sizeWithFont:kStatusCellTimeFont];
    self.timeLabel.frame = CGRectMake(timeX, timeY, timeSize.width,timeSize.height);
    self.timeLabel.text = status.created_at;

    //来源
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame)+kStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:kStatusCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX,sourceY},sourceSize};
    self.sourceLabel.text = status.source;
    
    //正文
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    //被转发微博
    if (status.retweeted_status) {
        //数据模型
        WBStatus *retweeted_status = status.retweeted_status;
        WBUser *retweeted_user = retweeted_status.user;
        
        self.retweetView.hidden = NO;
        
        //被转发微博的container
        self.retweetView.frame = statusFrame.retweetViewF;
        
        //被转发微博的正文
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@",retweeted_user.name,retweeted_status.text];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        //被转发微博的配图
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        }else{
            self.retweetPhotosView.hidden = YES;
        }
        
    }else{
        self.retweetView.hidden = YES;
    }
    
    //操作条
    self.operationBar.frame = statusFrame.operationBarF;
    self.operationBar.status = status;
    
}

@end
