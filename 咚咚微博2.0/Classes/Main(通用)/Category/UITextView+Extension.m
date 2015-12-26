//
//  UITextView+Extension.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/12/20.
//  Copyright © 2015年 J.Beyond. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributeText:(NSAttributedString *)attr settingBlock:(void (^)(NSMutableAttributedString *))settingBlock
{
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc]init];
    //拼接之前的文字
    [attrText appendAttributedString:self.attributedText];
    //拼接图片
    NSUInteger loc = self.selectedRange.location;
    [attrText replaceCharactersInRange:self.selectedRange withAttributedString:attr];
    
    if (settingBlock) {
        settingBlock(attrText);
    }
    
    self.attributedText=attrText;
    
    //移动光标到表情后面
    self.selectedRange = NSMakeRange(loc + 1, 0);

}
@end
