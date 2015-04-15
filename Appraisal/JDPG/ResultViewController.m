
#import "ResultViewController.h"
#import "ReportViewController.h"

@interface ResultViewController ()

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
    self.mWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    NSString *localFileName = @"assessment-baoshi";
    
    switch ([AppManager instance].babyType) {
        
        case JADE_TYPE:
        {
            localFileName = @"assessment-yushi";
        }
        break;
        
        case ARTWORK_TYPE:
        {
            localFileName = @"assessment-artwork";
        }
        break;
        
        case GEM_TYPE:
        {
            localFileName = @"assessment-baoshi";
        }
        break;
        
        case GOLD_TYPE:
        {
            localFileName = @"assessment-sujin";
        }
        break;
        
        case WATCH_TYPE:
        {
            localFileName = @"assessment-shoubiao";
        }
        break;
        
        case AUTO_TYPE:
        {
            localFileName = @"assessment-car";
        }
        break;
        
        case DIAMOND_TYPE:
        {
            localFileName = @"assessment-zuanshi";
        }
        break;
        
        case REAL_ESTATE_TYPE:
        {
            localFileName = @"assessment-house";
        }
        break;
        
        default:
            localFileName = @"assessment-baoshi";
        break;
    }

    // 黄色加载
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:localFileName ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObjc = [NSURLRequest requestWithURL:url];
    
    [self.mWebView loadRequest:requestObjc];
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
        
//        self.mWebView.frame = CGRectOffset(self.mWebView.frame, 0, - 88);
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
    
//    UIView *view = (UIView *)[gestureRecognizer view];
    
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

#pragma mark - UIWebViewDelegate method

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    //    [[aWebView windowScriptObject] evaluateWebScript:@"function fun(x) {return x;}"];
    
    //    [aWebView stringByEvaluatingJavaScriptFromString:@"alert('登录成功!')"];
    
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    // 防止拖动后产生白屏
    self.mWebView.backgroundColor = [UIColor blackColor];
    [(UIScrollView *)[[self.mWebView subviews] objectAtIndex:0] setBounces:NO];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    //处理JavaScript和Objective-C交互
    
    if([[[url scheme] lowercaseString] isEqualToString:@"submit"]) {
        // 得到html5的表单
        NSUInteger offset = [url host].length + 3;
//        if([[url host] isEqualToString:@"data"])
        {
            NSString *showString = [[url resourceSpecifier] substringFromIndex:offset];
            NSString *parmString = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 解析参数
            NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
            for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [dataDict setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            NSLog(@"params = %@", [dataDict description]);
            
            NSMutableDictionary *paramDict = [CommonUtils getParamDict:[url host]
                                                              dataDict:dataDict];
            
            [self showHUDWithText:@"正在加载"
                           inView:self.view
                      methodBlock:^(CompletionBlock completionBlock, ATMHud *hud)
             {
                 
                 [HttpRequestData dataWithDic:paramDict
                                  requestType:POST_METHOD
                                    serverUrl:HOST_URL
                                     andBlock:^(NSString*requestStr) {
                                         
                                         if (completionBlock) {
                                             completionBlock();
                                         }
                                         
                                         if ([requestStr isEqualToString:@"Start"]) {
                                             
                                             DLog(@"Start");
                                         } else if([requestStr isEqualToString:@"Failed"]) {
                                             
                                             DLog(@"Failed");
                                             
                                             [self showHUDWithText:@"联网失败" completion:^{
                                             }];
                                             
                                         } else {
                                             
                                             NSDictionary* backDic = [HttpRequestData jsonValue:requestStr];
                                             NSLog(@"requestStr = %@", backDic);
                                             
                                             if (backDic != nil) {
                                                 
                                                 NSString *errCodeStr = (NSString *)[backDic valueForKey:@"errcode"];
                                                 
                                                 if ( [errCodeStr integerValue] == 0 ) {

                                                     NSString *msgStr = [backDic valueForKey:@"result"];
                                                     NSDictionary *msgDict = [HttpRequestData jsonValue:msgStr];
                                                     NSLog(@"msgDict = %@", msgDict);
                                                     
                                                     if (![[msgDict objectForKey:@"marketPrice"] isEqualToString:@""]) {
                                                         [self goReport:msgDict];
                                                     } else {
                                                         [self showTimeAlert:@"提示" message:@"价格为空！"];
                                                     }
                                                 }
                                             }
                                         }
                                     }];
             }];

        }
        
        return NO;
    } else if([[[url scheme] lowercaseString] isEqualToString:@"showalert"]) {
        // 处理js的alert
        if([[url host] isEqualToString:@"data"])
        {
            
            NSString *showString = [[url resourceSpecifier] substringFromIndex:11];
            
            NSString *str = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[[UIAlertView alloc] initWithTitle:str
                                        message:@""
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
              ] show];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)goReport:(NSDictionary *)msgDict
{
    ReportViewController *reportVC = [[ReportViewController alloc] init];
    
//    [self.navigationController pushViewController:reportVC animated:YES];
    [self presentViewController:reportVC animated:YES completion:^{}];
    
    [reportVC updateData:msgDict];
}

@end
