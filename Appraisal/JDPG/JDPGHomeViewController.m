
#import "JDPGHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIViewController+RECurtainViewController.h"

@interface JDPGHomeViewController () <UINavigationControllerDelegate>

@end

@implementation JDPGHomeViewController
{
    CALayer                 *ballLayer;//摇动的layer
    float                   angle;
    float                   timeInter;
    NSInteger               index;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayer];
    
    [self performSelector:@selector(go) withObject:nil afterDelay:0.1];
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

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
        
    UIView *view = (UIView*)[gestureRecognizer view];
    
    if ([view isEqual:self.tapPhotoView]) {
        DLog(@"tap tap Photo View");
        
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
//        [self.navigationController pushViewController:photoViewController animated:YES];
        
        self.photoImg.image = [UIImage imageNamed:@"homeCenter_sel.png"];
        
        [self presentViewController:photoViewController animated:YES completion:^{}];
        
//        [self curtainRevealViewController:photoViewController transitionStyle:RECurtainTransitionHorizontal];
        
    } else if ([view isEqual:self.tapScanningView]) {
        
        BarCodeViewController *barCodeVC = [[BarCodeViewController alloc] init];
        
        [self.navigationController pushViewController:barCodeVC animated:YES];
//        [self presentViewController:barCodeVC animated:YES completion:^{}];
    }
}

#pragma mark -
#pragma mark 动画
- (void)go
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
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ballLayer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
    // Scan image
    self.scanningImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"scan%d.png", index++]];
    
    if (index > 4) {
        index = 1;
    }
    
    // Back image
    self.bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d.png", index%3]];
    
    //动画完毕操作
    if (angle == 0) {
        [theTimer invalidate];
        
        angle = 0; // 30;
        timeInter = 0.03; //0.05;
        
        ballLayer.hidden = YES;
        self.tapPhotoView.hidden = NO;
        
        // image
        self.scanningImg.image = [UIImage imageNamed:@"scan1.png"];
        self.bgImg.image = [UIImage imageNamed:@"bg0.png"];
    }
}

@end
