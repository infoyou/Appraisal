
#import "PawnReportViewController.h"
#import "FMDBConnection.h"
#import "AssessObject.h"

@interface PawnReportViewController () 

@end

@implementation PawnReportViewController
{
    AssessObject *assessObject;
}

@synthesize mScrollView;
@synthesize topView;
@synthesize middleView;
@synthesize bottomView;

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
    
    assessObject = [[FMDBConnection instance] getAssessRecordById:[AppManager instance].objectRecordId];
    
    [self loadLogicData];
    
    [self loadLogicDataFromServer];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)loadLogicDataFromServer
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:assessObject.logicId forKey:@"id"];
    
    NSMutableDictionary *paramDict = [CommonUtils getParamDict:@"getImpawnInfo"
                                                      dataDict:dataDict];
    
    [self showHUDWithText:@"正在加载"
                   inView:self.view
              methodBlock:^(CompletionBlock completionBlock, ATMHud *hud)
     {
         
         [HttpRequestData dataWithDic:paramDict
                          requestType:POST_METHOD
                            serverUrl:HOST_URL
                             andBlock:^(NSString*requestStr) {
                                 
                                 if (completionBlock) {
                                     completionBlock();
                                 }
                                 
                                 if ([requestStr isEqualToString:@"Start"]) {
                                     
                                     DLog(@"Start");
                                 } else if([requestStr isEqualToString:@"Failed"]) {
                                     
                                     DLog(@"Failed");
                                     
                                     [self showHUDWithText:@"联网失败" completion:^{
                                     }];
                                     
                                 } else {
                                     
                                     NSDictionary* backDic = [HttpRequestData jsonValue:requestStr];
                                     NSLog(@"requestStr = %@", backDic);
                                     
                                     if (backDic != nil) {
                                         
                                         NSString *errCodeStr = (NSString *)[backDic valueForKey:@"errcode"];
                                         
                                         if ( [errCodeStr integerValue] == 0 ) {
                                             
                                             // 金融典当逻辑处理
                                             NSDictionary *msgDict = [backDic objectForKey:@"result"];
                                             
                                             NSString *resultMsg = @"";
                                             
                                             if ([[msgDict objectForKey:@"pgresult"] isKindOfClass:[NSNumber class]]) {
                                                 
                                                 resultMsg = [NSString stringWithFormat:@"%@", [msgDict objectForKey:@"pgresult"]];
                                             } else if ([[msgDict objectForKey:@"pgresult"] isKindOfClass:[NSString class]]) {
                                                 
                                                 resultMsg = [msgDict objectForKey:@"pgresult"];
                                             }
                                             
                                             if (resultMsg && resultMsg.length > 0) {
                                                 self.resultLabel.text = resultMsg;
                                             } else {
                                                 self.resultLabel.text = @"暂无反馈";
                                             }
                                             
                                         } else {
                                             
                                             [self showHUDWithText:[backDic valueForKey:@"errmsg"]];
                                         }
                                     }
                                 }
                             }];
     }];
}

- (void)loadLogicData
{
    // 初始化
    self.mark1Label.text = @"";
    self.mark2Label.text = @"";
    self.mark3Label.text = @"";
    self.mark4Label.text = @"";
    
    self.resultLabel.text = @"";
    
    // 赋值
    if (assessObject != nil) {
        
        if (assessObject.mark1.length > 0) {
            self.mark1Label.text = assessObject.mark1;
        }
        
        if (assessObject.mark2.length > 0) {
            self.mark2Label.text = assessObject.mark2;
        }
        
        if (assessObject.mark3.length > 0) {
            self.mark3Label.text = assessObject.mark3;
        }
        
        if (assessObject.mark4.length > 0) {
            self.mark4Label.text = assessObject.mark4;
        }
    }
    
    // Object Image
    photoImg.image = [CommonUtils loadImageFromDocument:@"/image" file:assessObject.fileName];
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
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
