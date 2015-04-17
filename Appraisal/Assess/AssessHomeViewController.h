//
//  AssessHomeViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "RootViewController.h"

@interface AssessHomeViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (weak, nonatomic) IBOutlet UIView *tapPhotoView;

@property (weak, nonatomic) IBOutlet UIView *tapScanningView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

@property (weak, nonatomic) IBOutlet UIImageView *scanningImg;

@end
