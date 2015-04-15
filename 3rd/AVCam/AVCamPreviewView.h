/*
 File: AVCamPreviewView.m
 Abstract: Application preview view.
 Version: 3.1
 */

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface AVCamPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
