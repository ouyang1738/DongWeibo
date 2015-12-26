//
//  EmotionTextView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/19.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "EmotionAttachment.h"
@implementation EmotionTextView

- (void)insertEmotion:(Emotion *)emotion
{
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    }else if (emotion.png){

        //加载图片
        EmotionAttachment *attch = [[EmotionAttachment alloc]init];
        attch.emotion = emotion;
        
        //设置图片的尺寸
        CGFloat attachWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attachWH, attachWH);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        [self insertAttributeText:imageStr settingBlock:^(NSMutableAttributedString *attributeText) {
            //设置字体
            [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];
        }];
        
        /**
         selectedRange:
         1.本来是用来控制textView的文字选中范围
         2.如果selectedRange.length为0，selectRange.location就是textView的光标位置
         关于TextView文字字体
         1.如果是普通文字（text），文字的大小由TextView.font控制
         2.如果是属性文字（AttributeText）,文字大小不受TextView.font控制，应该利用
         [attrText addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, attrText.length)];设置字体
         **/
    }
}

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    //遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        //如果是图片表情
        EmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {
            [fullText appendString: attach.emotion.chs];
        }else{//emoji、普通文本
            //获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    NSLog(@"===>%@",fullText);
    return fullText;
}

@end
