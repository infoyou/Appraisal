//
//  UIImage+MRImageEffects.h
//  MRProgress
//
//  Modified by Marius Rackwitz on 22.10.13.
//  based on:
//  https://developer.apple.com/downloads/download.action?path=wwdc_2013/wwdc_2013_sample_code/ios_uiimageeffects.zip
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

/**
 Helper to apply effects to images.
 */
@interface UIImage (MRImageEffects)

/**
 Blur, tint and change saturation of CGImage-backed receiver
 
 @param blurRadius The Gaussian radius which specifies the blur intensity. No blur is applied, if you specify 0 as
 value.
 @param tintColor The tint color to apply in last step to the result image. (optional)
 @param saturationDeltaFactor A value above 0.0 and below 1.0 desaturate the result image, which means the colorfulness
 will be reduced. A value above 1.0 increase the saturation. Specify 1.0 to do not apply a saturation change.
 @param maskImage CGImage-backed mask that specify which part of the result image should not be blured. (optional)
 */
- (UIImage *)mr_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
