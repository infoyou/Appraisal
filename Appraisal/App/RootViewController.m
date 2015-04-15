
#import "RootViewController.h"

@interface RootViewController () <CLLocationManagerDelegate>

@end

@implementation RootViewController
@synthesize myData;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self adjustView];
    
    [self loadLocation];
}

- (void)loadLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - adjust view
- (void)adjustView
{
    
}

#pragma mark -
#pragma mark - URLConnectionDataDelegate 异步加载数据需要下面几个方法常用的有四个方法
//接受服务器响应－－接收到服务器回应的时候会执行该方法
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"服务器响应");
    
    self.myData = [NSMutableData dataWithCapacity:5000];
}

//接收服务器数据－－接收服务器传输数据的时候会调用，会根据数据量的大小，多次执行
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"服务器返回数据");
    
    //将返回数据放入缓存区
    [self.myData appendData:data];
}

//显示数据，直到所有的数据接收完毕
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"数据接受完毕");
    
    NSString *result = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSLog(@"result=%@", result);
}

//接受失败的时候调用的方法（断网或者是连接超时）
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"数据接受失败，失败原因：%@", [error localizedDescription]);
    
    [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                message:@""
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark
#pragma mark - is Connection Available
- (BOOL) isConnectionAvailable
{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {

        [[[UIAlertView alloc] initWithTitle:@"当前网络不可用,\n请检查网络连接!"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    return isExistenceNetwork;
}

#pragma mark - image for gesture
- (void)addTapGestureRecognizer:(UIView *)targetView
{
    targetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *swipeGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(imageviewTouchEvents:)];
    swipeGR.delegate = self;
    
    [targetView addGestureRecognizer:swipeGR];
}

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = (UIView*)[gestureRecognizer view];
    int viewTag = view.tag;
    
    DLog(@"%d is touched",viewTag);
}

#pragma mark - show Alert
- (void)showAlert:(NSString*)infoStr
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:infoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 定时 Alert
- (void)showTimeAlert:(NSString*)title message:(NSString*)message
{
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

#pragma mark - Share Methods

- (void)initAllSharePlat
{
    
    NSString *title = [NSString stringWithFormat:@"我正在用东方典当,小伙伴们快去试试吧~~~"];
    NSString *shareUrl = [NSString stringWithFormat:@"https://www.5adian.com/ios/ipad/dfdd/jdpg/"];
    
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
                                         image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"icon.png"]]
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
        [self showAlert:@"您还没有安装QQ,\n请先安装后进行分享"];
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
        [self showAlert:@"您还没有安装微信,\n请先安装后进行分享"];
        // [self showAlertWithTitle:@"未安装微信客户端,\n是否去App Store下载?" withTag:VideoWeiXinAlertType];
        return NO;
    }
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
        
        case SYSTEM_SETTING_TYPE:
        {
            // Send the user to the Settings for this app
            if (buttonIndex == 1) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
            break;
        
        case VideoQQAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/cn/kOsHA.i"]];
            }
        }
            break;
            
        case VideoSinaAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/cn/fh06u.i"]];
            }
        }
            break;
            
        case VideoWeiXinAlertType:
        {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/cn/S8gTy.i"]];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Locations %@", [locations lastObject]);
    
    self.currentLocation = [locations lastObject];
    
    [AppManager instance].latitude = [NSString stringWithFormat:@"%g", self.currentLocation.coordinate.latitude];
    [AppManager instance].longitude = [NSString stringWithFormat:@"%g", self.currentLocation.coordinate.longitude];
    
    /*
    NSLog(@"latitude %@",
          [NSString stringWithFormat:@"%g", self.currentLocation.coordinate.latitude]);
    NSLog(@"longitude %@",
          [NSString stringWithFormat:@"%g\u00B0", self.currentLocation.coordinate.longitude]);
    NSLog(@"horizontalAccuracy %@",
          [NSString stringWithFormat:@"%gm", self.currentLocation.horizontalAccuracy]);
    NSLog(@"verticalAccuracy %@",
          [NSString stringWithFormat:@"%gm", self.currentLocation.verticalAccuracy]);
    NSLog(@"altitude %@",
          [NSString stringWithFormat:@"%gm", self.currentLocation.altitude]);
     */
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

@end
