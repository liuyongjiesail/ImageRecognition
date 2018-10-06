//
//  XRWebViewController.m
//  ImageRecognition
//
//  Created by 刘永杰 on 2018/10/2.
//  Copyright © 2018 刘永杰. All rights reserved.
//

#import "XRWebViewController.h"
#import <WebKit/WebKit.h>

@interface XRWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) CALayer   *progressLayer;
@property (assign, nonatomic) CGFloat   navigationBarHeight;

@end

@implementation XRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webView];
    [self.webView.layer addSublayer:self.progressLayer];
    NSURL *url;
    if ([self.urlString hasPrefix:@"http"]) {
        url = [NSURL URLWithString:self.urlString];
    } else {
        url = [NSURL fileURLWithPath:self.urlString];
    }
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, self.navigationBarHeight, self.view.bounds.size.width * [change[@"new"] floatValue], 2);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, self.navigationBarHeight, 0, 2);
            });
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            if(self.navigationController)
                self.navigationItem.title = self.webView.title;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Lazy Loading

- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        configuration.userContentController = userContentController;
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (CALayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CALayer layer];
        _progressLayer.frame = CGRectMake(0, self.navigationBarHeight, 0, 2);
        _progressLayer.backgroundColor = [UIColor colorWithString:COLOR39AF34].CGColor;
    }
    return _progressLayer;
}

- (CGFloat)navigationBarHeight {
    return self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

@end
