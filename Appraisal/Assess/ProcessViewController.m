
#import "ProcessViewController.h"
#import "ReportViewController.h"
#import "PawnDoneViewController.h"

#import "FMDBConnection.h"
#import "AssessObject.h"

@interface ProcessViewController ()

@end

@implementation ProcessViewController
{
}

#pragma mark - UIViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadTitle];
    
    [self initData];
    
    [self performSelector:@selector(adjustFlowView) withObject:nil afterDelay:1];

    [self loadWebView];
}

- (void)loadTitle
{
    NSString *titleName = @"";
    
    switch ([AppManager instance].babyType) {
            
        case JADE_TYPE:
        {
            titleName = @"玉石";
        }
            break;
            
        case ARTWORK_TYPE:
        {
            titleName = @"艺术品";
        }
            break;
            
        case GEM_TYPE:
        {
            titleName = @"宝石";
        }
            break;
            
        case GOLD_TYPE:
        {
            titleName = @"素金饰品";
        }
            break;
            
        case WATCH_TYPE:
        {
            titleName = @"手表";
        }
            break;
            
        case AUTO_TYPE:
        {
            titleName = @"机动车";
        }
            break;
            
        case DIAMOND_TYPE:
        {
            titleName = @"钻石";
        }
            break;
            
        case REAL_ESTATE_TYPE:
        {
            titleName = @"房地产";
        }
            break;
            
        default:
            titleName = @"";
            break;
    }
    
    self.titleLabel.text = titleName;
}

- (void)loadWebView
{
    self.mWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    NSString *localFileName = @"assessment-baoshi";
    
    if ([AppManager instance].logicType == ASSESS_LOGIC_TYPE) {
        switch ([AppManager instance].babyType) {
                
            case JADE_TYPE:
            {
                localFileName = @"assessment-yushi";
                [AppManager instance].logicType = PAWN_LOGIC_TYPE;
            }
                break;
                
            case ARTWORK_TYPE:
            {
                localFileName = @"assessment-artwork";
                [AppManager instance].logicType = PAWN_LOGIC_TYPE;
            }
                break;
                
            case GEM_TYPE:
            {
                localFileName = @"assessment-coloured";
                [AppManager instance].logicType = PAWN_LOGIC_TYPE;
            }
                break;
                
            case GOLD_TYPE:
            {
                localFileName = @"assessment-sujin";
            }
                break;
                
            case WATCH_TYPE:
            {
                localFileName = @"assessment-shoubiao";
            }
                break;
                
            case AUTO_TYPE:
            {
                localFileName = @"assessment-car";
            }
                break;
                
            case DIAMOND_TYPE:
            {
                localFileName = @"assessment-zuanshi";
            }
                break;
                
            case REAL_ESTATE_TYPE:
            {
                localFileName = @"assessment-house";
            }
                break;
                
            default:
                localFileName = @"assessment-baoshi";
                break;
        }
    } else if ([AppManager instance].logicType == PAWN_LOGIC_TYPE) {
        switch ([AppManager instance].babyType) {
                
            case JADE_TYPE:
            {
                localFileName = @"pawn-yushi";
            }
                break;
                
            case ARTWORK_TYPE:
            {
                localFileName = @"pawn-artwork";
            }
                break;
                
            case GEM_TYPE:
            {
                localFileName = @"pawn-coloured";
            }
                break;
                
            case GOLD_TYPE:
            {
                localFileName = @"pawn-sujin";
            }
                break;
                
            case WATCH_TYPE:
            {
                localFileName = @"pawn-shoubiao";
            }
                break;
                
            case AUTO_TYPE:
            {
                localFileName = @"pawn-car";
            }
                break;
                
            case DIAMOND_TYPE:
            {
                localFileName = @"pawn-zuanshi";
            }
                break;
                
            case REAL_ESTATE_TYPE:
            {
                localFileName = @"pawn-house";
            }
                break;
                
            default:
                localFileName = @"assessment-baoshi";
                break;
        }
    }
    

    // 黄色加载
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:localFileName ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObjc = [NSURLRequest requestWithURL:url];
    
    [self.mWebView loadRequest:requestObjc];
}

