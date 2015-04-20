//
//  AppDelegate.h
//  MSDynamicsDrawerViewController
//
//  Created by Eric Horacek on 11/20/12.
//  Copyright (c) 2012-2013 Monospace Ltd. All rights reserved.


#import <UIKit/UIKit.h>

// Share
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "AGViewDelegate.h"

@class MSDynamicsDrawerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

// Share
@property (nonatomic, readonly) AGViewDelegate *agViewDelegate;

- (void)loadLogicView;

- (void)resetRightMenuState;
- (void)resetLeftMenuState;

@end
