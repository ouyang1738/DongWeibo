//
//  WBUser.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>
typedef enum{
    kUserVerifiedTypeNone = -1,         //没有任何认证
    kUserVerifiedTypePersonal = 0,      //个人认证
    kUserVerifiedTypeOrgEnterprice = 2, //企业官方认证
    kUserVerifiedTypeOrgMedia = 3,      //媒体官方认证
    kUserVerifiedTypeOrgWebsite = 5,    //网站认证
    kUserVerifiedTypeDaren = 220        //微博达人认证
    
} kUserVerifiedType;
@interface WBUser : NSObject
/** 字符串id */
@property(nonatomic,copy)NSString *idstr;
/** 用户昵称 */
@property(nonatomic,copy)NSString *name;
/** 用户头像 50*50 */
@property(nonatomic,copy)NSString *profile_image_url;
/** 会员类型 >2 代表是会员 */
@property(nonatomic,assign)int mbtype;
/** 会员等级 */
@property(nonatomic,assign)int mbrank;
/** 是否是vip*/
@property(nonatomic,assign,getter= isVip ) BOOL vip;
/** 认证类型 */
@property(nonatomic,assign)kUserVerifiedType verified_type;

@end
