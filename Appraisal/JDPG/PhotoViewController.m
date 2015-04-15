
#import "PhotoViewController.h"
#import "ResultViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AFHTTPRequestOperationManager.h"

#define SCROLL_UNIT_WIDTH       65.f
#define MAXIMUM_DURATION        40

typedef enum {
    INPUT_FIRST_SCREEN = 0,     // 照片模式
    INPUT_SECOND_SCREEN = 1,    // 摄像模式
} InputScreenType;

typedef enum {
    INPUT_PHOTO_TYPE = 0,       // 照片模式
    INPUT_VIDEO_TYPE = 1,       // 摄像模式
} InputContentType;

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface PhotoViewController () <UINavigationControllerDelegate, PagedFlowViewDelegate, PagedFlowViewDataSource, AVCaptureFileOutputRecordingDelegate>

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;

@property (nonatomic, retain) NSTimer *videoTimer;
@end

@implementation PhotoViewController
{
    // 标的物种类
    NSArray *typeImgArray;
    // 本地图片
    NSMutableArray *localImgArray;
    NSMutableArray *localImgPathArray;
    NSInteger screenType;
    NSInteger inputType;
    
    // 录制时间 单位
    NSInteger m;
    NSInteger s;
    NSInteger h;
    
    // 转码开始时间
    NSDate* _startDate;
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
    screenType = INPUT_FIRST_SCREEN;
    inputType = INPUT_PHOTO_TYPE;
    
    self.cameraImgView.hidden = YES;
    self.resultView.hidden = YES;
    self.timeLabel.hidden = YES;
    
    localImgArray = [NSMutableArray array];
    localImgPathArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initData];
    
    [self loadCameraResource];
}

- (void)adjustFlowView
{
    self.photoBgView.hidden = YES;
    [self.typeFlowView scrollToPage:2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadTypeResource];
    
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        
        __weak PhotoViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            PhotoViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                // Manually restarting the session since it must have been stopped due to an error.
                [[strongSelf session] startRunning];
//                [[strongSelf recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
            });
        }]];
        [[self session] startRunning];
    });
    
    [self performSelector:@selector(adjustFlowView) withObject:nil afterDelay:1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.photoBgView.hidden = NO;
    
    dispatch_async([self sessionQueue], ^{
        [[self session] stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
        [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    });
}

- (void)loadTypeResource
{

    typeImgArray = [[NSArray alloc] initWithObjects:@"img101.png", @"img102.png", @"img103.png", @"img104.png", @"img105.png", @"img106.png", @"img107.png", @"img108.png", nil];
    
    self.typeFlowView.delegate = self;
    self.typeFlowView.dataSource = self;
    self.typeFlowView.minimumPageAlpha = 0.3;
    self.typeFlowView.minimumPageScale = 0.9;
}

/*
- (void)loadCamera
{
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error;
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    // Input
    if (!deviceInput)
    {
        NSLog(@"No deviceInput");
    }
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    // Preview Layer
    AVCaptureVideoPreviewLayer *preViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [preViewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.previewView.frame;
    [preViewLayer setFrame:frame];
    [rootLayer insertSublayer:preViewLayer atIndex:0];
    
    // Output Photo
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    
    // Output Video
    videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    [session addOutput:videoOutput];

    // Audio
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
    }
    
    if ([session canAddInput:audioDeviceInput])
    {
        [session addInput:audioDeviceInput];
    }
    
    [session startRunning];
}
*/

- (void)loadLocalImageScroll
{
    
    self.photoScrollView.pagingEnabled = NO;
    self.photoScrollView.scrollEnabled = YES;
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    self.photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // 加载方式
    // 1，读取本地文件
    // NSUInteger localSize = [localImgPathArray count];
    
    // 2，读取内存
    NSUInteger localSize = [localImgArray count];
    
    self.photoScrollView.contentSize = CGSizeMake(SCROLL_UNIT_WIDTH * localSize, 50);
    
    for (int i=0; i<localSize; i++) {
        
        
        UIImageView *scrollUnitView = [[UIImageView alloc] initWithFrame:CGRectMake(SCROLL_UNIT_WIDTH*i, 4, 64, 64)];
        scrollUnitView.image = [UIImage imageNamed:@"photoBoard.png"];
        UIImageView *localImgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 56, 56)];
        
        // 1，加载本地图片
        // NSData *imageData = [NSData dataWithContentsOfFile:localImgPathArray[i]];
        // localImgView.image = [UIImage imageWithData:imageData];
        // 2，读取内存
        localImgView.image = localImgArray[i];
        
        [scrollUnitView addSubview:localImgView];
        
        [self.photoScrollView addSubview:scrollUnitView];
    }
}

