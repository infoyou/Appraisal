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


typedef NS_ENUM(NSUInteger, VideoShareAlertType) {
    VideoSinaAlertType = 20,
    VideoQQAlertType,
    VideoWeiXinAlertType,
};

// ######################### Share Begin #########################
//新浪微博
#define kSinaAppKey    @"2980000350"
#define kSinaAppSecret @"0092e8fe7462bfeeeab8cb3744317c39"

//QQ&QQ空间
#define kQQAppKey    @"1103963649"
#define kQQAppSecret @"PRziCk9p4qJR1seI"

//微信
#define kWeiXinKey    @"wx0999d9a65c311323"
#define kWeiXinSecret @"9bef7f83ffc4f587bad4bbe299f5eba6"

//ShareSDK平台
#define kShareSDK_Key @"50d277e18231"
// ######################### Share End #########################

@interface GlobalConstants : NSObject {
    
}

@end
