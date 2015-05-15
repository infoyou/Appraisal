
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
    
    //-------------------------------assess cache-----------------------------
    
	NSString *createUserTableMsg = @"create table if not exists assess ( assessId TEXT PRIMARY KEY, logicId TEXT, logicType int, assessType int, attachType int, fileName TEXT, pawnPrice TEXT,  marketPrice TEXT,  usedPrice TEXT,  mark1 TEXT,  mark2 TEXT,  mark3 TEXT, mark4 TEXT, mark5 TEXT,  mark6 TEXT,  mark7 TEXT,  mark8 TEXT, mark9 TEXT,  mark10 TEXT )";
    
    res = [self.db executeUpdate:createUserTableMsg];
    
	if (!res) {
        DLog(@"error when creating assess table");
    } else {
        DLog(@"success to creating assess table");
    }
}
//------------------------------------------------------------

// ------------------------ User start -------------------------------
    
#pragma mark - do business action
- (void)insertAssessObjectDB:(AssessObject *)surveyInfo
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    static NSString *sql = @"INSERT INTO assess VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)";
    
    @try
    {
            NSArray *argumentsArray = [[NSArray alloc] initWithObjects:surveyInfo.assessId,
                                       surveyInfo.logicId,
                                       surveyInfo.logicType,
                                       surveyInfo.assessType,
                                       surveyInfo.attachType,
                                       surveyInfo.fileName == nil ? @"" : surveyInfo.fileName,
                                       surveyInfo.pawnPrice == nil ? @"" : surveyInfo.pawnPrice,
                                       surveyInfo.marketPrice == nil ? @"" : surveyInfo.marketPrice,
                                       surveyInfo.usedPrice == nil ? @"" : surveyInfo.usedPrice,
                                       surveyInfo.mark1 == nil ? @"" : surveyInfo.mark1,
                                       surveyInfo.mark2 == nil ? @"" : surveyInfo.mark2,
                                       surveyInfo.mark3 == nil ? @"" : surveyInfo.mark3,
                                       surveyInfo.mark4 == nil ? @"" : surveyInfo.mark4,
                                       surveyInfo.mark5 == nil ? @"" : surveyInfo.mark5,
                                       surveyInfo.mark6 == nil ? @"" : surveyInfo.mark6,
                                       surveyInfo.mark7 == nil ? @"" : surveyInfo.mark7,
                                       surveyInfo.mark8 == nil ? @"" : surveyInfo.mark8,
                                       surveyInfo.mark9 == nil ? @"" : surveyInfo.mark9,
                                       surveyInfo.mark10 == nil ? @"" : surveyInfo.mark10,
                                       nil];
            
            BOOL res = [self.db executeUpdate:sql
                         withArgumentsInArray:argumentsArray];
            
            if (!res) {
                DLog(@"insert assess error !");
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
- (void)insertAllAssessObjectDB:(NSArray *)userList
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    AssessObject *surveyInfo = nil;
    static NSString *sql = @"INSERT INTO assess VALUES(?,?,?,?,?, ?,?,?,?,?)";
    
    @try
    {
        
        for (int i = 0; i < userList.count; i++) {
            surveyInfo = [userList objectAtIndex:i];
            
            
            NSArray *argumentsArray = [[NSArray alloc] initWithObjects:surveyInfo.assessId,
                                       surveyInfo.logicId,
                                       surveyInfo.logicType,
                                       surveyInfo.assessType,
                                       surveyInfo.mark1,
                                       surveyInfo.mark2,
                                       surveyInfo.mark3,
                                       surveyInfo.mark4,
                                       surveyInfo.mark5,
                                       surveyInfo.mark6,
                                       surveyInfo.mark7,
                                       surveyInfo.mark8,
                                       surveyInfo.mark9,
                                       surveyInfo.mark10,
                                       nil];
            
            BOOL res = [self.db executeUpdate:sql
                         withArgumentsInArray:argumentsArray];
            
            if (!res) {
                DLog(@"insert assess error !");
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
- (void)updateAssessObjectDB:(AssessObject *)surveyInfo
{
    [self.db beginTransaction];
    BOOL isRoolBack = NO;
    
    static NSString *sql = @"update assess set assessId=?, user=?, city=?, phone=?, projectcode=?, remark=?, status=? where assessId = ?";
    
    @try
    {
            
        BOOL res = [self.db executeUpdate:sql
                     withArgumentsInArray:@[surveyInfo.assessId,
                                            surveyInfo.logicId,
                                            surveyInfo.mark1,
                                            surveyInfo.mark2,
                                            surveyInfo.mark3,
                                            surveyInfo.mark4,
                                            surveyInfo.mark5,
                                            surveyInfo.mark6,
                                            [NSNumber numberWithInteger:surveyInfo.logicType],
                                            surveyInfo.assessId]];
        
        if (!res) {
            DLog(@"update assess error!");
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

- (AssessObject *)getAllSurveyDataFromDB
{
    AssessObject *AssessObject = nil;
    
    NSString *sql = @" select * from assess where status != -1 ";
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        //        AssessObject = [[self parseAssessInfo:res] retain];
        AssessObject = [self parseAssessInfo:res];
    }
    
    return AssessObject;
}

- (AssessObject *)getAssessRecordById:(NSString *)assessId {
    
    AssessObject *backVal = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select * from assess where assessId == '%@'", assessId];
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        backVal = [self parseAssessInfo:res];
    }
    
    return backVal;
}

- (NSMutableArray *)getAssessRecordArrayByLogicType:(NSInteger)logicType {

    NSMutableArray *assessArray = [NSMutableArray array];

    NSString *sql = [NSString stringWithFormat:@"select * from assess where assessType == %d order by assessId desc", logicType];
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        [assessArray addObject:[self parseAssessInfo:res]];
    }
    
    return assessArray;
}

- (NSMutableArray *)getUserEmailByKeyword:(NSString *)assessId {
    
    NSMutableArray *surveyArray = [NSMutableArray array];
    
//    NSString *sql = [NSString stringWithFormat:@"select * from assess where userEmail like '%@%%'", keyword];
    NSString *sql = [NSString stringWithFormat:@"select * from assess where assessId like '%@'", assessId];
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        [surveyArray addObject:[res stringForColumn:@"status"]];
    }
    
    return surveyArray;
}

- (AssessObject *)parseAssessInfo:(FMResultSet *)res
{
    
    AssessObject *assessInfo = [[AssessObject alloc] init];
    
    assessInfo.assessId = [res stringForColumn:@"assessId"];
    assessInfo.logicId = [res stringForColumn:@"logicId"];
    assessInfo.logicType = [res intForColumn:@"logicType"];
    assessInfo.assessType = [res intForColumn:@"assessType"];
    
    assessInfo.attachType = [res intForColumn:@"attachType"];
    assessInfo.fileName = [res stringForColumn:@"fileName"];
    assessInfo.pawnPrice = [res stringForColumn:@"pawnPrice"];
    assessInfo.marketPrice = [res stringForColumn:@"marketPrice"];
    assessInfo.usedPrice = [res stringForColumn:@"usedPrice"];
    
    assessInfo.mark1 = [res stringForColumn:@"mark1"];
    assessInfo.mark2 = [res stringForColumn:@"mark2"];
    assessInfo.mark3 = [res stringForColumn:@"mark3"];
    assessInfo.mark4 = [res stringForColumn:@"mark4"];
    assessInfo.mark5 = [res stringForColumn:@"mark5"];
    assessInfo.mark6 = [res stringForColumn:@"mark6"];
    assessInfo.mark7 = [res stringForColumn:@"mark7"];
    assessInfo.mark8 = [res stringForColumn:@"mark8"];
    assessInfo.mark9 = [res stringForColumn:@"mark9"];
    assessInfo.mark10 = [res stringForColumn:@"mark10"];
    
    return assessInfo;
}

- (void)delUserTable {
    
    NSString *sql = @"delete from assess";
    FMResultSet *res = [self.db executeQuery:sql];
    
    if ([res next]) {
    }
}

- (NSString *)getAvailableSurveyResult
{
    
    NSMutableString *totalStr = [NSMutableString string];
    
    NSString *sql = [NSString stringWithFormat:@"select * from assess where status != -1"];
    FMResultSet *res = [self.db executeQuery:sql];
    NSInteger index = 0;
    
    while ([res next]) {
        
        AssessObject *assessObject = [[AssessObject alloc] init];
        
        assessObject.logicType = [res intForColumn:@"logicType"];
        assessObject.assessId = [res stringForColumn:@"assessId"];
        
        [totalStr appendFormat:@"status=%ld&q_id=%@##", (long)assessObject.logicType, assessObject.assessId];
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
