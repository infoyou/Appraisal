
#import "ResultViewController.h"

@interface ResultViewController () <UINavigationControllerDelegate>

@end

@implementation ResultViewController
{
}

#pragma mark - UIViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initData];
    
    [self performSelector:@selector(adjustFlowView) withObject:nil afterDelay:1];

    [self loadWebView];
}

- (void)loadWebView
{
    self.uiWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.uiWebView.backgroundColor = [UIColor blackColor];
    [self.uiWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://news.baidu.com"]]];
}

- (void)adjustFlowView
{
    self.photoBgView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.photoBgView.hidden = NO;
}

- (void)adjustView
{
    
    if (SCREEN_HEIGHT < 568) {
        
//        self.uiWebView.frame = CGRectOffset(self.uiWebView.frame, 0, - 88);
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark -
#pragma mark handle action
- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    
    UIView *view = (UIView *)[gestureRecognizer view];
    
//    if ([view isEqual:self.doneBtn]) {
//        
//        UIWebViewController *webVC = [[UIWebViewController alloc] init];
//        UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webVC];
//        webNav.title = @"鉴定评估";
//    }
}

- (IBAction)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doHomeAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
