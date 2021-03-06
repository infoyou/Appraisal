//
//  RootViewController
//  WebviewDemo
//
//  Created by Adam on 15/3/11.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MobClick.h"

#import "AppDelegate.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "FMDBConnection.h"
#import "Reachability.h"

#import "HYActivityView.h"
#import <CoreLocation/CoreLocation.h>

#import "HttpRequestData.h"
#import "UIViewController+ToastMessage.h"

#import "CommonUtils.h"
#import "StringCategory.h"

@interface RootViewController : UIViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate>
{

}

// Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

// Share
@property (nonatomic, strong) HYActivityView *activityView;

// activity indicator
@property (nonatomic, strong) UIView *activityIndicatorViewBG;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (BOOL) isConnectionAvailable;

#pragma mark - adjust view
- (void)adjustView;

#pragma mark - image for gesture
- (void)addTapGestureRecognizer:(UIView *)targetView;
- (void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

#pragma mark - show Alert
- (void)showAlert:(NSString*)infoStr;

#pragma mark - 定时 Alert
- (void)showTimeAlert:(NSString*)title message:(NSString*)message;

- (void)initAllSharePlat;

#pragma mark - push view controller
- (void)pushViewController:(UIViewController *)targetVC;

#pragma mark - activity indicator view
- (void)addActivityIndicatorView;
- (void)showActivityIndicatorView;
- (void)closeActivityIndicatorView;

@end