- (void)adjustView
{
    
    if (SCREEN_HEIGHT < 568) {
        
        self.actionView.frame = CGRectOffset(self.actionView.frame, 0, - 88);
        self.resultView.frame = CGRectOffset(self.actionView.frame, 0, - 88);
    }
    
    NSLog(@"SCREEN_HEIGHT = %f", SCREEN_HEIGHT);
    
    // action
    [self addTapGestureRecognizer:self.takePhotoBtn];
    [self addTapGestureRecognizer:self.doneBtn];
    
    // result
    [self addTapGestureRecognizer:self.resultTakePhoto];
    [self addTapGestureRecognizer:self.resultDoneBtn];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(52, 50);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", pageNumber);
    
    [AppManager instance].babyType = pageNumber;
    
    NSString *imgName = [NSString stringWithFormat:@"title_item%ld.png", pageNumber+1];
    self.resultTextImg.image = [UIImage imageNamed:imgName];
    self.resultTextImg.frame = CGRectMake(self.resultTextImg.frame.origin.x, self.resultTextImg.frame.origin.y, self.resultTextImg.image.size.width/2, self.resultTextImg.image.size.height/2);
}

#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    
    return [typeImgArray count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
    }
    
    imageView.image = [UIImage imageNamed:[typeImgArray objectAtIndex:index]];
    //    imageView.frame = CGRectMake(45, 30, 233, 328);
    //    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    //    [imageView sizeToFit];
    return imageView;
}

- (IBAction)pageControlValueDidChange:(id)sender {
    
    UIPageControl *pageControl = sender;
//    [self.typeFlowView scrollToPage:pageControl.currentPage];
}

#pragma mark -
#pragma mark handle action
- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    
    UIView *view = (UIView*)[gestureRecognizer view];
    
    if ([view isEqual:self.takePhotoBtn]) {
        
        // 隐藏Action View, 进入Result View
        self.actionView.hidden = YES;
        self.resultView.hidden = NO;
        self.resultView.frame = self.actionView.frame;

        screenType = INPUT_SECOND_SCREEN;
        
        if (inputType == INPUT_PHOTO_TYPE) {
            
            // 开始拍照
            [self takePhoto:INPUT_PHOTO_TYPE];
        } else if (inputType == INPUT_VIDEO_TYPE) {
            
            [self takeVideo:nil];
            // 开始视频拍摄
            self.resultTakePhoto.image = [UIImage imageNamed:@"btnStop.png"];
            [self startRecordTime];
        }
        
    } else if ([view isEqual:self.doneBtn]) {

        ResultViewController *resultVC = [[ResultViewController alloc] init];
        [self presentViewController:resultVC animated:YES completion:^{}];
        
    } else if ([view isEqual:self.resultTakePhoto]) {
        
        if (inputType == INPUT_PHOTO_TYPE) {
            
            // 继续拍照
            [self takePhoto:INPUT_PHOTO_TYPE];
        } else if (inputType == INPUT_VIDEO_TYPE) {
            
            if (self.timeLabel.isHidden)
            {
                // 开始视频拍摄
                self.resultTakePhoto.image = [UIImage imageNamed:@"btnStop.png"];
                [self startRecordTime];
                
            } else {
                
                // 结束视频拍摄
                self.resultTakePhoto.image = [UIImage imageNamed:@"btnVideo.png"];
                [self stopRecordTime];
            }
            
            [self takeVideo:nil];
        }
        
    } else if ([view isEqual:self.resultDoneBtn]) {
        
        ResultViewController *resultVC = [[ResultViewController alloc] init];
        [self presentViewController:resultVC animated:YES completion:^{}];
        
//        [self postVideoMehtod];
    }
}

