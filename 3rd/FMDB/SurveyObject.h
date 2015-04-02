//
//  SurveyObject.h
//  Project
//
//  Created by Adam on 14-5-27.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyObject : NSObject

@property (nonatomic, copy) NSString *surveyId;

@property (nonatomic, copy) NSString *projectcode;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *remark;

@end
