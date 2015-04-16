
#import "AboutViewController.h"

@interface AboutViewController () 

@end

@implementation AboutViewController

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

    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
