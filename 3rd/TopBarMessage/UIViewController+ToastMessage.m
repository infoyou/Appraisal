//
//  ALBaseViewController+ToastMessage.m
//  Aladdin
//
//  Created by Yfeng__ on 14-6-13.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "UIViewController+ToastMessage.h"
#import <objc/runtime.h>


@interface  TopMessageView()
{
    BOOL _needIcon;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation TopMessageView


- (instancetype)initWithFrame:(CGRect)frame needIcon:(BOOL)needIcon
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:111.f/255.0 green:115.0/255.0 blue:124.f/255.0 alpha:.82];
        
        _needIcon = needIcon;
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
//        self.label.font = [UIFont systemFontOfSize:18.0f];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.label];
        
        if (needIcon) {
            self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_error"]];
            [self addSubview:self.iconImageView];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needIcon) {
        CGSize textSize = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds) * 0.9, 20.f) lineBreakMode:NSLineBreakByTruncatingTail];
        CGFloat betweenIconAndText  = 10.0f;
        CGFloat iconWidth = 20.0f;
        if (!self.iconImageView.image) {
            iconWidth = 0.0f;
        }
        self.iconImageView.frame = CGRectMake((CGRectGetWidth(self.bounds) - (textSize.width + iconWidth + betweenIconAndText)) * 0.5, (CGRectGetHeight(self.bounds) - iconWidth) * 0.5, iconWidth, iconWidth);
        self.label.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + betweenIconAndText, (CGRectGetHeight(self.bounds) - textSize.height) * 0.5, textSize.width, textSize.height);
    }
    
}

- (void)setMessageText:(NSString *)messageText
{
    _messageText = messageText;
    self.label.text = _messageText;
    [self setNeedsLayout];
}

- (void)removeFromSuperview
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y -= CGRectGetHeight(selfFrame);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = selfFrame;
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.alpha = 0.f;
        CGRect selfFrame = self.frame;
        selfFrame.origin.y -= CGRectGetHeight(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.y = self.belowNavBar ? 64.f : 0.f;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = selfFrame;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            [super willMoveToSuperview:newSuperview];
        }];
    }else {
        [super willMoveToSuperview:newSuperview];
    }
}

@end

#define TOP_MESSAGE_VIEW_HEIGHT   40.f

@interface UIViewController()

@end

static const void *TopMessageViewKey = &TopMessageViewKey;
static const void *MRProgressOverlayViewKey = &MRProgressOverlayViewKey;

@implementation UIViewController (ToastMessage)

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - hud

- (ATMHud *)showHUDWithText:(NSString *)text taskBlock:(BOOL (^)())block completion:(void (^)(BOOL completion))completion {
    assert(block);
	ATMHud *hud = [[ATMHud alloc] initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [hud setCaption:text];
    [hud setActivity:YES];
    
    [hud show];
    
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
		BOOL reuslt = block();
        
		dispatch_async(dispatch_get_main_queue(), ^{
            
			[hud hideWithCompletion:^{
                if(completion)
                    completion(reuslt);
            }];
			
		});
	});
    
    return hud;
}

- (ATMHud *)showHUDWithText:(NSString *)text {
  return  [self showHUDWithText:text inView:self.view];
}

