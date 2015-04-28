//
//  StringCategory.h
//  Project
//
//  Created by Adam on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)stringByAddingPercentEscapes;
- (NSString *)stringByReplacingPercentEscapes;

@end
