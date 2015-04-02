//
//  BarCodeViewController.h
//  Aladdin
//
//  Created by Adam on 14-12-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "ZBarSDK.h"

@interface BarCodeViewController : RootViewController < ZBarReaderViewDelegate >
{
    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
}

@property (nonatomic,strong) ZBarReaderView *readerView;

@end

