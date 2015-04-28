//
//  CommonUtils.m
//  Project
//
//  Created by Adam on 15-4-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommonUtils.h"
#import "AppManager.h"
#import "JSONKit.h"

#define BUFFER_SIZE 1024 * 100

@implementation CommonUtils

static NSBundle *bundle = nil;

#pragma mark - date time
+ (NSString *)currentHourTime {
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH"];
	NSString *dateString = [dateFormat stringFromDate:today];
	dateFormat = nil;
	return dateString;
}

+ (NSString *)currentHourMinSecondTime {
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [dateFormat stringFromDate:today];
	dateFormat = nil;
	return dateString;
}

+ (NSString *)currentDateStr {
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	NSString *dateString = [dateFormat stringFromDate:today];
	dateFormat = nil;
	return dateString;
}

+ (NSDate *)convertDateTimeFromUnixTS:(NSTimeInterval)unixDate {
	return [NSDate dateWithTimeIntervalSince1970:unixDate];
}

+ (NSTimeInterval)convertToUnixTS:(NSDate *)date {
	return [date timeIntervalSince1970];
}

+ (NSString *)simpleFormatDateWithYear:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
	NSString *timeline = [formatter stringFromDate:date];
    //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	formatter = nil;
	
	//return timelineResult;
    return timeline;
}

+ (NSString *)simpleFormatDate:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"MM/dd HH:mm"];
    } else {
        [formatter setDateFormat:@"MM/dd"];
    }
	
	NSString *timeline = [formatter stringFromDate:date];
    //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	formatter = nil;
	
	//return timelineResult;
    return timeline;
}

+ (NSString *)getQuantumTimeWithDateFormat:(NSString *)timeline {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Set the AM and PM symbols
    //Specify only 1 M for month, 1 d for day and 1 h for hour
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate *orderDate = [dateFormatter dateFromString:eventList.startTime];
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[timeline floatValue] / 1000];
    
    //        NSDate *nowtime = [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    
    //下单 与目前相隔多少秒
    
    int time = [[NSDate date] timeIntervalSinceDate:orderDate];
    
    NSString *timeStr = @"";
    
    if (time > 0) {
        if (time / 60 / 60 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟前",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时前",time / 60.f/ 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天前",time / 60.f / 60.f / 24.f];
        }
    }else {
        time *= -1;
        if (time / 60 /60  <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟后",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时后",time / 60.f / 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天后",time / 60.f / 60.f / 24.f];
        }
    }
    return timeStr;
}

+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset {
	NSDateComponents *components = [[NSDateComponents alloc] init];
    
	[components setDay:offset];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *newDate = [gregorian dateByAddingComponents:components
                                                 toDate:nowDate
                                                options:0];
	components = nil;
	gregorian = nil;
	
	return newDate;
}

+ (NSDate *)getTodayMidnight {
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    components = [gregorian components:unitFlags fromDate:tomorrow];
    [components setHour:-16]; // maybe timezone caused the offset, set hour offset to -16
    [components setMinute:0];
    
    NSDate *todayMidnight = [gregorian dateFromComponents:components];
    
    return todayMidnight;
}

+ (NSDate *)makeDate:(NSString *)birthday
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    NSDate *date=[df dateFromString:birthday];
    NSLog(@"%@",date);
    return date;
}

+ (NSString *)dateToString:(NSDate*)date
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    
    return datestr;
}

+ (NSInteger)getElapsedDayCount:(NSDate *)date {
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                         fromDate:date
                                                                           toDate:currentDate
                                                                          options:0];
    return [elapsedTimeUnits day];
}


