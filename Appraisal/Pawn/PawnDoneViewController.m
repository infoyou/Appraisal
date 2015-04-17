
#import "PawnDoneViewController.h"

@interface PawnDoneViewController () 

@end

@implementation PawnDoneViewController


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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)adjustView
{
    
    if (SCREEN_HEIGHT < 568) {
        
        [self.topImg setFrame:CGRectMake(self.topImg.frame.origin.x, self.topImg.frame.origin.y - 5, CGRectGetWidth(self.topImg.frame), CGRectGetHeight(self.topImg.frame))];
        
        [self.bottomImg setFrame:CGRectMake(self.bottomImg.frame.origin.x, self.bottomImg.frame.origin.y - 25, CGRectGetWidth(self.bottomImg.frame), CGRectGetHeight(self.bottomImg.frame))];
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - action
- (IBAction)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doHomeAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
