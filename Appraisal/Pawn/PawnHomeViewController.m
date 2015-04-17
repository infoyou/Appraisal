
#import "PawnHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"

@interface PawnHomeViewController () 

@end

@implementation PawnHomeViewController
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
@synthesize photoImg;

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
    
    self.photoImg.image = [UIImage imageNamed:@"jrddHomeCenter.png"];
    
    self.tapPhotoView.hidden = YES;
    self.tapScanningView.hidden = YES;
    
    //设置默认参数
    [self performSelector:@selector(doPhotoAnmation) withObject:nil afterDelay:1];
    [self performSelector:@selector(doLayoutAnimation) withObject:nil afterDelay:1];
}

- (void)initLayer
{
    ballLayer=[CALayer layer];
    ballLayer.bounds = CGRectMake(0, 0, 200, 191);
    ballLayer.position = CGPointMake(159, 400);
    ballLayer.contents = (id)[UIImage imageNamed:@"jrddHomeCenter.png"].CGImage;
    ballLayer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view.layer addSublayer:ballLayer];
    //    [self.tapPhotoView.layer setMasksToBounds:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayer];
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

- (void)doLayoutAnimation
{
    /*
    // tap photo
    self.tapPhotoView.hidden = NO;
    [self.tapPhotoView setFrame:CGRectMake(60, 0, 200, 191)];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.tapPhotoView setFrame:CGRectMake(60, 207, 200, 191)];
                         
                         if (SCREEN_HEIGHT < 568) {
                             
                             tapPhotoView.frame = CGRectMake(tapPhotoView.frame.origin.x, tapPhotoView.frame.origin.y - 30, CGRectGetWidth(tapPhotoView.frame), CGRectGetHeight(tapPhotoView.frame));
                         }
                     }
                     completion:nil];
    */
    
    // tap scanning
    self.tapScanningView.hidden = NO;
    [self.tapScanningView setFrame:CGRectMake(96, SCREEN_HEIGHT, 128, 64)];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.tapScanningView setFrame:CGRectMake(96, 460, 128, 64)];
                         
                         if (SCREEN_HEIGHT < 568) {
                             
                             tapScanningView.frame = CGRectMake(tapScanningView.frame.origin.x, tapScanningView.frame.origin.y - 40, CGRectGetWidth(tapScanningView.frame), CGRectGetHeight(tapScanningView.frame));
                         }
                     }
                     completion:nil];

}

#pragma mark -
#pragma mark 动画
- (void)doPhotoAnmation
{
    angle = 30.0;
    timeInter = 0.05;
    index = 1;
    
    self.tapPhotoView.hidden = YES;
    //左右摇摆时间是定义的时间的2倍
    [NSTimer scheduledTimerWithTimeInterval:timeInter*2
                                     target:self
                                   selector:@selector(ballAnmation:)
                                   userInfo:nil
                                    repeats:YES];
    
    index = 0;
}

- (void)ballAnmation:(NSTimer *)theTimer
{
    //设置左右摇摆
    angle =- angle;
    if (angle > 0) {
        angle -= 2;
    } else {
        angle += 2;
    }
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(DEGREES_TO_RADIANS(angle))];
    rotationAnimation.duration = timeInter;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.autoreverses = YES; // Very convenient CA feature for an animation like this
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ballLayer addAnimation:rotationAnimation forKey:@"transform"];
    
    //动画完毕操作
    if (angle == 0) {
        [theTimer invalidate];
        
        angle = 0; // 30;
        timeInter = 0.03; //0.05;
        
        ballLayer.hidden = YES;
        self.tapPhotoView.hidden = NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)goPhotoVC
{
    
    [AppManager instance].logicType = PAWN_LOGIC_TYPE;
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    //    [self.navigationController pushViewController:photoViewController animated:YES];
    [self presentViewController:photoViewController animated:YES completion:^{}];
    
}

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
        
    UIView *view = (UIView*)[gestureRecognizer view];
    
    if ([view isEqual:self.tapPhotoView]) {
        DLog(@"tap tap Photo View");
        
        self.photoImg.image = [UIImage imageNamed:@"jrddHomeCenter_sel.png"];
        [self performSelector:@selector(goPhotoVC) withObject:nil afterDelay:1];
        
    } else if ([view isEqual:self.tapScanningView]) {
        
        BarCodeViewController *barCodeVC = [[BarCodeViewController alloc] init];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:barCodeVC animated:YES];
//        [self presentViewController:barCodeVC animated:YES completion:^{}];
    }
}

@end
