//
//  FMDBConnection.h
//  Project
//
//  Created by Adam on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FMDatabase.h"
#import "FMResultSet.h"

// Business Object
#import "AssessObject.h"


@interface FMDBConnection : NSObject

+ (FMDBConnection *)instance;

@property (nonatomic, retain) FMDatabase *db;

- (void)setup;
- (BOOL)openDB;
- (BOOL)closeDB;

#pragma mark - user
- (void)insertAssessObjectDB:(AssessObject *)surveyInfo;
- (void)insertAllAssessObjectDB:(NSArray *)userList;

- (NSMutableArray *)getAssessRecordArrayByLogicType:(NSInteger)logicType;
- (AssessObject *)getAssessRecordById:(NSString *)assessId;


- (void)delUserTable;
- (void)updateAssessObjectDB:(AssessObject *)userInfo;
- (AssessObject *)getAllSurveyDataFromDB;
- (NSString *)getAvailableSurveyResult;

@end
