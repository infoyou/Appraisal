
#import "BarCodeViewController.h"

@interface BarCodeViewController ()

@end

@implementation BarCodeViewController

@synthesize readerView;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫码";
    
    ZBarImageScanner *imageScanner = [[ZBarImageScanner alloc] init];
    readerView = [[ZBarReaderView alloc] initWithImageScanner:imageScanner];
    [readerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [readerView setTracksSymbols:NO];
    readerView.readerDelegate = self;
    [self.view addSubview:readerView];
    
    //扫一扫底图
    UIImageView *bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sweep.png"]];
    bgImgV.frame = CGRectMake((SCREEN_WIDTH-220)/2, 100, 220, 220);
    [self.view addSubview:bgImgV];
    
    UIImageView *barScanImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barScan.png"]];
    [barScanImgV setFrame:CGRectMake(SCREEN_WIDTH/2-110, 100, 229.5, 2.5)];
    [self.view addSubview:barScanImgV];
    
    [UIView beginAnimations:@"scanner" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationRepeatCount:HUGE_VALF];
    [barScanImgV setFrame:CGRectMake(SCREEN_WIDTH/2-110, 320, 229.5, 2.5)];
    
    [UIView commitAnimations];
    
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
    
    /*
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 13, 20)];
    backImg.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:backImg];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 13, 64, 51);
    [btnBack addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
     */
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    
    for (ZBarSymbol *sym in symbols) {
        
        NSString *result = sym.data;
        
        if (result && result.length > 0) {
            
            NSLog(@"bar code result = %@", result);
            [self showAlert:result];
        } else {
            [self showAlert:@"无效二维码"];
        }
        
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation: orient
                                        duration: duration];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    // run the reader when the view is visible
    [readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear:animated];
    [readerView stop];
}

- (void) willMoveToParentViewController:(UIViewController *)parent
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
