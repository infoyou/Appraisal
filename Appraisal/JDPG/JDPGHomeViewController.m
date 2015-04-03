
#import "JDPGHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import <QuartzCore/QuartzCore.h>

//#import "LYBgImageView.h"
//#import "LYMovePathView.h"
//#import "LYFireworksView.h"

#import "UIViewController+RECurtainViewController.h"

@interface JDPGHomeViewController () <UINavigationControllerDelegate>

@property (nonatomic, retain) NSTimer *bgSwitchTimer; // 背景

@end

@implementation JDPGHomeViewController
{
    // 摇动的layer
    CALayer                 *ballLayer;
    float                   angle;
    float                   timeInter;
    
    // 背景
    NSInteger               index;
    BOOL                    isChange;
}

@synthesize mScrollView;
@synthesize tapPhotoView;
@synthesize tapScanningView;

#pragma mark - UIViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置默认参数
    angle =30.0;
    timeInter = 0.05;
    
    index = 1;
    
//    [self doBGAnimation];
    
    self.photoImg.image = [UIImage imageNamed:@"homeCenter.png"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayer];
    [self performSelector:@selector(doLayoutAnimation) withObject:nil afterDelay:0.1];
    
//    [self addLiziAnimation];
    
}

/*
- (void)addLiziAnimation
{
    // 背景梦幻星空
    do {
        LYBgImageView *animationView = [[LYBgImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:animationView];
    } while (0);
    
    // 第一条移动星星闪烁动画
    do {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddCurveToPoint(path, NULL, 50.0, 100.0, 50.0, 120.0, 50.0, 275.0);
        CGPathAddCurveToPoint(path, NULL, 50.0, 275.0, 150.0, 275.0, 160.0, 460.0);
        
        LYMovePathView *animationView = [[LYMovePathView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) movePath:path];
        [self.view addSubview:animationView];
    } while (0);
    
    // 第二条移动星星闪烁动画
    do {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 0);
        CGPathAddCurveToPoint(path, NULL, SCREEN_WIDTH - 50.0, SCREEN_HEIGHT - 100.0, SCREEN_WIDTH - 50.0, SCREEN_WIDTH - 120.0, SCREEN_WIDTH - 50.0, SCREEN_WIDTH - 275.0);
        CGPathAddCurveToPoint(path, NULL, SCREEN_WIDTH - 50.0, SCREEN_HEIGHT - 275.0, SCREEN_WIDTH - 150.0, SCREEN_WIDTH - 275.0, 160.0, 160.0);
        
        LYMovePathView *animationView = [[LYMovePathView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) movePath:path];
        [self.view addSubview:animationView];
    } while (0);
    
    // 祝贺花筒，彩色炮竹
    do {
        LYFireworksView *animationView = [[LYFireworksView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:animationView];
    } while (0);
}
*/

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.bgSwitchTimer invalidate];
    self.bgSwitchTimer = nil;
}

- (void)adjustView
{
    
    if (SCREEN_HEIGHT < 568) {

        ((UIScrollView*)(self.mScrollView)).contentSize = CGSizeMake(SCREEN_WIDTH, 640);
        ((UIScrollView*)(self.mScrollView)).scrollEnabled = YES;
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
    
    
    // action
    [self addTapGestureRecognizer:self.tapPhotoView];
    [self addTapGestureRecognizer:self.tapScanningView];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)goPhotoVC
{
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
//    [self.navigationController pushViewController:photoViewController animated:YES];
    [self presentViewController:photoViewController animated:YES completion:^{}];
}

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    
    UIView *view = (UIView*)[gestureRecognizer view];
    
    if ([view isEqual:self.tapPhotoView]) {
        DLog(@"tap tap Photo View");
        
        self.photoImg.image = [UIImage imageNamed:@"homeCenter_sel.png"];
        [self performSelector:@selector(goPhotoVC) withObject:nil afterDelay:1];
        
//        [self curtainRevealViewController:photoViewController transitionStyle:RECurtainTransitionHorizontal];
        
    } else if ([view isEqual:self.tapScanningView]) {
        
        BarCodeViewController *barCodeVC = [[BarCodeViewController alloc] init];
        
        [self.navigationController pushViewController:barCodeVC animated:YES];
//        [self presentViewController:barCodeVC animated:YES completion:^{}];
    }
}

#pragma mark -
#pragma mark 动画
- (void)doLayoutAnimation
{
    self.tapPhotoView.hidden = YES;
    //左右摇摆时间是定义的时间的2倍
    [NSTimer scheduledTimerWithTimeInterval:timeInter*2
                                     target:self
                                   selector:@selector(ballAnmation:)
                                   userInfo:nil
                                    repeats:YES];
    
    index = 0;
}

- (void)doBGAnimation
{
    self.bgSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                       target:self
                                                     selector:@selector(bgAnmation)
                                                     userInfo:NULL
                                                      repeats:YES];
}

- (void)initLayer
{
    ballLayer=[CALayer layer];
    ballLayer.bounds = CGRectMake(0, 0, 221, 194);
    ballLayer.position = CGPointMake(159, 400);
    ballLayer.contents = (id)[UIImage imageNamed:@"homeCenter.png"].CGImage;
    ballLayer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view.layer addSublayer:ballLayer];
//    [self.tapPhotoView.layer setMasksToBounds:YES];
}

- (void)ballAnmation:(NSTimer *)theTimer
{
    //设置左右摇摆
    angle=-angle;
    if (angle > 0) {
        angle-=2;
    } else {
        angle+=2;
    }
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(angle))];
    rotationAnimation.duration = timeInter;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
//    rotationAnimation.fromValue = [NSNumber numberWithDouble:0];
//    rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI*2];
    
    [ballLayer addAnimation:rotationAnimation forKey:@"transform"/*forKey:@"revItUpAnimation"*/];
    
//    rotationAnimation.duration = 200;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    [ballLayer addAnimation:rotationAnimation forKey:@"transform"];
    
    //动画完毕操作
    if (angle == 0) {
        [theTimer invalidate];
        
        angle = 0; // 30;
        timeInter = 0.03; //0.05;
        
        ballLayer.hidden = YES;
        self.tapPhotoView.hidden = NO;
    }
}

- (void)bgAnmation
{
    // Scan image
    self.scanningImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"scan%d.png", index++]];
    
    if (index > 4) {
        index = 1;
    }
    
    isChange = !isChange;
    
    // Back image
//    if (isChange) {
//
//        self.bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d.png", index%3]];
//    }

    // 结束状态的image
//    self.scanningImg.image = [UIImage imageNamed:@"scan1.png"];
//    self.bgImg.image = [UIImage imageNamed:@"bg0.png"];
}

@end
