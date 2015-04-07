
#import "AppDelegate.h"
#import "MSDynamicsDrawerViewController.h"

#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "MobClick.h"
#import "GlobalConstants.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIImageView *windowBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.dynamicsDrawerViewController = [[MSDynamicsDrawerViewController alloc] init];
    
    // Add some example stylers
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];
    
    // Left
    LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] init];
    leftMenuVC.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:leftMenuVC forDirection:MSDynamicsDrawerDirectionLeft];
    
    // Right
    RightMenuViewController *rightMenuVC = [[RightMenuViewController alloc] init];
    rightMenuVC.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:rightMenuVC forDirection:MSDynamicsDrawerDirectionRight];
    
    // Transition to the first view controller
    [leftMenuVC transitionToViewController:JDPGVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.dynamicsDrawerViewController;
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.windowBackground];
    [self.window sendSubviewToBack:self.windowBackground];
    
    [self regist3rd];
    
    //开始
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(SCREEN_HEIGHT < 568) {
        splashView.image = [UIImage imageNamed:@"Default.png"];
    } else {
        splashView.image = [UIImage imageNamed:@"Default-568h.png"];
    }
    
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];  //放到最顶层;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    //结束;
    
    [self performSelector:@selector(loadLogicView) withObject:nil afterDelay:2.5];
    
    return YES;
}

- (void)loadLogicView
{
    self.window.rootViewController = self.dynamicsDrawerViewController;
    
    if (true) {
        return;
    }
    
//    UIWebViewController *webVC = [[UIWebViewController alloc] init];
    UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:self.dynamicsDrawerViewController];
    [webNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBg.png"] forBarMetrics:UIBarMetricsDefault];
    [webNav.navigationBar setBarStyle:UIBarStyleBlack];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{UITextAttributeTextColor:[UIColor blackColor],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
       UITextAttributeTextShadowColor:[UIColor whiteColor],
       UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:17.0]
       }
                                                                                            forState:UIControlStateNormal];
    
    self.window.rootViewController = webNav;
}

- (void)regist3rd
{
    // Umeng
    [MobClick startWithAppkey:UMENG_ANALYS_APP_KEY reportPolicy:SEND_INTERVAL channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    
    // Share
    [ShareSDK registerApp:kShareSDK_Key];
    
    [self initializeSharePlat];
}

/*
 *注册第三方分享的平台
 */
- (void)initializeSharePlat
{
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:kSinaAppKey
                               appSecret:kSinaAppSecret
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:kQQAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:kSinaAppKey
                                appSecret:kSinaAppSecret
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kQQAppKey
                           appSecret:kQQAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:kWeiXinKey
                           wechatCls:[WXApi class]];
}

#pragma mark - AppDelegate

- (UIImageView *)windowBackground
{
    if (!_windowBackground) {
        _windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Window Background"]];
    }
    return _windowBackground;
}

@end