- (void)postVideoMehtod
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *typeName = @"image";
    
    // Local dir
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    // video
//    typeName = @"video";
//    NSDictionary *parameters = @{@"fileName": @"test.mov"};
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/video"];
//    NSString *dataFilePath = [dataPath stringByAppendingPathComponent:[@"test" stringByAppendingPathExtension:@"mov"]];
    
    // photo
    NSDictionary *parameters = @{@"fileName": @"1428661887.png"};
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/image"];
    NSString *dataFilePath = [dataPath stringByAppendingPathComponent:[@"1428661887" stringByAppendingPathExtension:@"png"]];
    
    NSLog(@"dataFilePath = %@", dataFilePath);
    
    NSURL *filePath = [NSURL fileURLWithPath:dataFilePath];
    
    [manager POST:@"http://115.29.161.226:85/weixin/jsonapi/uploadImg" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
//    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"myVideo" ofType:@"mov"];
//    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: videoURL]];

}

- (void)clearData
{
    screenType = INPUT_FIRST_SCREEN;
    
    if (!self.timeLabel.isHidden) {
        
        [self clearPlayState];
    }
    
    [localImgArray removeAllObjects];
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (IBAction)doBackAction:(id)sender {
    
    [self clearData];
    
    if (!self.resultView.isHidden) {
        
        self.actionView.hidden = NO;
        self.resultView.hidden = YES;
    } else {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}

- (IBAction)doHomeAction:(id)sender {
    
    [self clearData];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [((AppDelegate *)APP_DELEGATE).window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doSwitchType:(id)sender {
    
    if (screenType == INPUT_FIRST_SCREEN) {

        if (inputType == INPUT_PHOTO_TYPE) {
            
            inputType = INPUT_VIDEO_TYPE;
            self.takePhotoBtn.image = [UIImage imageNamed:@"btnVideo.png"];
            self.videoImgView.hidden = YES;
            self.cameraImgView.hidden = NO;
            
            self.resultRightImg.hidden = YES;
            self.resultLeftImg.hidden = YES;
            self.photoScrollView.hidden = YES;
            self.photoView.hidden = NO;
            
        } else if (inputType == INPUT_VIDEO_TYPE) {
            
            inputType = INPUT_PHOTO_TYPE;
            self.takePhotoBtn.image = [UIImage imageNamed:@"btnTakePhoto.png"];
            self.videoImgView.hidden = NO;
            self.cameraImgView.hidden = YES;
            
            self.resultRightImg.hidden = NO;
            self.resultLeftImg.hidden = NO;
            self.photoScrollView.hidden = NO;
            self.photoView.hidden = YES;
        }
    } else if (screenType == INPUT_SECOND_SCREEN) {
        
        if (inputType == INPUT_PHOTO_TYPE) {
            
            inputType = INPUT_VIDEO_TYPE;
            self.resultTakePhoto.image = [UIImage imageNamed:@"btnVideo.png"];
            self.videoImgView.hidden = YES;
            self.cameraImgView.hidden = NO;
            
            self.resultRightImg.hidden = YES;
            self.resultLeftImg.hidden = YES;
            self.photoScrollView.hidden = YES;
            self.photoView.hidden = NO;
            
        } else if (inputType == INPUT_VIDEO_TYPE) {
            
            inputType = INPUT_PHOTO_TYPE;
            self.resultTakePhoto.image = [UIImage imageNamed:@"btnTakePhoto.png"];
            self.videoImgView.hidden = NO;
            self.cameraImgView.hidden = YES;
            
            self.resultRightImg.hidden = NO;
            self.resultLeftImg.hidden = NO;
            self.photoScrollView.hidden = NO;
            self.photoView.hidden = YES;
        }
    }
}

- (void)turnPage
{
    CGFloat mark = self.photoScrollView.contentSize.width / self.photoScrollView.frame.size.width;
    
    if (mark > 1) {
        
        [self.photoScrollView setContentOffset:CGPointMake(self.photoScrollView.frame.size.width * mark - SCROLL_UNIT_WIDTH * 3, 0) animated:YES];
    }
}

#pragma mark
#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error)
        NSLog(@"%@", error);
    
    [self setLockInterfaceRotation:NO];
    
    // Note the backgroundRecordingID for use in the ALAssetsLibrary completion handler to end the background task associated with this recording. This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's -isRecording is back to NO — which happens sometime after this method returns.
    UIBackgroundTaskIdentifier backgroundRecordingID = [self backgroundRecordingID];
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
    
    /*
     存相册
    [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
            NSLog(@"%@", error);
        
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
     
        if (backgroundRecordingID != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
    }];
     */
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = [[self videoDeviceInput] device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark UI

- (void)runStillImageCaptureAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self previewView] layer] setOpacity:0.0];
        [UIView animateWithDuration:.25 animations:^{
            [[[self previewView] layer] setOpacity:1.0];
        }];
    });
}

- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                            message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

#pragma mark -
#pragma mark Photo & Video

- (void)loadCameraResource
{
    // Create the AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    
    // Setup the preview view
    [[self previewView] setSession:session];
    
    // Check for device authorization
    [self checkDeviceAuthorizationStatus];
    
    // Preview Layer
    AVCaptureVideoPreviewLayer *preViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [preViewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.previewView.frame;
    [preViewLayer setFrame:frame];
    [rootLayer insertSublayer:preViewLayer atIndex:0];
    
    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
    // Why not do all of this on the main queue?
    // -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue so that the main queue isn't blocked (which keeps the UI responsive).
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [PhotoViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Why are we dispatching this to the main queue?
                // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                
                [[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
            });
        }
        
        AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:audioDeviceInput])
        {
            [session addInput:audioDeviceInput];
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([session canAddOutput:movieFileOutput])
        {
            [session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ([connection isVideoStabilizationSupported])
                [connection setEnablesVideoStabilizationWhenAvailable:YES];
            [self setMovieFileOutput:movieFileOutput];
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([session canAddOutput:stillImageOutput])
        {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            [session addOutput:stillImageOutput];
            [self setStillImageOutput:stillImageOutput];
        }
    });
}

- (BOOL)isSessionRunningAndDeviceAuthorized
{
    return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CapturingStillImageContext)
    {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if (isCapturingStillImage)
        {
            [self runStillImageCaptureAnimation];
        }
    }
    else if (context == RecordingContext)
    {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRecording)
            {
//                [[self cameraButton] setEnabled:NO];
//                [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Recording button stop title") forState:UIControlStateNormal];
//                [[self recordButton] setEnabled:YES];
            }
            else
            {
//                [[self cameraButton] setEnabled:YES];
//                [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Recording button record title") forState:UIControlStateNormal];
//                [[self recordButton] setEnabled:YES];
            }
        });
    }
    else if (context == SessionRunningAndDeviceAuthorizedContext)
    {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRunning)
            {
//                [[self cameraButton] setEnabled:YES];
//                [[self recordButton] setEnabled:YES];
//                [[self stillButton] setEnabled:YES];
            }
            else
            {
//                [[self cameraButton] setEnabled:NO];
//                [[self recordButton] setEnabled:NO];
//                [[self stillButton] setEnabled:NO];
            }
        });
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)takeVideo:(id)sender
{
    
    dispatch_async([self sessionQueue], ^{
//         if (![[self movieFileOutput] isRecording]) // 此判断无效 @ios 7.1.2
        if (!self.timeLabel.isHidden)
        {

            [self setLockInterfaceRotation:YES];
            
            if ([[UIDevice currentDevice] isMultitaskingSupported])
            {
                // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam returns to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the assets library when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in -recorder:recordingDidFinishToOutputFileURL:error: after the recorded file has been saved.
                [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
            }
            
            // Update the orientation on the movie file output video connection before starting recording.
            [[[self movieFileOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
            
            // Turning OFF flash for video recording
            [PhotoViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];
            
            /*
             NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
             NSTimeInterval a=[dat timeIntervalSince1970];
             NSString *dateId = [NSString stringWithFormat:@"%.0f", a];
             
            // 保存到文件目录
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/video"];
            
             if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
             [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:NULL]; //Create folder
             }
            
            NSString *movieFilePath = [dataPath stringByAppendingPathComponent:[@"movie1" stringByAppendingPathExtension:@"mov"]];
            NSLog(@"movieFilePath = %@", movieFilePath);
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:movieFilePath] recordingDelegate:self];
            */
            
            // Start recording to a temporary file.
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie2" stringByAppendingPathExtension:@"mov"]];
            NSLog(@"outputFilePath = %@", outputFilePath);
            [[self movieFileOutput] startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
            
        } else {
            
            [self takePhoto:INPUT_VIDEO_TYPE];
            // 停止录制
            [[self movieFileOutput] stopRecording];
        }
    });
}

- (void)takePhoto:(InputContentType)type
{
    dispatch_async([self sessionQueue], ^{
        // Update the orientation on the still image output video connection before capturing.
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
        
        // Flash set to Auto for Still Capture
        [PhotoViewController setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
        
        // Capture a still image.
        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer)
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                /*
                // 保存到系统相册
                [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
                */
                
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *dateId = [NSString stringWithFormat:@"%.0f", a];

                // 保存到文件目录
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/image"];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:NULL]; //Create folder
                }

                NSString *photoFilePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", dateId]]; //Add the file name
                [imageData writeToFile:photoFilePath atomically:YES]; //Write the file
                
                if (type != INPUT_VIDEO_TYPE) {

                    // 保存到内存
                    [localImgArray addObject:image];
                    // 加载到页面
                    [self loadLocalImageScroll];
                    // 显示照片
                    [self turnPage];
                    
                    /*
                     // 保存照片到文件
                     NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                     
                     // If you go to the folder below, you will find those pictures
                     NSLog(@"%@",docDir);
                     
                     NSLog(@"saving png");
                     
                     NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                     NSTimeInterval a=[dat timeIntervalSince1970];
                     NSString *dateId = [NSString stringWithFormat:@"%.0f", a];
                     
                     NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, dateId];
                     NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
                     [data1 writeToFile:pngFilePath atomically:YES];
                     
                     // 保存文件地址
                     [localImgPathArray addObject:pngFilePath];
                     NSLog(@"saving image done");
                     */

                } else {
                    self.photoView.hidden = NO;
                    self.photoView.image = image;
                }
            }
        }];
    });
}


- (void)startRecordTime
{
 
    m = 0;
    s = 0;
    h = 0;
    
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(showTime)
                                                userInfo:NULL
                                                 repeats:YES];
    
    self.timeLabel.hidden = NO;
}

