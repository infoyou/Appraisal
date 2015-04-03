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

@interface RootViewController : UIViewController <UIGestureRecognizerDelegate>
{

}

@property (nonatomic, retain) NSMutableData *myData;

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

@end

