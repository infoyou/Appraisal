//
//  HttpRequestData.m
//  ADianIPhone
//
//  Created by Adam on 14/12/5.
//  Copyright (c) 2014年 5adian. All rights reserved.
//

#import "HttpRequestData.h"
#import "ASIFormDataRequest.h"

@implementation HttpRequestData

+ (void)dataWithDic:(NSMutableDictionary *)dic
        requestType:(NSString *)requestType
          serverUrl:(NSString *)serverUrl
           andBlock:(void(^)(NSString *requestStr))block
{
    
    NSURL *url = [NSURL URLWithString:serverUrl];
    ASIFormDataRequest * request;
    
    if ([requestType isEqualToString:@"POST"]){
        
        request=[ASIFormDataRequest requestWithURL:url];
        for (NSString *key in [dic allKeys]) {
            NSString *value=[dic objectForKey:key];
            [request setPostValue:value forKey:key];
            
            DLog(@"Server Url \n %@?cmd=%@", serverUrl, value);
        }
        
    }
    
    if ([requestType isEqualToString:@"GET"]){
        
        //遍历 转换正确的GET请求方式
        int urlCount=1;
        NSString *getUrl=[serverUrl stringByAppendingString:@"?"];
        for (NSString *key in [dic allKeys]) {
            NSString *value=[dic objectForKey:key];
            if (urlCount==[[dic allKeys] count]) {
                getUrl=[getUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{
                getUrl=[getUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
            }
            urlCount++;
        }
        request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:getUrl]];
    }
    
    [request setRequestMethod:requestType];
    
    [request setStartedBlock:^{
        block(@"Start");
    }];
    
    [request setCompletionBlock:^{
        // NSLog(@"%@",request.responseData);
        
        // 根据返回数据类型，解析数据，暂定为json解析
        NSString * string = [[NSString alloc] initWithData:request.responseData
                                                  encoding:NSUTF8StringEncoding];
        block(string);
    }];
    
    [request setFailedBlock:^{
        
//        [[[UIAlertView alloc] initWithTitle:@"提示"
//                                    message:@"请求失败"
//                                   delegate:self
//                          cancelButtonTitle:@"确定"
//                          otherButtonTitles:nil] show];
        block(@"Failed");
        
    }];
    
    [request startAsynchronous];
}

+ (NSMutableDictionary *)jsonValue:(NSString *)str
{
    
    //json解析
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableLeaves
                                             error:nil];
}

@end