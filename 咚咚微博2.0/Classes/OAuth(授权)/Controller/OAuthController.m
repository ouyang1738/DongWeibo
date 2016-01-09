//
//  OAuthController.m
//  咚咚微博2.0
//
//  Created by J.Beyond on 15/6/28.
//  Copyright (c) 2015年 J.Beyond. All rights reserved.
//

#import "OAuthController.h"
#import "AFNetworking.h"
#import "MainTabBarController.h"
#import "NewFeatureController.h"
#import "WBAccount.h"
#import "MBProgressHUD+MJ.h"
#import "WBAccountTool.h"
#import "UIWindow+Extension.h"
#import "HttpTool.h"


@interface OAuthController()<UIWebViewDelegate>

@end
@implementation OAuthController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建一个webView
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",AppKey,RedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在登录中..."];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}


/**
 *  拦截带code参数的请求，并获取code参数值
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //1.获得URL
    NSString *urlStr = request.URL.absoluteString;
    
    //2.判断是否为回调地址
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length != 0) {//是回调地址
        //截取code=后面的参数值
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:fromIndex];
        
        //code为授权成功的访问标记
        //用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        //禁止加载回调地址
        return NO;
    }
    return YES;
}

/**
 *  用code换取一个accessToken
 *
 */
-(void)accessTokenWithCode:(NSString *)code
{
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = AppKey;
    params[@"client_secret"] = AppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = RedirectURI;
    params[@"code"] = code;
    
    // 2.发送请求
    [HttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json) {
        Log(@"请求成功-%@", json);
        [MBProgressHUD hideHUD];
        
        //将返回的账号数据存进沙盒
        WBAccount *acc = [WBAccount accountWithDict:json];
        [WBAccountTool saveAccount:acc];
        
        //切换窗口的根控制器
        [UIWindow switchRootViewController];
    } failure:^(NSError *error) {
        Log(@"请求失败-%@", error);
        [MBProgressHUD hideHUD];

    }];
}

@end
