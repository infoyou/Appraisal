
#import "ReportViewController.h"

@interface ReportViewController () 

@end

@implementation ReportViewController

@synthesize mScrollView;
@synthesize topView;
@synthesize middleView;
@synthesize bottomView;

@synthesize photoImg;
@synthesize brandLabel;
@synthesize serialLabel;
@synthesize timeLabel;
@synthesize applicableLabel;
@synthesize marketPriceLabel;
@synthesize pawnPriceLabel;
@synthesize usedPriceLabel;

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
        
        [self.topView setFrame:CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 5, CGRectGetWidth(self.topView.frame), CGRectGetHeight(self.topView.frame))];
        
        [self.middleView setFrame:CGRectMake(self.middleView.frame.origin.x, self.middleView.frame.origin.y - 25, CGRectGetWidth(self.middleView.frame), CGRectGetHeight(self.middleView.frame))];
        
        [self.bottomView setFrame:CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y - 35, CGRectGetWidth(self.bottomView.frame), CGRectGetHeight(self.bottomView.frame))];
        
        ((UIScrollView*)(self.mScrollView)).contentSize = CGSizeMake(SCREEN_WIDTH, 640);
        ((UIScrollView*)(self.mScrollView)).scrollEnabled = YES;
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
    
    // action
    [self addTapGestureRecognizer:self.btnShare];
    [self addTapGestureRecognizer:self.btnSave];
    [self addTapGestureRecognizer:self.btnPawn];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
        
    UIView *view = (UIView*)[gestureRecognizer view];
    
    if ([view isEqual:self.btnShare]) {
        
        NSLog(@"Do Share");
        
        [self doScreenShot];
        
        // Share
        [self initAllSharePlat];
        
    } else if ([view isEqual:self.btnSave]) {
        
        NSLog(@"Do Save");

    } else if ([view isEqual:self.btnPawn]) {

        NSLog(@"Do Pawn");
    }
}

- (void)updateData:(NSDictionary *)msgDict
{
    NSString *marketPriceStr = [NSString stringWithFormat:@" ￥%@", (NSString *)[msgDict objectForKey:@"marketPrice"]];
    NSString *usedPriceStr = [NSString stringWithFormat:@" ￥%@",(NSString *)[msgDict objectForKey:@"usedPrice"]];
    NSString *impawnPriceStr = [NSString stringWithFormat:@" ￥%@",(NSString *)[msgDict objectForKey:@"impawnPrice"]];
    NSString *imgurlStr = (NSString *)[msgDict valueForKey:@"imgurl"];
    
    // Market Price
    NSMutableAttributedString *marketPriceAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", @"市场价: ", marketPriceStr]];
    
    [marketPriceAttributed addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:21.f]
                          range:NSMakeRange(6, marketPriceStr.length)];
    
    self.marketPriceLabel.attributedText = marketPriceAttributed;
    
    // Old Price
    NSMutableAttributedString *oldPriceAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", @"二手价: ", usedPriceStr]];
    
    [oldPriceAttributed addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:21.f]
                          range:NSMakeRange(6, usedPriceStr.length)];
    
    self.usedPriceLabel.attributedText = oldPriceAttributed;
    
    // Pawn Price
    NSMutableAttributedString *pawnPriceAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", @"典当价: ", impawnPriceStr]];
    
    [pawnPriceAttributed addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:21.f]
                          range:NSMakeRange(6, impawnPriceStr.length)];
    
    self.pawnPriceLabel.attributedText = pawnPriceAttributed;
    
    
}

- (void)doScreenShot
{
    
    CGRect shotFrame = CGRectMake(0, 64, SCREEN_WIDTH, 368);
    
    if (SCREEN_HEIGHT < 568) {
        
        shotFrame = CGRectMake(0, 64, SCREEN_WIDTH, 338);
    }
    
    //first we will make an UIImage from your view
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //now we will position the image, X/Y away from top left corner to get the portion we want
    UIGraphicsBeginImageContext(shotFrame.size);
    [sourceImage drawAtPoint:CGPointMake(0, -65)];
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(croppedImage,nil, nil, nil);
    
    // 保存到文件目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/share"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:NULL]; //Create folder
    }
    
    // Image to Data
    NSData * binaryImageData = UIImagePNGRepresentation(croppedImage);
    
    [binaryImageData writeToFile:[dataPath stringByAppendingPathComponent:@"share.png"] atomically:YES];
}

#pragma mark - action
- (IBAction)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doHomeAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
