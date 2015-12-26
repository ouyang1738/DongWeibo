//
//  WBIconView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/11.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBIconView.h"
#import "UIImageView+WebCache.h"

@interface WBIconView()
@property(nonatomic,weak)UIImageView *verifiedView;
@end

@implementation WBIconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc]init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (void)setUser:(WBUser *)user
{
    _user = user;
    
    //1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    //2.设置加v图标
    switch (user.verified_type) {
//        case kUserVerifiedTypeNone://没有任何认证
//            self.verifiedView.hidden = YES;
//            break;
        case kUserVerifiedTypeOrgEnterprice:
        case kUserVerifiedTypeOrgMedia:
        case kUserVerifiedTypeOrgWebsite://官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case kUserVerifiedTypePersonal://个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];

            break;
        case kUserVerifiedTypeDaren://微博达人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];

            break;
        default:
            self.verifiedView.hidden = YES;//没有任何认证
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.verifiedView.size = self.verifiedView.image.size;
    self.verifiedView.centerX = self.width;
    self.verifiedView.centerY = self.height;
}

@end