- (ATMHud *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration {
    return [self showHUDWithText:text inView:self.view hudType:ALHUDTypeTextOnly duration:duration completion:nil];
}

- (ATMHud *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [self showHUDWithText:text inView:self.view hudType:ALHUDTypeTextOnly duration:duration completion:completion];
}

- (ATMHud *)showHUDWithText:(NSString *)text completion:(void (^)())completion {
   return  [self showHUDWithText:text inView:self.view completion:completion];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view {
  return  [self showHUDWithText:text inView:view hudType:ALHUDTypeTextOnly completion:nil];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion {
   return [self showHUDWithText:text inView:view hudType:ALHUDTypeTextOnly completion:completion];
}

- (ATMHud *)showHUDWithText:(NSString *)text methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock {
    return  [self showHUDWithText:text inView:self.view  methodBlock:methodBlock ];
}

- (ATMHud *)showHUDWithText:(NSString *)text methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)())completion {
    return  [self showHUDWithText:text inView:self.view  methodBlock:methodBlock  completion:completion];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view  methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock {
    return  [self showHUDWithText:text inView:view hudType:ALHUDTypeActivity  methodBlock:methodBlock  completion:nil];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view  methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)(void))completion {
    return [self showHUDWithText:text inView:view hudType:ALHUDTypeActivity  methodBlock:methodBlock completion:completion];
}


- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type  methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)(void))completion
{
    __block ATMHud *hud = [[ATMHud alloc] initWithDelegate:self];
    hud.allowSuperviewInteraction = YES;
    [view addSubview:hud.view];
    
    switch (type) {
        case ALHUDTypeTextOnly:
        {
            if (nil != text) {
                [hud setCaption:text];
                [hud setFixedSize:CGSizeMake(160, 50)];
            }
            
        } break;
        case ALHUDTypeImage:
        {
            if (nil != text) {
                [hud setCaption:text];
            }
            
            
        } break;
        case ALHUDTypeActivity:
        {
            if (nil != text) {
                [hud setCaption:text];
                [hud setActivity:YES];
            }
            
        } break;
        case ALHUDTypeProgress:
        {
            if (nil != text) {
                [hud setCaption:text];
            }
            
        } break;
            
        default:
            break;
    }
    
    if (text.length) {
        [hud show];
    }
    
    CompletionBlock comBlock = ^(){

        [hud hideAfter:.2f completion:^{
            if(completion) {
                completion();
            }
            DLog(@"#########################################hud %@ is already hidden!", hud);
        }];
    };
    
    if (methodBlock) {
        methodBlock(comBlock,hud);
    }
    
    return hud;
}
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type {
   return [self showHUDWithText:text inView:view hudType:type completion:nil];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type completion:(void (^)(void))completion {
    return [self showHUDWithText:text inView:view hudType:type duration:2.f completion:completion];
}

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    ATMHud *hud = [[ATMHud alloc] initWithDelegate:self];
    [view addSubview:hud.view];
    
    switch (type) {
        case ALHUDTypeTextOnly:
        {
            [hud setCaption:text];
            [hud setFixedSize:CGSizeMake(160, 50)];
        } break;
        case ALHUDTypeImage:
        {
            [hud setCaption:text];
            
        } break;
        case ALHUDTypeActivity:
        {
            [hud setCaption:text];
            [hud setActivity:YES];
            
        } break;
        case ALHUDTypeProgress:
        {
            [hud setCaption:text];
            
        } break;
            
        default:
            break;
    }
    
    [hud show];
    
    [self performBlock:^{
        
        [hud hideWithCompletion:^{
            if (completion) {
                completion();
            }
        }];
        
    } afterDelay:duration];
    
    return hud;
}

#pragma mark - hud delegate
- (void)userDidTapHud:(ATMHud *)_hud {
    [_hud hideWithCompletion:nil];
}

- (void)hudWillAppear:(ATMHud *)_hud {
    
}

- (void)hudDidAppear:(ATMHud *)_hud {
    
}

- (void)hudWillUpdate:(ATMHud *)_hud {
    
}

- (void)hudDidUpdate:(ATMHud *)_hud {
    
}

- (void)hudWillDisappear:(ATMHud *)_hud {
    
}

- (void)hudDidDisappear:(ATMHud *)_hud {
    
}

#pragma mark - overlay view

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view {
    [self showOverlayViewWithText:text inView:view mode:MRProgressOverlayViewModeCustom completion:nil];
}

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion {
    [self showOverlayViewWithText:text inView:view mode:MRProgressOverlayViewModeCustom completion:completion];
}

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view mode:(MRProgressOverlayViewMode)mode {
    [self showOverlayViewWithText:text inView:view mode:mode completion:nil];
}

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view failed:(BOOL)failed {
    [self showOverlayViewWithText:text inView:view failed:failed completion:nil];
}

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view failed:(BOOL)failed completion:(void (^)())completion {
    if (failed) {
        [self showOverlayViewWithText:text inView:view mode:MRProgressOverlayViewModeCross completion:completion];
    }else
        [self showOverlayViewWithText:text inView:view mode:MRProgressOverlayViewModeCheckmark completion:completion];
}

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view mode:(MRProgressOverlayViewMode)mode completion:(void (^)(void))completion {
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:view animated:YES];
    overlayView.mode = mode;
    overlayView.titleLabelText = text;
    
    [self.view addSubview:overlayView];
    
    [overlayView show:YES];
    [self performBlock:^{
        [overlayView dismiss:YES completion:^{
            if (completion) {
                completion();
            }
        }];
        
    } afterDelay:2.0];
}

