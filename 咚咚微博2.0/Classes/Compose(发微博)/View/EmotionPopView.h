//
//  EmotionPopView.h
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/13.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emotion.h"
#import "EmotionButton.h"
@interface EmotionPopView : UIView
+(instancetype)popView;
-(void)showFrom:(EmotionButton *)btn;
@end
