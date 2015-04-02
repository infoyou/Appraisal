//
//  JDPGHomeViewController.h
//  Example
//


#import "RootViewController.h"

@interface JDPGHomeViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (weak, nonatomic) IBOutlet UIView *tapPhotoView;

@property (weak, nonatomic) IBOutlet UIView *tapScanningView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

@property (weak, nonatomic) IBOutlet UIImageView *scanningImg;

@end
