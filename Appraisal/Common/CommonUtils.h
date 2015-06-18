//
//  CommonUtils.h
//  Project
//
//  Created by Adam on 15-4-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

#pragma mark - WeChat integration
#define MAX_WECHAT_ATTACHED_IMG_SIZE    30 * 1024
#define MAX_WECHAT_MAX_DESC_CHAR_COUNT  32
#define MAX_WECHAT_MAX_TITLE_CHAR_COUNT 60

@interface CommonUtils : NSObject

#pragma mark - date time
+ (NSString *)currentHourTime;
+ (NSString *)currentHourMinSecondTime;
+ (NSString *)currentDateStr;
+ (NSDate *)convertDateTimeFromUnixTS:(NSTimeInterval)unixDate;
+ (NSString *)simpleFormatDate:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy;
+ (NSString *)simpleFormatDateWithYear:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy;
+ (NSTimeInterval)convertToUnixTS:(NSDate *)date;
+ (NSString *)getElapsedTime:(NSDate *)timeline;
+ (NSDate *)makeDate:(NSString *)birthday;
+ (NSString *)dateToString:(NSDate*)date;

+ (NSInteger)getElapsedDayCount:(NSDate *)date;
+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset;
+ (NSString *)getQuantumTimeWithDateFormat:(NSString *)timeline;
//+ (NSString *)getQuantumTimeWithTimeStamp:(NSString *)timeline;


#pragma mark - validate json data
+ (id)validateResult:(NSDictionary *)contentDic dicKey:(NSString *)key;

#pragma mark - validate password format
+ (BOOL)passwordFormatIsValidated:(NSString *)passwordStr;

#pragma mark - Share to WeChat
+ (BOOL)shareByWeChat:(NSInteger)scene
                title:(NSString *)title
                image:(NSString *)image
          description:(NSString *)description
                  url:(NSString *)url;

+ (NSString *)deviceModel;

+ (NSString *)getPathName:(NSString *)dirName;
+ (void)removeDocumentFile:(NSString *)fileName;
+ (void)removeDocumentFile:(NSString *)dirName fileName:(NSString *)fileName;
+ (void)removeDocumentFile:(NSString *)dirName fileName:(NSString *)fileName typeName:(NSString *)typeName;
+ (NSString *)documentsDirectory;
+ (CGFloat)currentOSVersion;

+ (NSString *)loadImagePath:(NSString *)pathName file:(NSString *)fileName;
+ (UIImage *)loadImageFromDocument:(NSString *)targetFilePath;
+ (UIImage *) loadImageFromDocument:(NSString *)pathName file:(NSString *)fileName;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect )rect;

#pragma mark - image scale utility
+ (UIImage *)imageScaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

#pragma mark - crop image
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

#pragma mark - file exist
+ (BOOL)isFileExitAtPath:(NSString*)aFilename;
+ (BOOL)isFileExitAtPath:(NSString *)fileName fileParentName:(NSString*)fileParentName;

#pragma mark - get New type
+ (NSString*)getNetType;

#pragma mark - 定宽高度自适应
+ (int)calcuViewHeight:(NSString *)content font:(UIFont*)font width:(float)width;

#pragma mark - 得到随机数
+ (NSString *)getRandom:(int)number;

#pragma mark - Param Dict
+ (NSMutableDictionary *) getParamDict:(NSString *)routeName
                              dataDict:(NSMutableDictionary *)dataDict;

+ (CGRect)sizeWithText:(NSString *)text withFont:(UIFont *)font size:(CGSize)size;

#pragma mark - system language
//+ (void)getDBLanguage;
//+ (void)getLocalLanguage;

+ (NSString *)localizedStringForKey:(NSString *)key
                              alter:(NSString *)alternate;

+ (void)setLanguage:(NSString *)languageDesc;

+ (BOOL)is7System;

#pragma mark - Common Method
+ (UIColor*)colorWithHexString:(NSString*)hex;

//压缩图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
