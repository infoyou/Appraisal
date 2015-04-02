//
//  LeftMenuViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MSPaneViewControllerType) {
    JDPGVC,
    JRDDVC,
    UIWebVC,
    UIWebVC1,
    UIWebVC2,
    MSPaneViewControllerTypeCount
};

@interface LeftMenuViewController : UITableViewController

@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType;

@end