- (void)stopRecordTime
{
    
    self.timeLabel.text = @"00:00";
    self.timeLabel.hidden = YES;
    
    [self.videoTimer invalidate];
    self.videoTimer = nil;
}

- (void)showTime
{
//    NSDate *now=[NSDate date];
//    NSDateFormatter *dateFormatter=[NSDateFormatter new];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
//    self.timeLabel.text=[dateFormatter stringFromDate:now];
    
    s++;
    
    if(s == 60){
        s = 0;
        m++;
    }
    
    if(m == 60){
        m = 0;
        h ++;
    }
    
    NSString *sStr = nil;
    if (s >= 10) {
        sStr = [NSString stringWithFormat:@"%d", s];
    } else {
        sStr = [NSString stringWithFormat:@"0%d", s];
    }
    
    NSString *mStr = nil;
    if (m >= 10) {
        mStr = [NSString stringWithFormat:@"%d", m];
    } else {
        mStr = [NSString stringWithFormat:@"0%d", m];
    }
    
//    NSString *hStr = nil;
//    if (h >= 10) {
//        hStr = [NSString stringWithFormat:@"%d", h];
//    } else {
//        hStr = [NSString stringWithFormat:@"0%d", h];
//    }
    
//    NSString *showMessage = [NSString stringWithFormat:@"%@:%@:%@", hStr, mStr, sStr];
    
    NSString *showMessage = [NSString stringWithFormat:@"%@:%@", mStr, sStr];
    self.timeLabel.text = showMessage;
    
    if (s > MAXIMUM_DURATION) {
        // 最多拍摄40s
        [self clearPlayState];
    }
}

- (void)clearPlayState
{
    self.resultTakePhoto.image = [UIImage imageNamed:@"btnVideo.png"];
    
    [self takeVideo:nil];
    
    [self stopRecordTime];
}

/*
- (void)encodeMov2Mp4
{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"%@", compatiblePresets);
    
    if ([compatiblePresets containsObject:_mp4Quality])
        
    {
        [self showAlert:@"等待.."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    (SCREEN_WIDTH - 2 * 140),
                                    80);
        _startDate = [NSDate date];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSLog(@"%@", exportSession.supportedFileTypes);
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *_mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
//        exportSession.shouldOptimizeForNetworkUse = _networkOpt;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [self showTimeAlert:@"提示" message:[[exportSession error] localizedDescription]];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        [self showTimeAlert:@"错误" message:@"AVAsset doesn't support mp4 quality"];
    }
}

- (void) convertFinish
{

    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    [self showTimeAlert:@"结束" message:[NSString stringWithFormat:@"转码成功, 花费 %.2fs", duration]];
    
//    _convertTime.text = [NSString stringWithFormat:@"%.2f s", duration];
//    _mp4Size.text = [NSString stringWithFormat:@"%d kb", [self getFileSize:_mp4Path]];
//    _hasMp4 = YES;
}
*/

@end
