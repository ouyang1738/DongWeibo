//
//  EmotionListView.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/7/13.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionPageView.h"

@interface EmotionListView()<UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIPageControl *pageCtl;
@end
@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //1.UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        //设置分页
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        //设置隐藏水平、竖直滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //2.pageControl
        UIPageControl *pageCtl = [[UIPageControl alloc]init];
        //当只有一页时自动隐藏PageControl
        pageCtl.hidesForSinglePage = YES;
//        pageCtl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
//        pageCtl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        //以上注释代码会导致图片“变形”
        [pageCtl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
        [pageCtl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [self addSubview:pageCtl];
        self.pageCtl = pageCtl;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    //删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + EmotionPageSize - 1)/EmotionPageSize;

    //1.设置页数
    self.pageCtl.numberOfPages = count;
    //2.创建用来显示每一页表情的控件
    for (NSUInteger i=0; i<self.pageCtl.numberOfPages; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc]init];
        //计算这一页的表情范围
        NSRange range;
        range.location = i * EmotionPageSize;
        NSUInteger left = emotions.count - range.location;
        if (left >= EmotionPageSize) {
            range.length = EmotionPageSize;
        }else{
            range.length = left;
        }
        //设置这一页的表情
        pageView.currentPageEmotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //1.pageControl
    self.pageCtl.width = self.width;
    self.pageCtl.height = 35;
    self.pageCtl.x = 0;
    self.pageCtl.y = self.height - self.pageCtl.height;
    
    //2.UIScrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageCtl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    //3.设置ScrollView内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (NSUInteger i=0; i<count; i++) {
        EmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    
    //4.设置ScrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.width, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置pageControl的页码
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageCtl.currentPage = (int)(pageNo+0.5);
}


@end
