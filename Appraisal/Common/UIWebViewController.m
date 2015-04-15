
#import "UIWebViewController.h"
#import "AppManager.h"

@implementation UIWebViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.webView.frame = (CGRect){CGPointZero, self.view.frame.size};
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
        self.webView.backgroundColor = [UIColor blackColor];
        NSURL *url = [NSURL URLWithString:[AppManager instance].webUrl];
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    }
    
    return _webView;
}

@end
