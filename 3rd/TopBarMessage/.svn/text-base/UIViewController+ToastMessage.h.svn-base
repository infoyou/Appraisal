//
//  ALBaseViewController+ToastMessage.h
//  Aladdin
//
//  Created by Yfeng__ on 14-6-13.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProgressOverlayView.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"

#define TOAST_DEFAULT_HIDDEN_TIME   1.f

typedef NS_ENUM(NSInteger, ALTopMessageType) {
    ALTopMessageTypeWarning = 1,
    ALTopMessageTypeSuccess = 2,
    ALTopMessageTypeError   = 3,
    ALTopMessageTypeInfo    = 4,
};

typedef NS_ENUM(NSInteger, ALHUDType) {
    ALHUDTypeTextOnly = 1,
    ALHUDTypeImage    = 2,
    ALHUDTypeActivity = 3,
    ALHUDTypeProgress = 4,
};




@interface TopMessageView : UIView

@property (nonatomic, strong) NSString      *messageText;
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, assign) BOOL belowNavBar;

- (instancetype)initWithFrame:(CGRect)frame needIcon:(BOOL)needIcon;

@end



typedef void(^CompletionBlock)(void);


@interface UIViewController (ToastMessage) <ATMHudDelegate>

@property (nonatomic, strong) TopMessageView *topMessageView;


//hud

- (ATMHud *)showHUDWithText:(NSString *)text taskBlock:(BOOL(^)())block completion:(void(^)(BOOL completion))completion;
- (ATMHud *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration;
- (ATMHud *)showHUDWithText:(NSString *)text;
- (ATMHud *)showHUDWithText:(NSString *)text completion:(void(^)())completion;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion;
- (ATMHud *)showHUDWithText:(NSString *)text duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

//call back block
- (ATMHud *)showHUDWithText:(NSString *)text methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock;
- (ATMHud *)showHUDWithText:(NSString *)text methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)())completion;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock ;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)(void))completion;

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type methodBlock:(void(^)(CompletionBlock completionBlock, ATMHud *hud))methodBlock completion:(void (^)(void))completion;

- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type completion:(void (^)(void))completion;
- (ATMHud *)showHUDWithText:(NSString *)text inView:(UIView *)view hudType:(ALHUDType)type duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

//overlay view
- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view;
- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view completion:(void (^)(void))completion;
- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view mode:(MRProgressOverlayViewMode)mode;
- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view mode:(MRProgressOverlayViewMode)mode completion:(void (^)(void))completion;

- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view failed:(BOOL)failed;
- (void)showOverlayViewWithText:(NSString *)text inView:(UIView *)view failed:(BOOL)failed completion:(void(^)())completion;

// top message
- (void)showTopMessage:(NSString *)message;
- (void)showTopMessage:(NSString *)message completion:(void(^)(void))completion;

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar;
- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar messageType:(ALTopMessageType)msgType;

- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar completion:(void(^)(void))completion;
- (void)showTopMessage:(NSString *)message belowNavBar:(BOOL)belowNavBar messageType:(ALTopMessageType)msgType completion:(void(^)(void))completion;

- (void)updateToastTitle:(ATMHud *)hud title:(NSString *)title completionBlock:(CompletionBlock )completionBlock afterDelay:(float)afterDelay;
- (void)updateToast:(ATMHud *)hud title:(NSString *)title hudType:(ALHUDType)type completionBlock:(CompletionBlock )completionBlock afterDelay:(float)afterDelay;

- (void)updateToast:(ATMHud *)hud  callbackFunc:(void(^)(void))callbackFunc afterDelay:(float)afterDelay;

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

@end
