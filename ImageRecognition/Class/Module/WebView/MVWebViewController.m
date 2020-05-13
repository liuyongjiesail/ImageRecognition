//
//  MVWebViewController.m
//  MetaAppVideo
//
//  Created by 刘永杰 on 2019/11/9.
//  Copyright © 2019 MetaApp. All rights reserved.
//

#import "MVWebViewController.h"
#import "MXNavigationController.h"
#import "AppDelegate.h"

@interface MVWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) XRGADBannerApi *bannerApi;

@property (strong, nonatomic) CALayer *progressLine;

@end

@implementation MVWebViewController

+ (void)showWebURL:(NSString *)webURL {
    
    MVWebViewController *webVC = [MVWebViewController new];
    webVC.webURL = [NSURL URLWithString:webURL];
    [[UIViewController currentViewController] showViewController:webVC sender:nil];
}

+ (id)initWebURL:(NSString *)webURL {
    MVWebViewController *webVC = [self.class new];
    webVC.webURL = [NSURL URLWithString:webURL];
    return webVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"加载中...";
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:MAXFLOAT]];
    [self registerWebObserver];
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(reportAction)];
    [self.navigationController.navigationBar setTintColor:UIColor.blackColor];
    
    [self performSelector:@selector(showRewardAd) withObject:nil afterDelay:self.delayTime];
    
    if (self.showAds) {
        [self.bannerApi loadBannerAdView:self];
    }
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"playNativeRewardVideoAd"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)showRewardAd {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.allowRotation) {
        return;
    }
    [XRGADRewardVideoApi.shared showCompletion:^{
        [self performSelector:@selector(showRewardAd) withObject:nil afterDelay:self.delayTime];
    }];
}

- (NSURL *)webURL {
    if (!_webURL) {
        _webURL = [NSURL URLWithString:@""];
    }
    return _webURL;
}

- (void)didClickBackButtonEvent {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self webViewClose];
    }
}

- (void)webViewClose {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - WKScriptMessageHandle

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    XRLog(@"%@",message.name);
    XRLog(@"%@",message.body);
    NSString *method = [NSString stringWithFormat:@"%@:",message.name];
    SEL selector = NSSelectorFromString(method);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    }
#pragma clang diagnostic pop
}

- (void)playNativeRewardVideoAd:(id)obj {
    
    [XRGADRewardVideoApi.shared showCompletion:^{
        [self.webView evaluateJavaScript:@"nativeRewardVideoAdPlayComplete()" completionHandler:^(id _Nullable reponse, NSError * _Nullable error) {
            XRLog(@"%@",error);
        }];
    }];
    
}

#pragma mark - WKNavigationDelegate

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    if ([URL.absoluteString containsString:@"itunes.apple.com"] || [URL.absoluteString containsString:@"action=download"]) {
        //iOS下载
        [[UIApplication sharedApplication] openURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        if (!([URL.absoluteString containsString:@"http://"] || [URL.absoluteString containsString:@"https://"]) && [[UIApplication sharedApplication] openURL:URL]){
            //跳转到其他应用
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView.scrollView.mj_header endRefreshing];
    if ([self.navigationItem.title isEqualToString:@"加载中..."]) {
        self.navigationItem.title = @"";
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.navigationItem.title = @"加载失败";
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![object isKindOfClass:[WKWebView class]]) {
        return;
    }
    if ([keyPath isEqualToString:@"title"]) {
        NSMutableString *string = [change[@"new"] mutableCopy];
        self.navigationItem.title = string.length > 12 ? [[string substringToIndex:11] stringByAppendingString:@"..."] : string;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLine.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progressLine.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 2);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLine.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLine.frame = CGRectMake(0, 0, 0, 2);
            });
        }
    }
    
}

#pragma mark - WebObserver

- (void)registerWebObserver {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}

#pragma mark - Lazy Loading

- (WKWebView *)webView {
    if (!_webView) {
        
        WKUserContentController *userContentController = [WKUserContentController new];
        /// 禁止手势缩放
        WKUserScript *script = [[WKUserScript alloc] initWithSource:@"$('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userContentController addUserScript:script];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.preferences = preferences;
        configuration.selectionGranularity = YES;
        configuration.allowsInlineMediaPlayback = YES;
        configuration.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = UIColor.whiteColor;
    }
    return _webView;
}

- (CALayer *)progressLine {
    if (!_progressLine) {
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
        progress.backgroundColor = [UIColor clearColor];
        [self.webView addSubview:progress];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 2);
        layer.backgroundColor = HEX(0xFF5000).CGColor;
        [progress.layer addSublayer:layer];
        _progressLine = layer;
        _progressLine.hidden = self.showProgress;
    }
    return _progressLine;
}

- (BOOL)showAds {
    return YES;
}

- (NSInteger)delayTime {
    return 45;
}

- (XRGADBannerApi *)bannerApi {
    if (!_bannerApi) {
        _bannerApi = XRGADBannerApi.new;
    }
    return _bannerApi;
}

@end
