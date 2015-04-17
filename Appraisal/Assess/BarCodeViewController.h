//
//  BarCodeViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
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

