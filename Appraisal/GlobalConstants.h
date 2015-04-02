//
//  GlobalConstants.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#define VERSION         @"1.0.1"

#ifdef DEBUG
#    define DLog(...)     NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif

#define UMENG_ANALYS_APP_KEY        @"5515104ffd98c502c70005e1"

#define PROJECT_DB_NAME             @"ProjectDB"

#define PROJECT_CODE                @"2015brandexp"
#define SUBMIT_URL_PATH             @"http://58.68.246.100/club/data_receiver.action?"

//  0,不可以编辑; 1,可以编辑;
#define ADMIN_CAN_EDIT_FLAG         @"0"

#define SCREEN_WIDTH                ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT               ([[UIScreen mainScreen] bounds].size.height)

#define ORIGINAL_MAX_WIDTH          640.0f

#define DEGREES_TO_RADIANS(d)       (d * M_PI / 180)

@interface GlobalConstants : NSObject {
    
}

@end
