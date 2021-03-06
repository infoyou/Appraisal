//
//  ReportViewController.h
//  Appraisal
//
//  Created by Adam on 15/4/2.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "RootViewController.h"

@interface ReportViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;

@property (weak, nonatomic) IBOutlet UILabel *mark1Label;
@property (weak, nonatomic) IBOutlet UILabel *mark2Label;
@property (weak, nonatomic) IBOutlet UILabel *mark3Label;
@property (weak, nonatomic) IBOutlet UILabel *mark4Label;

@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pawnPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *btnShare;
@property (weak, nonatomic) IBOutlet UIImageView *btnSave;
@property (weak, nonatomic) IBOutlet UIImageView *btnPawn;


- (void)updateData:(NSDictionary *)msgDict;

@end
