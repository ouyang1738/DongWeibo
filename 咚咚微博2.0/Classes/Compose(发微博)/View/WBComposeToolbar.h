//
//  WBComposeToolbar.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/12.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    WBComposeToolbarTypeCarema,     //拍照
    WBComposeToolbarTypePicture,    //相册
    WBComposeToolbarTypeMention,    //@
    WBComposeToolbarTypeTrend,      //#
    WBComposeToolbarTypeEmotion     //表情
    
}WBComposeToolbarType;

@class WBComposeToolbar;
#pragma mark - 代理协议
@protocol WBComposeToolbarDelegate<NSObject>
@optional
-(void)composeToolbar:(WBComposeToolbar *)toolbar didClickButton:(WBComposeToolbarType)type;

@end

@interface WBComposeToolbar : UIView

@property(nonatomic,weak)id<WBComposeToolbarDelegate> delegate;

/**
 *  是否显示键盘按钮
 */
@property(nonatomic,assign)BOOL showKeyboardButton;

@end
