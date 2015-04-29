//
//  UIWebViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "RootViewController.h"

@interface UIWebViewController : RootViewController  <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;


@end
