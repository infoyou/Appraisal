
#import "FMDBConnection.h"
#import "GlobalConstants.h"
#import "AppManager.h"

static FMDBConnection *instance = nil;

@implementation FMDBConnection

#pragma mark - singleton method

// 获取一个instance实例，如果有必要的话，实例化一个
+ (FMDBConnection *)instance {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

// 当第一次使用这个单例时，会调用这个init方法。
- (id)init
{
    self = [super init];
    
    if (self) {
        // 通常在这里做一些相关的初始化任务
        [self setup];
    }
    
    return self;
}

// 这个dealloc方法永远都不会被调用--因为在程序的生命周期内容，该单例一直都存在。（所以该方法可以不用实现）
- (void)dealloc
{
    
}

// 通过返回当前的instance实例，就能防止实例化一个新的对象。
+ (id)allocWithZone:(NSZone*)zone {
    return [self instance];
}

// 同样，不希望生成单例的多个拷贝。
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - init db
- (NSString *)documentsDirectory {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)getDBPath:(NSString *)dbFileName {
    
	NSString *docDir = [self documentsDirectory];
	NSString *dbPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_V%@.sqlite", dbFileName, VERSION]];
	return dbPath;
}

- (void)setup {
    if (self.db == nil) {
        self.db = [FMDatabase databaseWithPath:[self getDBPath:PROJECT_DB_NAME]];
    }
    
    if ([self openDB]) {
        [self createTables];
    }
}

- (BOOL)openDB {
    return [self.db open];
}

- (BOOL)closeDB {
    return [self.db close];
}


- (void)createTables {
	
    BOOL res = NO;
    
    //-------------------------------survey cache-----------------------------
    /*
     qname=BD&qgender=男&qemail=&qdealerprovince=河南&qdealercity=郑州&qdealer=河南天道汽车贸易服务有限公司&importdate=2015-3-18 5:18:11&q1=福特新蒙迪欧&q2=&q3=一年以上&q4=15-20万&q5=否&qknowctcc=&qwhichcity=&qwhichyear=&qwhetherlook=&qwhetherinfo=&qfordinterested2=特翼搏&projectcode=2015ecodriving&q_id=1426627098&qeventname=2015长安福特安全节能驾驶训练营&qmobile=13678987890'&qcity=上海&qpg=F8&status=1
     */
    
	NSString *createUserTableMsg = @"create table if not exists survey (surveyId TEXT PRIMARY KEY,    user TEXT,     city TEXT,  phone TEXT,     projectcode TEXT,   remark TEXT,    status int)";
    
    res = [self.db executeUpdate:createUserTableMsg];
	if (!res) {
        DLog(@"error when creating survey table");
    } else {
        DLog(@"success to creating survey table");
    }
}
    //------------------------------------------------------------

// ------------------------ User start -------------------------------
    
/*
 qname=BD&qgender=男&qemail=&qdealerprovince=河南&qdealercity=郑州&qdealer=河南天道汽车贸易服务有限公司&importdate=2015-3-18 5:18:11&q1=福特新蒙迪欧&q2=&q3=一年以上&q4=15-20万&q5=否&qknowctcc=&qwhichcity=&qwhichyear=&qwhetherlook=&qwhetherinfo=&qfordinterested2=特翼搏&projectcode=2015ecodriving&q_id=1426627098&qeventname=2015长安福特安全节能驾驶训练营&qmobile=13678987890'&qcity=上海&qpg=F8&status=1
 */

//    @property (nonatomic, copy) NSString *surveyId;
//    @property (nonatomic, copy) NSString *user;
//    @property (nonatomic, copy) NSString *city;
//    @property (nonatomic, copy) NSString *phone;
//    @property (nonatomic, copy) NSString *projectcode;
//    @property (nonatomic, copy) NSString *remark;
//    @property (nonatomic, copy) NSString *status;
    
#pragma mark - do business action
- (void)insertSurveyObjectDB:(SurveyObject *)surveyInfo
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    static NSString *sql = @"INSERT INTO survey VALUES(?,?,?,?,?,?,?)";
    
    @try
    {
            NSArray *argumentsArray = [[NSArray alloc] initWithObjects:surveyInfo.surveyId,
                                       surveyInfo.user,
                                       surveyInfo.city,
                                       surveyInfo.phone,
                                       surveyInfo.projectcode,
                                       surveyInfo.remark,
                                       surveyInfo.status,
                                       nil];
            
            BOOL res = [self.db executeUpdate:sql
                         withArgumentsInArray:argumentsArray];
            
            if (!res) {
                DLog(@"insert survey error !");
            }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

#pragma mark - do business action
- (void)insertAllSurveyObjectDB:(NSArray *)userList
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    SurveyObject *surveyInfo = nil;
    static NSString *sql = @"INSERT INTO survey VALUES(?,?,?,?,?,?,?)";
    
    @try
    {
        
        for (int i = 0; i < userList.count; i++) {
            surveyInfo = [userList objectAtIndex:i];
            
            
            NSArray *argumentsArray = [[NSArray alloc] initWithObjects:surveyInfo.surveyId,
                                       surveyInfo.user,
                                       surveyInfo.city,
                                       surveyInfo.phone,
                                       surveyInfo.projectcode,
                                       surveyInfo.remark,
                                       surveyInfo.status,
                                       nil];
            
            BOOL res = [self.db executeUpdate:sql
                         withArgumentsInArray:argumentsArray];
            
            if (!res) {
                DLog(@"insert survey error !");
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

#pragma mark - update business action
- (void)updateSurveyObjectDB:(SurveyObject *)surveyInfo
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    static NSString *sql = @"update survey set surveyId=?, user=?, city=?, phone=?, projectcode=?, remark=?, status=? where surveyId = ?";
    
    @try
    {
            
        BOOL res = [self.db executeUpdate:sql
                     withArgumentsInArray:@[surveyInfo.surveyId,
                                            surveyInfo.user,
                                            surveyInfo.city,
                                            surveyInfo.phone,
                                            surveyInfo.projectcode,
                                            surveyInfo.remark,
                                            [NSNumber numberWithInteger:surveyInfo.status],
                                            surveyInfo.surveyId]];
        
        if (!res) {
            DLog(@"update survey error!");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

- (void)updateRepeatSurveyObjectDB:(SurveyObject *)surveyInfo
{
    if ([self getRepeatSurveyNum:surveyInfo] < 2) {
        
        NSLog(@"No found repeat data.");
        return;
    }
    
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    static NSString *sql = @"update survey set status=? where projectcode = ? and user = ? and phone = ? and status != 1";
    
    @try
    {
        
        BOOL res = [self.db executeUpdate:sql
                     withArgumentsInArray:@[@"2",
                                            surveyInfo.projectcode,
                                            surveyInfo.user,
                                            surveyInfo.phone]];
        
        if (!res) {
            DLog(@"update survey error!");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

- (void)recoverySurveyStatus:(NSString *)aProjectcode user:(NSString *)aUser phone:(NSString *)aPhone
{
    if ([self getRepeatSurveyNum:aProjectcode user:aUser phone:aPhone] > 1) {
        return;
    }
    
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    // 恢复“重”数据状态
    static NSString *sql = @"update survey set status=? where projectcode = ? and user = ? and phone = ? and status != 1 and status != -1 ";
    
    @try
    {
        
        BOOL res = [self.db executeUpdate:sql
                     withArgumentsInArray:@[@"0",
                                            aProjectcode,
                                            aUser,
                                            aPhone]];
        
        if (!res) {
            DLog(@"update survey error!");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

/**
 *
 *  status
 *      -1,删除;  0,未上传;   1,已上传;   2,重复;
 */
- (void)updateSurveyStatus:(NSString *)surveyId status:(NSString *)status
{
    
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    NSString *sql = @"update survey set status =? where surveyId = ?";
    
    int intStatus = [status intValue];
    if (intStatus == 0) {
        
        sql = @"update survey set status=? where surveyId = ? and status != 2";
    }
    
    @try
    {
        
        BOOL res = [self.db executeUpdate:sql
                     withArgumentsInArray:@[status,
                                            surveyId]];
        
        if (!res) {
            DLog(@"update survey error!");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
        
        isRoolBack = YES;
        [self.db rollback];
    }
    @finally
    {
        if (!isRoolBack) {
            [self.db commit];
        }
    }
}

- (NSInteger)getRepeatSurveyNum:(SurveyObject *)surveyInfo
{
    
    return [self getRepeatSurveyNum:surveyInfo.projectcode user:surveyInfo.user phone:surveyInfo.phone];
}

- (NSInteger)getRepeatSurveyNum:(NSString *)aProjectcode user:(NSString *)aUser phone:(NSString *)aPhone
{
    
    NSInteger backVal = 0;
    
    NSString *sql = @"select * from survey where projectcode = ? and user = ? and phone = ? and status != -1";
    FMResultSet *res = [self.db executeQuery:sql, aProjectcode, aUser, aPhone];
    
    while ([res next]) {
        backVal ++;
    }
    
    return backVal;
}

- (SurveyObject *)getAllSurveyDataFromDB
{
    SurveyObject *surveyObject = nil;
    
    NSString *sql = @" select * from survey where status != -1 ";
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        //        surveyObject = [[self parseSurveyInfo:res] retain];
        surveyObject = [self parseSurveyInfo:res];
    }
    
    return surveyObject;
}

- (NSMutableArray *)getUserByNameKeyword:(NSString *)keyword {

    NSMutableArray *surveyArray = [NSMutableArray array];

    NSString *sql = [NSString stringWithFormat:@"select * from survey where status != -1"];
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        [surveyArray addObject:[self parseSurveyInfo:res]];
    }
    
    return surveyArray;
}

- (NSMutableArray *)getUserEmailByKeyword:(NSString *)surveyId {
    
    NSMutableArray *surveyArray = [NSMutableArray array];
    
//    NSString *sql = [NSString stringWithFormat:@"select * from survey where userEmail like '%@%%'", keyword];
    NSString *sql = [NSString stringWithFormat:@"select * from survey where surveyId like '%@'", surveyId];
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        [surveyArray addObject:[res stringForColumn:@"status"]];
    }
    
    return surveyArray;
}

- (SurveyObject *)parseSurveyInfo:(FMResultSet *)res
{
    
    SurveyObject *surveyObject = [[SurveyObject alloc] init];
    
    surveyObject.surveyId = [res stringForColumn:@"surveyId"];
    surveyObject.user = [res stringForColumn:@"user"];
    surveyObject.city = [res stringForColumn:@"city"];
    surveyObject.phone = [res stringForColumn:@"phone"];
    surveyObject.projectcode = [res stringForColumn:@"projectcode"];
    surveyObject.remark = [res stringForColumn:@"remark"];
    surveyObject.status = [res intForColumn:@"status"];
    
    return surveyObject;
}

- (void)delUserTable {
    
    NSString *sql = @"delete from survey";
    FMResultSet *res = [self.db executeQuery:sql];
    
    if ([res next]) {
    }
}

//- (NSString *)getSurveyResult0
//{
//    NSArray *resultIdArray = [[self getResultIds] componentsSeparatedByString:@"#"];
//    
//    NSUInteger resultCount = [resultIdArray count];
//    
//    NSMutableString *totalStr = [NSMutableString string];
//    for (int i=0; i<resultCount; i++) {
//        NSString *resultStr = [[NSUserDefaults standardUserDefaults] objectForKey:resultIdArray[i]];
//        [totalStr appendString:resultStr];
//        
//        if (i != resultCount-1) {
//            [totalStr appendString:@"##"];
//        }
//    }
//    
//    return totalStr;
//}

- (NSString *)getAvailableSurveyResult
{
    
    NSMutableString *totalStr = [NSMutableString string];
    
    NSString *sql = [NSString stringWithFormat:@"select * from survey where status != -1"];
    FMResultSet *res = [self.db executeQuery:sql];
    NSInteger index = 0;
    
    while ([res next]) {
        
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        
        surveyObject.remark = [res stringForColumn:@"remark"];
        surveyObject.status = [res intForColumn:@"status"];
        surveyObject.surveyId = [res stringForColumn:@"surveyId"];
        
        [totalStr appendFormat:@"%@&status=%ld&q_id=%@##", surveyObject.remark, (long)surveyObject.status, surveyObject.surveyId];
        index ++;
    }
    
    if (index > 0) {
        return totalStr;
    } else {
        return @"";
    }
    
    return totalStr;
}

- (NSString *)getNeedSubmitSurveyResult
{
    
    NSMutableString *totalStr = [NSMutableString string];
    
    NSString *sql = [NSString stringWithFormat:@"select * from survey where status == 0 or status == 2"];
    FMResultSet *res = [self.db executeQuery:sql];
    NSInteger index = 0;
    
    while ([res next]) {
        
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        
        surveyObject.remark = [res stringForColumn:@"remark"];
        surveyObject.surveyId = [res stringForColumn:@"surveyId"];
        
        [totalStr appendFormat:@"%@&q_id=%@##", surveyObject.remark, surveyObject.surveyId];
        index ++;
    }
    
    if (index > 0) {
        return totalStr;
    } else {
        return @"";
    }
    
    return totalStr;
}

// ------------------------ User end -------------------------------

@end
