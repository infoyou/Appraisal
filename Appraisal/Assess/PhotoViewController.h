//
//  PhotoViewController.h
//  Example
//
//  Created by Eric Horacek on 10/19/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "PagedFlowView.h"
#import "AVCamPreviewView.h"

@interface PhotoViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoBgView;

// Capture view
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;

@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;

@property (weak, nonatomic) IBOutlet UIImageView *cameraImgView;

// Action view
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIImageView *promptNoteImg;

@property (weak, nonatomic) IBOutlet UIImageView *takePhotoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *doneBtn;

@property (nonatomic, retain) IBOutlet PagedFlowView *typeFlowView;

// Result view
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *delVideoScreenShotView;
@property (weak, nonatomic) IBOutlet UIImageView *videoScreenShotView;
@property (weak, nonatomic) IBOutlet UIImageView *videoScreenShotBoardView;

@property (weak, nonatomic) IBOutlet UIImageView *resultTextImg;
@property (weak, nonatomic) IBOutlet UIImageView *resultRightImg;
@property (weak, nonatomic) IBOutlet UIImageView *resultLeftImg;
@property (weak, nonatomic) IBOutlet UIImageView *resultDoneBtn;

@property (weak, nonatomic) IBOutlet UIImageView *resultTakePhoto;

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

@end
