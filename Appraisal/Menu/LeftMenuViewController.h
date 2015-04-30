//
//  LeftMenuViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MSPaneLeftViewControllerType) {
    // Left
    JDPGVC,
    JRDDVC,
    UIWebVC,
    UIWebVC1,
    UIWebVC2,
    UIWebVC3,
    MSPaneViewControllerTypeCount,
};

@interface LeftMenuViewController : UITableViewController

@property (nonatomic, assign) MSPaneLeftViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(MSPaneLeftViewControllerType)paneViewControllerType;

- (void)updateCellStateToNormal;
- (void)goHome;

@end