#pragma mark - top message

- (TopMessageView *)topMessageView {
    return objc_getAssociatedObject(self, &TopMessageViewKey);
}

- (void)setTopMessageView:(TopMessageView *)topMessageView {
    objc_setAssociatedObject(self, &TopMessageViewKey, topMessageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showTopMessage:(NSString *)message {
    [self showTopMessage:message belowNavBar:YES messageType:ALTopMessageTypeSuccess completion:nil];
}

- (void)showTopMessage:(NSString *)message completion:(void (^)(void))completion {
    [self showTopMessage:message belowNavBar:YES messageType:ALTopMessageTypeSuccess completion:completion];
}

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar
{
    [self showTopMessage:message belowNavBar:belowNavBar messageType:ALTopMessageTypeSuccess completion:nil];
}

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar completion:(void (^)(void))completion {
    [self showTopMessage:message belowNavBar:belowNavBar messageType:ALTopMessageTypeSuccess completion:completion];
}

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar messageType:(ALTopMessageType)msgType {
    [self showTopMessage:message belowNavBar:belowNavBar messageType:msgType completion:nil];
}

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar messageType:(ALTopMessageType)msgType completion:(void (^)(void))completion {
    
    if (!self.topMessageView) {
        self.topMessageView = [[TopMessageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), TOP_MESSAGE_VIEW_HEIGHT) needIcon:NO];
    }
    
    self.topMessageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), TOP_MESSAGE_VIEW_HEIGHT);
    self.topMessageView.messageText = message;
    self.topMessageView.belowNavBar = belowNavBar;
    [self.view addSubview:self.topMessageView];
    
    double delayInSeconds = 2.f;
    
    [self performBlock:^{
        [self.topMessageView removeFromSuperview];
        
        if (completion) {
            completion();
        }
    } afterDelay:delayInSeconds];
    
}

- (void)updateToastTitle:(ATMHud *)hud title:(NSString *)title completionBlock:(CompletionBlock )completionBlock afterDelay:(float)afterDelay
{
    
    [hud setCaption:title];
    [hud update];
    
    [self performBlock:^{
        
        if (completionBlock) {
            completionBlock();
        }
    } afterDelay:afterDelay];
}

- (void)updateToast:(ATMHud *)hud title:(NSString *)title hudType:(ALHUDType)type completionBlock:(CompletionBlock)completionBlock afterDelay:(float)afterDelay {
    switch (type) {
        case ALHUDTypeTextOnly:
        {
            [hud setCaption:title];
            [hud setActivity:NO];
            [hud setFixedSize:CGSizeMake(160, 50)];
            
        } break;
        case ALHUDTypeImage:
        {
            [hud setCaption:title];
            [hud setActivity:NO];
            
        } break;
        case ALHUDTypeActivity:
        {
            [hud setCaption:title];
            [hud setActivity:YES];
            
        } break;
        case ALHUDTypeProgress:
        {
            [hud setCaption:title];
            [hud setActivity:NO];
            
        } break;
            
        default:
            break;
    }
    
    [hud update];
    
    [self performBlock:^{
        [hud hide];
        if (completionBlock) {
            completionBlock();
        }
    } afterDelay:afterDelay];
}


- (void)updateToast:(ATMHud *)hud  callbackFunc:(void(^)(void))callbackFunc afterDelay:(float)afterDelay
{
    
    [self performBlock:^{
      
        if (callbackFunc) {
            callbackFunc();
        }
        
        
    } afterDelay:afterDelay];
}

@end
