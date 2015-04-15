//
//  UIImage+MRImageEffects.m
//  MRProgress
//
//  Modified by Marius Rackwitz on 22.10.13.
//  based on:
//  https://developer.apple.com/downloads/download.action?path=wwdc_2013/wwdc_2013_sample_code/ios_uiimageeffects.zip
//

#import "UIImage+MRImageEffects.h"
#import <CoreGraphics/CoreGraphics.h>
//#import <Accelerate/Accelerate.h>


vImage_Buffer vImageBuffer_InitWithCGContext(CGContextRef contextRef) {
    return (vImage_Buffer){
        .width = CGBitmapContextGetWidth(contextRef),
        .height = CGBitmapContextGetHeight(contextRef),
        .rowBytes = CGBitmapContextGetBytesPerRow(contextRef),
        .data = CGBitmapContextGetData(contextRef),
    };
}


@implementation UIImage (MRImageEffects)

- (UIImage *)mr_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    NSAssert(self.size.width > 0 && self.size.height > 0, @"Size must be positive: Both dimensions msut be >= 1.");
    NSAssert(self.CGImage != nil, @"image must be backed by a CGImage.");
    NSAssert(!maskImage || maskImage.CGImage, @"maskImage, if given, must be backed by a CGImage.");
    
    UIImage *image = self;
    const CGRect rect = {CGPointZero, image.size};
    const CGFloat scale = UIScreen.mainScreen.scale;
    
    const BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    const BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
        CGContextRef inputContext = UIGraphicsGetCurrentContext();
        [image drawAtPoint:CGPointZero];
        
        vImage_Buffer inputBuffer = vImageBuffer_InitWithCGContext(inputContext);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
        vImage_Buffer outputBuffer = vImageBuffer_InitWithCGContext(UIGraphicsGetCurrentContext());
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * 1;
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            
            vImageBoxConvolve_ARGB8888(&inputBuffer,  &outputBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&outputBuffer, &inputBuffer,  NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&inputBuffer,  &outputBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            
            // Swap input & output
            vImage_Buffer tempBuffer = inputBuffer;
            inputBuffer = outputBuffer;
            outputBuffer = tempBuffer;
        }
        
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,                    1,
            };
            
            const int32_t divisor = 256;
            
            // Convert saturation matrix from float to int
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            vImageMatrixMultiply_ARGB8888(&inputBuffer, &outputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
        }
        
        if (!hasBlur) {
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        
        if (hasBlur) {
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Draw base image.
    [self drawAtPoint:rect.origin];
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, rect, maskImage.CGImage);
        }
        [image drawAtPoint:rect.origin];
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, rect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//加模糊效果，image是图片，blur是模糊度
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;

    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
//    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
