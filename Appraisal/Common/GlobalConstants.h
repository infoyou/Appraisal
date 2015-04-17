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

#define GET_METHOD                  @"GET"
#define POST_METHOD                 @"POST"

#define HOST_URL                    @"http://115.29.161.226:85/weixin/jsonapi"

// ######################### Share Begin #########################

typedef NS_ENUM(NSUInteger, VideoShareAlertType) {
    SYSTEM_SETTING_TYPE,
    VideoSinaAlertType = 20,
    VideoQQAlertType,
    VideoWeiXinAlertType,
};

//新浪微博
#define kSinaAppKey    @"833420512" //@"2980000350"
#define kSinaAppSecret @"149e2b750482249ad4195fdeeaa1d035" //@"0092e8fe7462bfeeeab8cb3744317c39"

//QQ&QQ空间
#define kQQAppKey     @"1103963649"
#define kQQAppSecret  @"PRziCk9p4qJR1seI"

//微信
#define kWeiXinKey    @"wx786e4023e0972b2e"
#define kWeiXinSecret @"845408466861c80e84276323fa3ccce3"

//ShareSDK平台
#define kShareSDK_Key @"6a46cccf1e16"

// ######################### Share End #########################

// 标的物操作模式
typedef NS_ENUM(NSUInteger, LogicType) {
    ASSESS_LOGIC_TYPE = 0,
    PAWN_LOGIC_TYPE,
};

// 标的物类型
typedef NS_ENUM(NSUInteger, BabyType) {
    JADE_TYPE = 0, //玉石
    ARTWORK_TYPE, //艺术品
    GEM_TYPE,//宝石
    GOLD_TYPE,//金饰品
    WATCH_TYPE,//手表
    AUTO_TYPE,//机动车
    DIAMOND_TYPE,//钻石
    REAL_ESTATE_TYPE,//房地产
};

typedef NS_ENUM(NSUInteger, AttachmentType) {
    INPUT_PHOTO_TYPE = 0,       // 照片模式
    INPUT_VIDEO_TYPE,           // 摄像模式
};

@interface GlobalConstants : NSObject {
    
}


@end
