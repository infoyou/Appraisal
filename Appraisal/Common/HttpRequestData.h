//
//  HttpRequestData.h
//
//  Created by Adam on 15/4/5.
//  All rights reserved.
//
#import <Foundation/Foundation.h>

@interface HttpRequestData : NSObject

+ (void)dataWithDic:(NSMutableDictionary *)dic
        requestType:(NSString *)requestType
          serverUrl:(NSString *)serverUrl
           andBlock:(void(^)(NSString *requestStr))block;

+ (NSMutableDictionary *)jsonValue:(NSString *)str;

@end