//
//  WBOperationBar.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/10.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBStatus.h"

@interface WBOperationBar : UIView

@property(nonatomic,strong)WBStatus *status;

+(instancetype)operationBar;
@end
