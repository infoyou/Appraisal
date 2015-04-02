
#import "RootViewController.h"

@interface RootViewController ()

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

@end
