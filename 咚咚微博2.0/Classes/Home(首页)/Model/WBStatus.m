//
//  WBStatus.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/4.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "WBStatus.h"
#import "MJExtension.h"
#import "WBPhoto.h"
#import "NSDate+Extension.h"
#import "DateTransferTool.h"
#import "RegexKitLite.h"
#import "WBTextPart.h"
#import "EmotionTool.h"
#import "WBSpecial.h"
@implementation WBStatus

/**
 *  指定数组pic_urls中的元素为WBPhoto
 */
+(NSDictionary *)objectClassInArray
{
   return @{@"pic_urls":[WBPhoto class]};
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    //利用text生成attributedText
    self.attrText = [self attributedTextWithText:text];
}

- (NSString *)created_at
{
    return [DateTransferTool transfer:_created_at];
}

//source = <a href="http://app.weibo.com/t/feed/1sxHP2" rel="nofollow">专业版微博</a>
- (void)setSource:(NSString *)source
{
    _source = source;
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
    _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
}

- (void)setRetweeted_status:(WBStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    NSString *retweetContent = [NSString stringWithFormat:@"%@ :%@",retweeted_status.user.name,retweeted_status.text];
    self.reweetAttrText = [self attributedTextWithText:retweetContent];
}

-(NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    //url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    //遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) {
            return ;
        }
        WBTextPart *part = [[WBTextPart alloc]init];
        part.text = *capturedStrings;
        part.range= *capturedRanges;
        part.emtion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.special = YES;
        [parts addObject:part];
    }];
    //遍历所有非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) {
            return ;
        }
        WBTextPart *part = [[WBTextPart alloc]init];
        part.text = *capturedStrings;
        part.range= *capturedRanges;
        [parts addObject:part];
    }];
    //排序
    [parts sortUsingComparator:^NSComparisonResult(WBTextPart *part1, WBTextPart *part2) {
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    NSMutableArray *specials = [NSMutableArray array];
    UIFont *font = [UIFont systemFontOfSize:15];
    //按顺序拼接每一段文字
    for (WBTextPart *part in parts) {
        NSAttributedString *subStr = nil;
        if (part.isEmotion) {//表情
            NSTextAttachment *attch = [[NSTextAttachment alloc]init];
            NSString *name = [EmotionTool emtionWithChs:part.text].png;
            if (name) {
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                subStr = [NSAttributedString attributedStringWithAttachment:attch];
            }else{
                subStr = [[NSAttributedString alloc] initWithString:part.text];
            }
        }else if (part.isSpecial){//非表情的特殊字符
            subStr = [[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
            //创建特殊对象
            WBSpecial *s = [[WBSpecial alloc]init];
            s.text = part.text;
            s.range = NSMakeRange(attributedText.length, part.text.length);
            [specials addObject:s];
        }else{//非特殊字符（普通文本）
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:subStr];
    }
    
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    //一定要设置字体保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    return attributedText;
    
}



@end
