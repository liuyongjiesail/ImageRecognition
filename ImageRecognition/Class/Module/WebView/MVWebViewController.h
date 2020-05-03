//
//  MVWebViewController.h
//  MetaAppVideo
//
//  Created by 刘永杰 on 2019/11/9.
//  Copyright © 2019 MetaApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MVWebViewController : UIViewController<WKScriptMessageHandler, UIGestureRecognizerDelegate>

@property (strong, readonly, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL     *webURL;

@property (assign, nonatomic) BOOL showProgress;
@property (assign, nonatomic) BOOL showAds;
@property (assign, nonatomic) NSInteger delayTime;

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

+ (void)showWebURL:(NSString *)webURL;

+ (id)initWebURL:(NSString *)webURL;

@end

NS_ASSUME_NONNULL_END
