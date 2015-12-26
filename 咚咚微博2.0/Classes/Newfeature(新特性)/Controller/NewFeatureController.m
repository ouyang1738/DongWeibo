//
//  NewFeatureController.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/28.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//
#define ImageCount 4

#import "NewFeatureController.h"
#import "MainTabBarController.h"
@interface NewFeatureController()<UIScrollViewDelegate>
@property(nonatomic,weak)UIPageControl *pageCtl;
@end
@implementation NewFeatureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建一个ScrollView，显示所有新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //2.添加图片到ScrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (NSInteger i =0; i<ImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.size = scrollView.size;
        imageView.y = 0;
        imageView.x = i * scrollW;
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%ld",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        //如果是最后一个imageView，添加其他控件
        if (i == ImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    //3.设置ScrollView的其他属性
    scrollView.contentSize = CGSizeMake(ImageCount * scrollW, 0);
    scrollView.bounces = NO;//去除弹簧效果
    scrollView.pagingEnabled = YES;//设置分页效果
    
    //4、添加PageControl:分页，当前显示的页数
    //UIPageControl就算没有设置尺寸，里面的内容还是能够正常显示
    UIPageControl *pageCtl = [[UIPageControl alloc]init];
    pageCtl.numberOfPages = ImageCount;
//    pageCtl.width = 100;
//    pageCtl.height = 50;
    pageCtl.centerX = scrollW * 0.5;
    pageCtl.centerY = scrollH - 50;
    pageCtl.currentPageIndicatorTintColor = RGBColor(253, 98, 42);
    pageCtl.pageIndicatorTintColor = RGBColor(189, 189, 189);
    [self.view addSubview:pageCtl];
    self.pageCtl = pageCtl;
    
    //5.设置代理
    scrollView.delegate = self;
    
    
}
/**
 *  初始化最后一个imageview
 *
 */
-(void)setupLastImageView:(UIImageView *)imageView
{
    //开启交互
    imageView.userInteractionEnabled = YES;
    //1.分享给大家
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 130;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width*0.5;
    shareBtn.centerY = imageView.height*0.65;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    
    //2.开始微博
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateSelected];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;

    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}

/**
 *  分享按钮点击事件
 *
 */
-(void)shareClick:(UIButton *)shareBtn
{
    //状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

/**
 *  点击开启微博
 */
-(void)start
{
    /**
     切换控制器的手段
     1、push:依赖UINavigationController，控制器的切换是可逆的；A——>B,B——>A
     2、modal:控制器的切换是可逆的；A——>B,B——>A
     3、设置window的根控制器
     */
    MainTabBarController *main = [[MainTabBarController alloc]init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    //四舍五入计算出页码
    self.pageCtl.currentPage = (int)(page + 0.5);
    
}

@end
