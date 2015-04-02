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
#import "SurveyObject.h"


@interface FMDBConnection : NSObject

+ (FMDBConnection *)instance;

@property (nonatomic, retain) FMDatabase *db;

- (void)setup;
- (BOOL)openDB;
- (BOOL)closeDB;

#pragma mark - user
- (void)insertSurveyObjectDB:(SurveyObject *)surveyInfo;
- (void)insertAllSurveyObjectDB:(NSArray *)userList;
- (void)updateRepeatSurveyObjectDB:(SurveyObject *)surveyInfo;

- (void)updateSurveyStatus:(NSString *)surveyId status:(NSString *)status;
- (void)recoverySurveyStatus:(NSString *)aProjectcode user:(NSString *)aUser phone:(NSString *)aPhone;

- (NSMutableArray *)getUserByNameKeyword:(NSString *)keyword;
- (NSMutableArray *)getUserEmailByKeyword:(NSString *)keyword;
- (void)delUserTable;
- (void)updateSurveyObjectDB:(SurveyObject *)userInfo;
- (SurveyObject *)getAllSurveyDataFromDB;
- (NSString *)getAvailableSurveyResult;
- (NSString *)getNeedSubmitSurveyResult;

@end
