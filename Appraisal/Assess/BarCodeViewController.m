
#import "BarCodeViewController.h"

#import "BarCodeResultViewController.h"

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
    
    // Title
    UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(64.25, 340, 191.5, 11.5)];
    titleImg.image = [UIImage imageNamed:@"scanTitle.png"];
    [self.view addSubview:titleImg];
    
    // Back
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(76.25, SCREEN_HEIGHT - 80, 167.5, 64)];
    backImg.image = [UIImage imageNamed:@"backGujia.png"];
    [self.view addSubview:backImg];
    
    [self addTapGestureRecognizer:backImg];
}

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = (UIView*)[gestureRecognizer view];
    int viewTag = view.tag;
    
    DLog(@"%d is touched", viewTag);
    [self doBackAction:nil];
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    
    for (ZBarSymbol *sym in symbols) {
        
        NSString *result = sym.data;
        
        if (result && result.length > 0) {
            
            NSLog(@"bar code result = %@", result);
//            [self showAlert:result];
            
            if ([result hasPrefix:@"http://"] || [result hasPrefix:@"https://"]) {
                [AppManager instance].webUrl = result;
            }
            
            [self goReport];
//            [self performSelector:@selector(goReport) withObject:nil afterDelay:1];
        } else {
            [self showAlert:@"无效二维码"];
        }
        
    }
}

- (void)goReport
{

    BarCodeResultViewController *resultVC = [[BarCodeResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
//    [self presentViewController:resultVC animated:YES completion:^{}];
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
