//
//  RightMenuViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

//#import "LeftMenuViewController.h"

typedef NS_ENUM(NSUInteger, MSPaneRightViewControllerType) {
    
    // Right
    DDJLVC,
    JDPGJLVC,
    AboutVC,
    MSLeftPaneViewControllerTypeCount,
};

@interface RightMenuViewController : UITableViewController

@property (nonatomic, assign) MSPaneRightViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(MSPaneRightViewControllerType)paneViewControllerType;

- (void)updateCellStateToNormal;

@end
