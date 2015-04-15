
#import "AppManager.h"

@implementation AppManager {
}

@synthesize webUrl;

// new message number
@synthesize msgNumber;

// User
@synthesize userId;
@synthesize userPswd;
@synthesize userName;
@synthesize userNickName;
@synthesize userEmail;
@synthesize userImageUrl;

@synthesize userMobile;
@synthesize userPoint;
@synthesize userDefaultAddress;
@synthesize userProvince;
@synthesize userCity;

@synthesize status;
@synthesize qpg;
@synthesize qeventname;
@synthesize qcity;

// Product
@synthesize productKeyWord;

@synthesize profileCellNumberDict;

static AppManager *shareInstance = nil;

+ (AppManager *)instance {
    
    @synchronized(self) {
        
        if (nil == shareInstance) {
            shareInstance = [[self alloc] init];
        }
    }
    
    return shareInstance;
}


- (BOOL)loadUser
{
    
    NSString *userIdStr = [self userIdRemembered];
    if (userIdStr != nil && userIdStr.length > 0) {
        
        [AppManager instance].userId = userIdStr;
        [AppManager instance].userName = [self userNameRemembered];
        [AppManager instance].userNickName = [self nickNameRemembered];
        [AppManager instance].userImageUrl = [self avatorRemembered];
        [AppManager instance].userPoint = [self pointRemembered];
        
        return YES;
    } else {
        
        [AppManager instance].userId = @"";
        [AppManager instance].userName = @"";
        [AppManager instance].userNickName = @"";
        [AppManager instance].userImageUrl = @"";
        [AppManager instance].userPoint = @"";
        
        return NO;
    }
}

- (NSString *) userIdRemembered {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (NSString *) userNameRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

- (NSString *) nickNameRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
}

- (NSString *) avatorRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avator"];
}

- (NSString *) pointRemembered
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"point"];
}

- (void)saveUserData:(NSString *)aUserId
                userName:(NSString *)aUserName
                nickName:(NSString *)aNickName
                  avator:(NSString *)avator
                   point:(NSString *)aPoint
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if(userId == nil) {
        
        [_def removeObjectForKey:@"userId"];
        [_def removeObjectForKey:@"userName"];
        [_def removeObjectForKey:@"nickName"];
        [_def removeObjectForKey:@"avator"];
        [_def removeObjectForKey:@"point"];
    } else {
        
        [_def setObject:aUserId forKey:@"userId"];
        [_def setObject:aUserName forKey:@"userName"];
        [_def setObject:aNickName forKey:@"nickName"];
        [_def setObject:avator forKey:@"avator"];
        [_def setObject:aPoint forKey:@"point"];
    }
    
    [_def synchronize];
}

- (void)saveQuestionData:(NSString *)resultId resultMsg:(NSString *)resultMsg
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:resultMsg forKey:resultId];
    [_def synchronize];
}

- (void)saveQuestionDataIndex:(NSString *)result
{
    
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if ([self getResultIds].length > 0) {
        NSString *resultMsg = [NSString stringWithFormat:@"%@#%@", [self getResultIds], result];
        [_def setObject:resultMsg forKey:@"resultId"];
    } else {
        [_def setObject:result forKey:@"resultId"];
    }
    
    [_def synchronize];
}

- (NSString *)getResultIds
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"resultId"];
}

@end
