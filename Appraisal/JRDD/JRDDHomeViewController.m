
#import "JRDDHomeViewController.h"
#import "PhotoViewController.h"
#import "BarCodeViewController.h"

@interface JRDDHomeViewController () <UINavigationControllerDelegate>

@end

@implementation JRDDHomeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        
        [self presentViewController:photoViewController animated:YES completion:^{}];
        
    } else if ([view isEqual:self.tapScanningView]) {
        
        BarCodeViewController *barCodeVC = [[BarCodeViewController alloc] init];
        
        [self.navigationController pushViewController:barCodeVC animated:YES];
//        [self presentViewController:barCodeVC animated:YES completion:^{}];
    }
}

@end
