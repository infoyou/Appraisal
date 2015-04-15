/*
 *  ATMHud.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMHud.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import "ATMHudView.h"
#import "ATMProgressLayer.h"
#import "ATMHudDelegate.h"
#import "ATMSoundFX.h"
#import "ATMHudQueueItem.h"

@interface ATMHud (Private)
- (void)construct;
@end

@implementation ATMHud

- (id)init {
	if ((self = [super init])) {
		[self construct];
	}
	return self;
}

- (id)initWithDelegate:(id)hudDelegate {
	if ((self = [super init])) {
		_delegate = hudDelegate;
		[self construct];
	}
	return self;
}

- (void)loadView {
	UIView *base = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	base.backgroundColor = [UIColor clearColor];
	base.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
							 UIViewAutoresizingFlexibleHeight);
	base.userInteractionEnabled = NO;
	[base addSubview:self.hudView];
	
	self.view = base;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

+ (NSString *)buildInfo {
	return @"atomHUD 1.2 • 2011-03-01";
}

#pragma mark -
#pragma mark Overrides
- (void)setAppearScaleFactor:(CGFloat)value {
	if (value == 0) {
		value = 0.01;
	}
	_appearScaleFactor = value;
}

- (void)setDisappearScaleFactor:(CGFloat)value {
	if (value == 0) {
		value = 0.01;
	}
	_disappearScaleFactor = value;
}

- (void)setAlpha:(CGFloat)value {
	_alpha = value;
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	self.hudView.backgroundLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:value].CGColor;
	[CATransaction commit];
}

- (void)setShadowEnabled:(BOOL)value {
	_shadowEnabled = value;
	if (_shadowEnabled) {
		self.hudView.layer.shadowOpacity = 0.4;
	} else {
		self.hudView.layer.shadowOpacity = 0.0;
	}
}

#pragma mark -
#pragma mark Property forwards
- (void)setCaption:(NSString *)caption {
	self.hudView.caption = caption;
}

- (void)setImage:(UIImage *)image {
	self.hudView.image = image;
}

- (void)setActivity:(BOOL)activity {
	self.hudView.showActivity = activity;
	if (activity) {
		[self.hudView.activity startAnimating];
	} else {
		[self.hudView.activity stopAnimating];
	}
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle {
	self.hudView.activityStyle = activityStyle;
	if (activityStyle == UIActivityIndicatorViewStyleWhiteLarge) {
		self.hudView.activitySize = CGSizeMake(37, 37);
	} else {
		self.hudView.activitySize = CGSizeMake(20, 20);
	}
}

- (void)setFixedSize:(CGSize)fixedSize {
	self.hudView.fixedSize = fixedSize;
}

- (void)setProgress:(CGFloat)progress {
	self.hudView.progress = progress;
	
	[self.hudView.progressLayer setTheProgress:progress];
	[self.hudView.progressLayer setNeedsDisplay];
}

#pragma mark -
#pragma mark Queue
- (void)addQueueItem:(ATMHudQueueItem *)item {
	[self.displayQueue addObject:item];
}

- (void)addQueueItems:(NSArray *)items {
	[self.displayQueue addObjectsFromArray:items];
}

- (void)clearQueue {
	[self.displayQueue removeAllObjects];
}

- (void)startQueue {
	self.displayQueue = 0;
	if (!CGSizeEqualToSize(self.hudView.fixedSize, CGSizeZero)) {
		CGSize newSize = self.hudView.fixedSize;
		CGSize targetSize;
		ATMHudQueueItem *queueItem;
		for (int i = 0; i < [self.displayQueue count]; i++) {
			queueItem = [self.displayQueue objectAtIndex:i];
			
			targetSize = [self.hudView calculateSizeForQueueItem:queueItem];
			if (targetSize.width > newSize.width) {
				newSize.width = targetSize.width;
			}
			if (targetSize.height > newSize.height) {
				newSize.height = targetSize.height;
			}
		}
		[self setFixedSize:newSize];
	}
	[self showQueueAtIndex:self.queuePosition];
}

- (void)showNextInQueue {
	self.queuePosition++;
	[self showQueueAtIndex:self.queuePosition];
}

- (void)showQueueAtIndex:(NSInteger)index {
	if ([self.displayQueue count] > 0) {
		self.queuePosition = index;
		if (self.queuePosition == [self.displayQueue count]) {
			[self hide];
			return;
		}
		ATMHudQueueItem *item = [self.displayQueue objectAtIndex:self.queuePosition];
		
		self.hudView.caption = item.caption;
		self.hudView.image = item.image;
		
		BOOL flag = item.showActivity;
		self.hudView.showActivity = flag;
		if (flag) {
			[self.hudView.activity startAnimating];
		} else {
			[self.hudView.activity stopAnimating];
		}
		
		self.accessoryPosition = item.accessoryPosition;
		[self setActivityStyle:item.activityStyle];
		
		if (self.queuePosition == 0) {
			[self.hudView show];
		} else {
			[self.hudView update];
		}
	}
}

#pragma mark -
#pragma mark Controlling
- (void)show {
	[self.hudView show];
}

- (void)update {
	[self.hudView update];
}

- (void)hide {
    [self.hudView hide];
}

- (void)hideWithCompletion:(void (^)())completion {
	[self.hudView hideWithCompletion:completion];
}

- (void)hideAfter:(NSTimeInterval)delay completion:(void (^)())completion {
	[self performSelector:@selector(hideWithCompletion:) withObject:completion afterDelay:delay];
}

#pragma mark -
#pragma mark Internal methods
- (void)construct {
	self.margin = self.padding = 10.0;
	self.alpha = 0.80;
	self.progressBorderRadius = 8.0;
	self.progressBorderWidth = 2.0;
	self.progressBarRadius = 5.0;
	self.progressBarInset = 3.0;
	self.accessoryPosition = ATMHudAccessoryPositionBottom;
	self.appearScaleFactor = self.disappearScaleFactor = 1.4;
	
	_hudView = [[ATMHudView alloc] initWithFrame:CGRectZero andController:self];
	self.hudView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
							   UIViewAutoresizingFlexibleRightMargin |
							   UIViewAutoresizingFlexibleBottomMargin |
							   UIViewAutoresizingFlexibleLeftMargin);
	
	_displayQueue = [[NSMutableArray alloc] init];
	self.queuePosition = 0;
	self.center = CGPointZero;
	self.blockTouches = NO;
	self.allowSuperviewInteraction = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_blockTouches) {
		UITouch *aTouch = [touches anyObject];
		if (aTouch.tapCount == 1) {
			CGPoint p = [aTouch locationInView:self.view];
			if (CGRectContainsPoint(self.hudView.frame, p)) {
				if ([(id)self.delegate respondsToSelector:@selector(userDidTapHud:)]) {
					[self.delegate userDidTapHud:self];
				}
			}
		}
	}
}

- (void)playSound:(NSString *)soundPath {
	_sound = [[ATMSoundFX alloc] initWithContentsOfFile:soundPath];
	[self.sound play];
}

@end
