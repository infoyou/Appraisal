//
//  GlobalConstants.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#define VERSION         @"1.0.1"

#define UMENG_ANALYS_APP_KEY        @"5515104ffd98c502c70005e1"

#define PROJECT_DB_NAME             @"ProjectDB"

#define PROJECT_CODE                @"2015brandexp"
#define SUBMIT_URL_PATH             @"http://58.68.246.100/club/data_receiver.action?"

//  0,不可以编辑; 1,可以编辑;
#define ADMIN_CAN_EDIT_FLAG         @"0"

#define ORIGINAL_MAX_WIDTH          640.0f

#define DEGREES_TO_RADIANS(d)       (d * M_PI / 180)

@interface GlobalConstants : NSObject {
    
}

@end