#pragma mark - validate json data
+ (id)validateResult:(NSDictionary *)contentDic dicKey:(NSString *)key
{
    if (nil == contentDic) {
        return nil;
    }
    
    if (nil == key || key.length == 0) {
        return nil;
    }
    
    if ([contentDic isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    id result = [contentDic objectForKey:key];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if (result) {
            if ([@"null" isEqualToString:result]) {
                return nil;
            } else {
                return result;
            }
        } else {
            return nil;
        }
    }
}

+ (NSString *)getPathName:(NSString *)dirName {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *pathName = [documentsDirectory stringByAppendingPathComponent:dirName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathName]) {
        //Create folder
        [[NSFileManager defaultManager] createDirectoryAtPath:pathName withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    return pathName;
}

+ (void)removeDocumentFile:(NSString *)dataPath
{

    NSFileManager* manager = [[NSFileManager alloc] init];
    
    NSError *error = nil;
    if ([manager fileExistsAtPath:dataPath]) {
        [manager removeItemAtPath:dataPath error:&error];
    }

}

+ (NSString *)documentsDirectory {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (CGFloat)currentOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)loadImagePath:(NSString *)pathName file:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:pathName];
    NSString *pngfile = [dataPath stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngfile]) {
        return pngfile;
    } else {
        
        return nil;
    }
    
}

+ (UIImage *)loadImageFromDocument:(NSString *)targetFilePath
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetFilePath]) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:targetFilePath]];
    } else {
        
        return [UIImage imageNamed:@"icon.png"];
    }
    
}

+ (UIImage *)loadImageFromDocument:(NSString *)pathName file:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:pathName];
    NSString  *pngfile = [dataPath stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngfile]) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:pngfile]];
    } else {
        
        return [UIImage imageNamed:@"icon.png"];
    }
    
}

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (UIImage *) createImageWithColor: (UIColor *) color withRect:(CGRect )rect
{
    //    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - image scale utility

+ (UIImage *)imageScaleToSize:(UIImage *)img size:(CGSize)size {
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH)
        return sourceImage;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    
    if (sourceImage.size.width > sourceImage.size.height) {
        
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [CommonUtils imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

#pragma mark - crop image
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) DLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - file exist
+ (NSString *)getFolderPathWithBasepath:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *pathstr = [paths objectAtIndex:0];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr = [pathstr stringByAppendingPathComponent:@"libary"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
            
        }
    }
    
    return pathstr;
}

+ (BOOL)isFileExitAtPath:(NSString *)fileName fileParentName:(NSString*)fileParentName
{
    
    NSString*fileParentPath = [self getFolderPathWithBasepath:fileParentName];
    NSString *filePath = [fileParentPath stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return YES;
    else
        return NO;
}

+ (BOOL)isFileExitAtPath:(NSString *)fileName
{
    
    NSString *filePath = [self dataFilePath:fileName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return YES;
    else
        return NO;
}

+ (NSString *)dataFilePath:(NSString *)fileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

#pragma mark - 定宽高度自适应
+ (int)calcuViewHeight:(NSString *)content font:(UIFont*)font width:(float)width
{
    CGSize titleSize = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return titleSize.height;
}

#pragma mark - 得到随机数
+ (NSString *)getRandom:(int)number
{
    NSString *strRandom = @"";
    
    for(int i=0; i<number; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    return strRandom;
}

/*
 *动态计算文本宽高
 */
+ (CGRect)sizeWithText:(NSString *)text withFont:(UIFont *)font size:(CGSize)size
{
    
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return textSize;
}


+ (NSString *)localizedStringForKey:(NSString *)key
                              alter:(NSString *)alternate {
    
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

+ (BOOL)is7System
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
        return NO;
    
    return YES;
}

#pragma mark - Common Method
+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Param Dict
+ (NSMutableDictionary *) getParamDict:(NSString *)routeName
                              dataDict:(NSMutableDictionary *)dataDict
{
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    
    [specialDict setObject:routeName forKey:@"route"];
        
    if (dataDict != nil) {
        [dataDict setObject:[AppManager instance].longitude forKey:@"lon"];
        [dataDict setObject:[AppManager instance].latitude forKey:@"lat"];
        [specialDict setObject:dataDict forKey:@"data"];
    } else {
        [specialDict setObject:@"" forKey:@"data"];
    }
    
    /*
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
    [baseDict setObject:@"zh" forKey:@"lang"];
    [baseDict setObject:CID_PARAM forKey:@"cid"];
    [baseDict setObject:[AppManager instance].userId forKey:@"user_id"];
    [baseDict setObject:@"" forKey:@"open_id"];
    [specialDict setObject:baseDict forKey:@"base"];
    */
    
    NSMutableDictionary *tranDict = [NSMutableDictionary dictionary];
    [tranDict setObject:[specialDict JSONString] forKey:@"cmd"];
    
    return tranDict;
}

@end
