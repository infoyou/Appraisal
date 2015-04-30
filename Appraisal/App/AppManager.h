
/*!
 @header AppManager.h
 @abstract 系统内存
 @author Adam
 @version 1.00 2015/3/11 Creation
 */

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@interface AppManager : NSObject {
    
}

@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, copy) NSString *msgNumber;

// User
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userPswd;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *userPoint;
@property (nonatomic, copy) NSString *userDefaultAddress;
@property (nonatomic, copy) NSString *userProvince;
@property (nonatomic, copy) NSString *userCity;
@property (nonatomic, copy) NSString *userImageUrl;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *qpg;
@property (nonatomic, copy) NSString *qeventname;
@property (nonatomic, copy) NSString *qcity;

// Product
@property (nonatomic, copy) NSString *productKeyWord;

@property (nonatomic, retain) NSDictionary *profileCellNumberDict;

@property (nonatomic, assign) LogicType logicType;
@property (nonatomic, assign) BabyType babyType;
// 标的物记录号
@property (nonatomic, copy) NSString *objectRecordId;

// 图片信息 [image]
@property (nonatomic, retain) NSMutableArray *objectAttachmentFileNameArray;
@property (nonatomic, retain) NSMutableArray *objectUploadImgIdArray;

// 视频信息 [video]
@property (nonatomic, copy) NSString *objectVideoFileName;
@property (nonatomic, copy) NSString *objectUploadVideoId;

// 位置信息
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

//是否发表评论
@property (nonatomic) BOOL isUserComment;

+ (AppManager *)instance;

- (BOOL)loadUser;

- (void)saveUserData:(NSString *)aUserId
            userName:(NSString *)aUserName
            nickName:(NSString *)aNickName
              avator:(NSString *)avator
               point:(NSString *)aPoint;


- (void)saveQuestionData:(NSString *)resultId resultMsg:(NSString *)resultMsg;
- (void)saveQuestionDataIndex:(NSString *)result;
- (NSString *)getResultIds;
- (void)prepareData;

@end
