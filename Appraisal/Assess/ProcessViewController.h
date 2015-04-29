//
//  ProcessViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "RootViewController.h"

@interface ProcessViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoBgView;

@property (weak, nonatomic) IBOutlet UIWebView *mWebView;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorViewBG;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
