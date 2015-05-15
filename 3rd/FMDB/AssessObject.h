//
//  AssessObject.h
//  Project
//
//  Created by Adam on 15-4-17.
//  Copyright (c) 2015年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessObject : NSObject

@property (nonatomic, copy) NSString *assessId;

@property (nonatomic, copy) NSString *logicId; // 标的物返回结果id
@property (nonatomic, assign) NSInteger logicType; // 标的物类型
@property (nonatomic, assign) NSInteger assessType; // 评估 or 典当

// 图片 or 视频
@property (nonatomic, assign) NSInteger attachType;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *pawnPrice;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString *usedPrice;

// 标的物描述
@property (nonatomic, copy) NSString *mark1;
@property (nonatomic, copy) NSString *mark2;
@property (nonatomic, copy) NSString *mark3;
@property (nonatomic, copy) NSString *mark4;
@property (nonatomic, copy) NSString *mark5;
@property (nonatomic, copy) NSString *mark6;
@property (nonatomic, copy) NSString *mark7;
@property (nonatomic, copy) NSString *mark8;
@property (nonatomic, copy) NSString *mark9;
@property (nonatomic, copy) NSString *mark10;

@end
