
#import "UIWebViewController.h"
#import "AppManager.h"

@implementation UIWebViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.webView.frame = (CGRect){/*CGPointMake(0, 65)*/ CGPointZero, self.view.frame.size};
    [self.view addSubview:self.webView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIWebViewController

- (UIWebView *)webView
{
    if (!_webView) {
        self.webView = [UIWebView new];
        self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.webView.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:[AppManager instance].webUrl];
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
        self.webView.delegate = self;
    }
    
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIActivityIndicatorView *actView;
    for ( id object in webView.subviews ) {
        if ([object isMemberOfClass:[UIActivityIndicatorView class]]) {
            actView = (UIActivityIndicatorView*)object;
        }
    }
    NSLog(@"Web view did start loading");
    [actView startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    UIActivityIndicatorView *actView;
    for ( id object in webView.subviews ) {
        if ([object isMemberOfClass:[UIActivityIndicatorView class]]) {
            actView = (UIActivityIndicatorView*)object;
        }
    }
    NSLog(@"Web view did finish loading");
    [actView stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    UIActivityIndicatorView *actView;
//    for ( id object in webView.subviews ) {
//        if ([object isMemberOfClass:[UIActivityIndicatorView class]]) {
//            actView = (UIActivityIndicatorView*)object;
//        }
//    }
//    [actView stopAnimating];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSString* errorString = [NSString stringWithFormat:@"<html>%@</html>", error.localizedDescription];
//    [myWebView loadHTMLString:errorString baseURL:nil];
}

@end