- (void)adjustFlowView
{
    self.photoBgView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // add additional scroll area arround content
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        const CGRect navBarFrame = self.navigationController.navigationBar.frame;
        const CGFloat blankVerticalSpace = navBarFrame.origin.y + navBarFrame.size.height;

        self.mWebView.scrollView.contentInset = UIEdgeInsetsMake(64 /*blankVerticalSpace*/, 0, 0, 0);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.photoBgView.hidden = NO;
}

- (void)adjustView
{
    
    self.mWebView.frame = (CGRect){CGPointZero, self.view.frame.size};
    
    if (SCREEN_HEIGHT < 568) {
        
//        self.mWebView.frame = CGRectOffset(self.mWebView.frame, 0, - 88);
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark -
#pragma mark handle action
- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    
//    UIView *view = (UIView *)[gestureRecognizer view];
    
//    if ([view isEqual:self.doneBtn]) {
//        
//        UIWebViewController *webVC = [[UIWebViewController alloc] init];
//        UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webVC];
//        webNav.title = @"鉴定评估";
//    }
}

- (IBAction)doBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)doHomeAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate method

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    //    [[aWebView windowScriptObject] evaluateWebScript:@"function fun(x) {return x;}"];
    
    //    [aWebView stringByEvaluatingJavaScriptFromString:@"alert('登录成功!')"];
    
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    // 禁用用户选择
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // 防止拖动后产生白屏
    self.mWebView.backgroundColor = [UIColor blackColor];
    [(UIScrollView *)[[self.mWebView subviews] objectAtIndex:0] setBounces:NO];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    // 处理JavaScript和Objective-C交互
    
    if([[[url scheme] lowercaseString] isEqualToString:@"submit"]) {
        
        // 得到html5的表单
        NSUInteger offset = [url host].length + 3;
//        if([[url host] isEqualToString:@"data"])
        {
            NSString *showString = [[url resourceSpecifier] substringFromIndex:offset];
            NSString *parmString = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 解析参数
            NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
            for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [dataDict setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            if ([AppManager instance].logicType == PAWN_LOGIC_TYPE) {
                
                NSMutableArray *mediaArray = [NSMutableArray array];
                
                // Media
                NSMutableDictionary *mediaDict = [[NSMutableDictionary alloc] init];
                [mediaDict setObject:[AppManager instance].objectUploadImgId forKey:@"mediaId"];
                [mediaDict setObject:@"img" forKey:@"mediatype"];
                [mediaArray addObject:mediaDict];
                
                [dataDict setObject:mediaArray forKey:@"media"];
            }
            
            NSLog(@"params = %@", [dataDict description]);
            
            NSMutableDictionary *paramDict = [CommonUtils getParamDict:[url host]
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
                                                     
                                                     if ([AppManager instance].logicType == ASSESS_LOGIC_TYPE) {
                                                         
                                                         // 当 [玉石 艺术品 宝石], 执行 进入金融典当 逻辑处理
                                                         if ([AppManager instance].babyType <= 2) {
                                                             
                                                             // return;
                                                         }
                                                         
                                                         // 鉴定评估逻辑处理
                                                         if ([[backDic objectForKey:@"result"] isKindOfClass:[NSString class]])
                                                         {
                                                             [self showHUDWithText:@"返回数据为空!"];
                                                             return;
                                                         }
                                                         
                                                         NSDictionary *msgDict = [backDic objectForKey:@"result"];
                                                         
                                                         NSLog(@"msgDict = %@", msgDict);
                                                         
                                                         NSInteger marketPrice = [msgDict objectForKey:@"marketPrice"];
                                                         if (marketPrice > 0) {
                                                             
                                                             [self saveDB:dataDict backDict:msgDict];
                                                             [self goReport:msgDict];
                                                         } else {
                                                             
                                                             [self showHUDWithText:[NSString stringWithFormat:@"价格为 %d", marketPrice]];
                                                         }
                                                         
                                                     } else if ([AppManager instance].logicType == PAWN_LOGIC_TYPE) {
                                                        // 金融典当逻辑处理
                                                         NSDictionary *msgDict = [backDic objectForKey:@"result"];
                                                         
                                                         [self saveDB:dataDict backDict:msgDict];
                                                         
                                                         NSString *resultMsg = @"";
                                                         
                                                         if ([[msgDict objectForKey:@"id"] isKindOfClass:[NSNumber class]]) {
                                                             
                                                             resultMsg = [NSString stringWithFormat:@"%@", [msgDict objectForKey:@"id"]];
                                                         } else if ([[msgDict objectForKey:@"id"] isKindOfClass:[NSString class]]) {
                                                             
                                                            resultMsg = [msgDict objectForKey:@"id"];
                                                         }
                                                         
                                                         [self showHUDWithText:resultMsg];
                                                         
                                                         PawnDoneViewController *resultVC = [[PawnDoneViewController alloc] init];
                                                         [self presentViewController:resultVC animated:YES completion:^{}];
                                                     }

                                                 } else {
                                                     
                                                     [self showHUDWithText:[backDic valueForKey:@"errmsg"]];
                                                 }
                                             }
                                         }
                                     }];
             }];

        }
        
        return NO;
    } else if([[[url scheme] lowercaseString] isEqualToString:@"showalert"]) {
        
//        if (YES) {
//            [self goReport:[NSDictionary dictionary]];
//        }
        
        // 处理js的alert
        if([[url host] isEqualToString:@"data"])
        {
            
            NSString *showString = [[url resourceSpecifier] substringFromIndex:11];
            
            NSString *promptMsg = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self showHUDWithText:promptMsg];
            
//            [[[UIAlertView alloc] initWithTitle:str
//                                        message:nil
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil
//              ] show];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)goReport:(NSDictionary *)msgDict
{
    ReportViewController *reportVC = [[ReportViewController alloc] init];
    
//    [self.navigationController pushViewController:reportVC animated:YES];
    [self presentViewController:reportVC animated:YES completion:^{}];
    
    [reportVC updateData:msgDict];
}

- (void)saveDB:(NSMutableDictionary *)requestDict backDict:(NSDictionary *)backDict
{
    NSInteger type = [(NSString *)[requestDict objectForKey:@"type"] integerValue];

    // 动态生成id
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *recordId = [NSString stringWithFormat:@"%.0f", a];

    [AppManager instance].objectRecordId = recordId;
    
    // Server返回的id
    NSString *logicId = @"";
    if ([[backDict objectForKey:@"id"] isKindOfClass:[NSNumber class]]) {
        logicId = [NSString stringWithFormat:@"%@",[backDict objectForKey:@"id"]];
    } else if ([[backDict objectForKey:@"id"] isKindOfClass:[NSString class]]) {
        logicId = [backDict objectForKey:@"id"];
    }
    
    // 构建 AssessObject
    AssessObject *assessInfo = [[AssessObject alloc] init];
    assessInfo.assessId = recordId;
    assessInfo.logicId = logicId;
    assessInfo.assessType = @([AppManager instance].logicType);
    assessInfo.logicType = @(type);

    assessInfo.attachType = @(INPUT_PHOTO_TYPE);
    assessInfo.fileName = [AppManager instance].objectAttachmentFileName;
    
    if ([AppManager instance].logicType == ASSESS_LOGIC_TYPE) {
        
        switch (type) {
                
            case 5:
            {
                // 素金
                NSString *categoryType = [requestDict objectForKey:@"categoryType"]; //类别
                NSString *weight = [requestDict objectForKey:@"weight"]; //重量
                
                assessInfo.mark1 = [NSString stringWithFormat:@"类别: %@", categoryType];
                assessInfo.mark2 = [NSString stringWithFormat:@"重量: %@", weight];
                
            }
                break;
                
            case 4:
            {
                // 手表
                NSString *watchType = [requestDict objectForKey:@"watchType"];//品牌
                NSString *watchSeries = [requestDict objectForKey:@"watchSeries"];//系列
                NSString *watchSex = [requestDict objectForKey:@"watchSex"];//性别
                NSString *facewarp = [requestDict objectForKey:@"facewarp"];//表径
                NSString *material = [requestDict objectForKey:@"material"];//材料
                
                
                assessInfo.mark1 = [NSString stringWithFormat:@"品牌: %@", watchType];
                assessInfo.mark2 = [NSString stringWithFormat:@"系列: %@", watchSeries];
                assessInfo.mark3 = [NSString stringWithFormat:@"性别: %@", watchSex];
                assessInfo.mark4 = [NSString stringWithFormat:@"材料: %@", material];
            }
                break;
                
                
            case 2:
            {
                // 汽车
                NSString *city = [requestDict objectForKey:@"city"];//城市
                NSString *brand = [requestDict objectForKey:@"brand"];//品牌
                NSString *car = [requestDict objectForKey:@"car"];//车系
                NSString *carModel = [requestDict objectForKey:@"carModel"];//配置
                NSString *cardDate = [requestDict objectForKey:@"cardDate"];//上牌时间
                NSString *mileage = [requestDict objectForKey:@"mileage"];//万公里
                
                assessInfo.mark1 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark2 = [NSString stringWithFormat:@"配置: %@", carModel];
                assessInfo.mark3 = [NSString stringWithFormat:@"上牌时间: %@", cardDate];
                assessInfo.mark4 = [NSString stringWithFormat:@"%@万公里", mileage];
                
            }
                break;
                
            case 3:
            {
                // 钻石
                NSString *goldSize = [requestDict objectForKey:@"goldSize"];//大小
                NSString *goldColor = [requestDict objectForKey:@"goldColor"];//颜色
                NSString *cleanliness = [requestDict objectForKey:@"cleanliness"];//净度
                
                assessInfo.mark1 = [NSString stringWithFormat:@"大小: %@", goldSize];
                assessInfo.mark2 = [NSString stringWithFormat:@"颜色: %@", goldColor];
                assessInfo.mark3 = [NSString stringWithFormat:@"净度: %@", cleanliness];
                
            }
                break;
                
            case 1:
            {
                // 房地产
                NSString *city = [requestDict objectForKey:@"city"];//城市
                NSString *district = [requestDict objectForKey:@"district"];//小区
                NSString *area = [requestDict objectForKey:@"Area"];//面积
                
                assessInfo.mark1 = [NSString stringWithFormat:@"城市: %@", city];
                assessInfo.mark2 = [NSString stringWithFormat:@"小区: %@", district];
                assessInfo.mark3 = [NSString stringWithFormat:@"面积: %@", area];
            }
                break;
                
            default:
                break;
        }
        
        assessInfo.marketPrice = [NSString stringWithFormat:@"市场价: ￥%@", (NSString *)[backDict objectForKey:@"marketPrice"]];
        assessInfo.usedPrice = [NSString stringWithFormat:@"二手价: ￥%@",(NSString *)[backDict objectForKey:@"usedPrice"]];
        assessInfo.pawnPrice = [NSString stringWithFormat:@"典当价: ￥%@",(NSString *)[backDict objectForKey:@"impawnPrice"]];

    } else if ([AppManager instance].logicType == PAWN_LOGIC_TYPE) {
        
        switch (type) {
                
            case 7:
            {
                // 玉石饰品
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *categoryType = [requestDict objectForKey:@"categoryType"]; //贵金属类别
                NSString *weight = [requestDict objectForKey:@"weight"]; //重量
                NSString *brand = [requestDict objectForKey:@"brand"]; //品牌
                NSString *commodityName = [requestDict objectForKey:@"commodityName"]; //品名
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"贵金属类别: %@", categoryType];
                assessInfo.mark3 = [NSString stringWithFormat:@"重量: %@", weight];
                assessInfo.mark4 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark5 = [NSString stringWithFormat:@"品名: %@", commodityName];
                
            }
                break;

            case 8:
            {
                // 艺术品
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *categoryType = [requestDict objectForKey:@"categoryType"]; //贵金属类别
                NSString *weight = [requestDict objectForKey:@"weight"]; //重量
                NSString *brand = [requestDict objectForKey:@"brand"]; //品牌
                NSString *commodityName = [requestDict objectForKey:@"commodityName"]; //品名
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"贵金属类别: %@", categoryType];
                assessInfo.mark3 = [NSString stringWithFormat:@"重量: %@", weight];
                assessInfo.mark4 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark5 = [NSString stringWithFormat:@"品名: %@", commodityName];
                
            }
                break;

                
            case 6:
            {
                // 有色宝石
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *categoryType = [requestDict objectForKey:@"categoryType"]; //贵金属类别
                NSString *weight = [requestDict objectForKey:@"weight"]; //全重
                NSString *brand = [requestDict objectForKey:@"brand"]; //品牌
                NSString *commodityName = [requestDict objectForKey:@"commodityName"]; //品名
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"贵金属类别: %@", categoryType];
                assessInfo.mark3 = [NSString stringWithFormat:@"重量: %@", weight];
                assessInfo.mark4 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark5 = [NSString stringWithFormat:@"品名: %@", commodityName];
                
            }
                break;

            case 5:
            {
                // 素金
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *categoryType = [requestDict objectForKey:@"categoryType"]; //贵金属类别
                NSString *weight = [requestDict objectForKey:@"weight"]; //全重
                NSString *brand = [requestDict objectForKey:@"brand"]; //品牌
                NSString *commodityName = [requestDict objectForKey:@"commodityName"]; //品名
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"贵金属类别: %@", categoryType];
                assessInfo.mark3 = [NSString stringWithFormat:@"重量: %@", weight];
                assessInfo.mark4 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark5 = [NSString stringWithFormat:@"品名: %@", commodityName];

            }
                break;
                
            case 4:
            {
                // 手表
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *brand = [requestDict objectForKey:@"brand"]; //品牌
                NSString *series = [requestDict objectForKey:@"series"]; //系列
                NSString *model = [requestDict objectForKey:@"model"];//型号
                NSString *preciousStones = [requestDict objectForKey:@"preciousStones"];//镶嵌宝石

                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark3 = [NSString stringWithFormat:@"系列: %@", series];
                assessInfo.mark4 = [NSString stringWithFormat:@"型号: %@", model];
                assessInfo.mark5 = [NSString stringWithFormat:@"镶嵌宝石: %@", preciousStones];
                
            }
                break;
                
                
            case 2:
            {
                // 汽车
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *address = [requestDict objectForKey:@"address"]; //所在地
                NSString *modelName = [requestDict objectForKey:@"modelName"]; //车型名称
                NSString *cardDate = [requestDict objectForKey:@"cardDate"];//上牌日期
                NSString *mileage = [requestDict objectForKey:@"mileage"];//行驶里程
                NSString *displacement = [requestDict objectForKey:@"displacement"];//排量
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"所在地: %@", address];
                assessInfo.mark3 = [NSString stringWithFormat:@"车型名称: %@", modelName];
                assessInfo.mark4 = [NSString stringWithFormat:@"上牌日期: %@", cardDate];
                assessInfo.mark5 = [NSString stringWithFormat:@"行驶里程: %@", mileage];
                assessInfo.mark6 = [NSString stringWithFormat:@"排量: %@", displacement];
                
            }
                break;
                
            case 3:
            {
                // 钻石
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *categoryType = [requestDict objectForKey:@"categoryType"];//贵金属类别
                NSString *weight = [requestDict objectForKey:@"weight"];//全重
                NSString *brand = [requestDict objectForKey:@"brand"];//品牌
                NSString *goldSize = [requestDict objectForKey:@"goldSize"];//大小
                NSString *goldColor = [requestDict objectForKey:@"goldColor"];//颜色
                NSString *cleanliness = [requestDict objectForKey:@"cleanliness"];//净度
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"贵金属类别: %@", categoryType];
                assessInfo.mark3 = [NSString stringWithFormat:@"重量: %@", weight];
                assessInfo.mark4 = [NSString stringWithFormat:@"品牌: %@", brand];
                assessInfo.mark5 = [NSString stringWithFormat:@"大小: %@", goldSize];
                assessInfo.mark6 = [NSString stringWithFormat:@"颜色: %@", goldColor];
                assessInfo.mark7 = [NSString stringWithFormat:@"净度: %@", cleanliness];
            }
                break;
                
            case 1:
            {
                // 房地产
                NSString *name = [requestDict objectForKey:@"name"]; //典当物名称
                NSString *houseLocated = [requestDict objectForKey:@"houseLocated"];//房屋坐落
                NSString *coveredArea = [requestDict objectForKey:@"coveredArea"];//建筑面积
                NSString *propertyName = [requestDict objectForKey:@"propertyName"];//物业名称
                NSString *detailedAddress = [requestDict objectForKey:@"detailedAddress"];//详细地址
                
                assessInfo.mark1 = [NSString stringWithFormat:@"名称: %@", name];
                assessInfo.mark2 = [NSString stringWithFormat:@"房屋坐落: %@", houseLocated];
                assessInfo.mark3 = [NSString stringWithFormat:@"建筑面积: %@", coveredArea];
                assessInfo.mark4 = [NSString stringWithFormat:@"物业名称: %@", propertyName];
                assessInfo.mark5 = [NSString stringWithFormat:@"详细地址: %@", detailedAddress];
            }
                break;
                
            default:
                break;
        }

    }
    
    [[FMDBConnection instance] insertAssessObjectDB:assessInfo];
}

@end
