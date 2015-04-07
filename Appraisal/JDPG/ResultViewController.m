
#import "ResultViewController.h"
#import "HYActivityView.h"

@interface ResultViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) HYActivityView *activityView;

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
    
    /*
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    */
    
    // Share
    [self initAllSharePlat];
}

#pragma mark - Share Methods

- (void)initAllSharePlat
{
    
    NSString *title = [NSString stringWithFormat:@"我正在用东方典当,小伙伴们快去试试吧~~~"];
    NSString *shareUrl = [NSString stringWithFormat:@"http://m.kanketv.com/WeiXin/choujiang/kanke.html"];
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享至" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 4;
        
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
        NSBundle *resourceBundle = nil;
        if ([resourcePath length] > 0) {
            resourceBundle = [[NSBundle alloc]initWithPath:resourcePath];
        }
        
        
        NSString *sinaIconPath = [resourceBundle  pathForResource:@"Icon_7/sns_icon_1" ofType:@"png"];
        UIImage *sinaIcon = [UIImage imageWithContentsOfFile:sinaIconPath];
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:sinaIcon handler:^(ButtonView *buttonView){
            [AppManager instance].isUserComment = YES;
            [self sendVideoMessageInSinaWithTitle:title withImage:@"" withVideoUrl:shareUrl withContent:@""];
        }];
        [self.activityView addButtonView:bv];
        
        NSString *QQIconPath = [resourceBundle  pathForResource:@"Icon_7/sns_icon_6" ofType:@"png"];
        UIImage *QQIcon = [UIImage imageWithContentsOfFile:QQIconPath];
        bv = [[ButtonView alloc]initWithText:@"QQ空间" image:QQIcon handler:^(ButtonView *buttonView){
            if (![self checkHasInstallQQ]) {
                return ;
            }
            
            [self sendShareVideoWithType:ShareTypeQQSpace withTitle:title withContent:@"" withImage:@"" withVideoUrl:shareUrl];
        }];
        [self.activityView addButtonView:bv];
        
        NSString *wxIconPath = [resourceBundle  pathForResource:@"Icon_7/sns_icon_22" ofType:@"png"];
        UIImage *wxIcon = [UIImage imageWithContentsOfFile:wxIconPath];
        bv = [[ButtonView alloc]initWithText:@"微信" image:wxIcon handler:^(ButtonView *buttonView){
            if (![self checkHasInstallWeiXin]) {
                return ;
            }
            
            [self sendShareVideoWithType:ShareTypeWeixiSession withTitle:title withContent:@"" withImage:@"" withVideoUrl:shareUrl];
        }];
        [self.activityView addButtonView:bv];
        
        NSString *wxFriIconPath = [resourceBundle  pathForResource:@"Icon_7/sns_icon_23" ofType:@"png"];
        UIImage *wxFriIcon = [UIImage imageWithContentsOfFile:wxFriIconPath];
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:wxFriIcon handler:^(ButtonView *buttonView){
            if (![self checkHasInstallWeiXin]) {
                return ;
            }
            
            [self sendShareVideoWithType:ShareTypeWeixiTimeline withTitle:title withContent:@"" withImage:@"" withVideoUrl:shareUrl];
        }];
        [self.activityView addButtonView:bv];
        
    }
    
    [self.activityView show];
}


/*!
 @method
 @abstract	分享视频信息
 @param     type         分享平台类型
 @param     title        分享视频名称
 @param     videoContent 分享视频简介
 @param     imageUrl     分享视频的图片
 @param     playUrl      分享视频的播放地址
 @discussion
 @return
 */
- (void)sendShareVideoWithType:(ShareType)type
                     withTitle:(NSString *)title
                   withContent:(NSString *)videoContent
                     withImage:(NSString *)imageUrl
                  withVideoUrl:(NSString *)playUrl
{
    
    id<ISSContent> content = [ShareSDK content:videoContent
                                defaultContent:@"分享了一个活动"
                                         image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"Parsonal_activityShare.jpg"] quality:1.0]
                                         title:title
                                           url:playUrl
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:((AppDelegate *)APP_DELEGATE).agViewDelegate];
    
    
    
    [ShareSDK shareContent:content
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            [self showAlert:@"分享成功"];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            [self showAlert:@"分享失败"];
                        }
                    }];
    
}


/*!
 @method
 @abstract	分享视频信息到新浪微博
 @param     title        分享视频名称
 @param     videoContent 分享视频简介
 @param     imageUrl     分享视频的图片
 @param     playUrl      分享视频的播放地址
 @discussion
 @return
 */
/***新浪微博分享只能分享content和image，若要分享视频，需要把视频链接写在Content里面***/
- (void)sendVideoMessageInSinaWithTitle:(NSString *)title
                              withImage:(NSString *)imageUrl
                           withVideoUrl:(NSString *)playUrl
                            withContent:(NSString *)videoContent
{
    
    NSString *sinaContent = [NSString stringWithFormat:@"%@ \r\n%@",title,playUrl];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:sinaContent
                                       defaultContent:@"分享了一个活动"
                                                image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"Parsonal_activityShare.jpg"] quality:1.0]
                                                title:title
                                                  url:nil
                                          description:videoContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK clientShareContent:publishContent
                            type:ShareTypeSinaWeibo
                   statusBarTips:NO
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  [AppManager instance].isUserComment = NO;
                                  [[UIApplication sharedApplication] setStatusBarHidden:NO];
                                  [self showAlert:@"分享成功!"];
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  [AppManager instance].isUserComment = NO;
                                  [[UIApplication sharedApplication] setStatusBarHidden:NO];
                                  [self showAlert:@"分享失败!"];
                              }
                              
                              
                          }];
}


//检查是否安装QQ
- (BOOL)checkHasInstallQQ
{
    if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
        return YES;
    }
    else
    {
        [self showAlertWithMessage:@"您还没有安装QQ,\n请先安装后进行分享"];
        //[self showAlertWithTitle:@"未安装QQ客户端,\n是否去App Store下载?" withTag:VideoQQAlertType];
        return NO;
    }
}


//检查是否安装微信
- (BOOL)checkHasInstallWeiXin
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        return YES;
    }
    else
    {
        [self showAlertWithMessage:@"您还没有安装微信,\n请先安装后进行分享"];
        // [self showAlertWithTitle:@"未安装微信客户端,\n是否去App Store下载?" withTag:VideoWeiXinAlertType];
        return NO;
    }
}


- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)showAlertWithTitle:(NSString *)title withTag:(NSUInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在下载", nil];
    [alertView setTag:tag];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case VideoQQAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/kOsHA.i"]];
            }
        }
            break;
        case VideoSinaAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/fh06u.i"]];
            }
        }
            break;
        case VideoWeiXinAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/S8gTy.i"]];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
