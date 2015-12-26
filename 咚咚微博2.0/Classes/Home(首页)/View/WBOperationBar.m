//
//  WBOperationBar.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/10.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBOperationBar.h"
@interface WBOperationBar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property(nonatomic,weak)UIButton *repostBtn;
@property(nonatomic,weak)UIButton *commentsBtn;
@property(nonatomic,weak)UIButton *attritudeBtn;


@end

@implementation WBOperationBar

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

+(instancetype)operationBar
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //添加按钮
        self.repostBtn = [self setupOperationItem:@"转发" icon:@"timeline_icon_retweet"];
        self.commentsBtn = [self setupOperationItem:@"评论" icon:@"timeline_icon_comment"];
        self.attritudeBtn = [self setupOperationItem:@"赞" icon:@"timeline_icon_unlike"];
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}
/**
 * 添加分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}



-(UIButton *)setupOperationItem:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.btns.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i*btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    // 设置分割线的frame
    NSInteger dividerCount = self.dividers.count;
    for (NSInteger i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

- (void)setStatus:(WBStatus *)status
{
    _status = status;
    
    //转发
    [self setupItems:self.repostBtn count:status.reposts_count title:@"转发"];
    //评论
    [self setupItems:self.commentsBtn count:status.comments_count title:@"评论"];
    //赞
    [self setupItems:self.attritudeBtn count:status.attritutes_count title:@"赞"];
    
}

-(void)setupItems:(UIButton *)btn count:(int)count title:(NSString *)title;
{
    /**
     1、数字不足10000，直接显示
     2、数字达到10000，显示xx.x万，不要有.0的情况
     */
    if (count) {//有数字
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count];
        }else{
            double wan = count/10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            //将字符串里面的0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
