
#import "BarCodeResultViewController.h"

@implementation BarCodeResultViewController
{
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫描页面";
    
    NSURL *url = [NSURL URLWithString:[AppManager instance].webUrl];
    [self.mWebView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIWebViewController

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

}

- (IBAction)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doHomeAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
