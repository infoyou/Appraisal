//
//  HttpRequestData.h
//  ADianIPhone
//
//  connection by ASIFormDataRequest
//
//  Created by Adam on 14/12/5.
//  Copyright (c) 2014年 5adian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestData : NSObject

+ (void)dataWithDic:(NSMutableDictionary *)dic
        requestType:(NSString *)requestType
          serverUrl:(NSString *)serverUrl
           andBlock:(void(^)(NSString *requestStr))block;

+ (NSMutableDictionary *)jsonValue:(NSString *)str;

@end