//
//  XHTouchID.m
//  SocialBank
//
//  Created by NULL on 16/4/12.
//  Copyright © 2016年 NULL. All rights reserved.
//

#import "XHTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation XHTouchID

static XHTouchID *touchID;

+ (instancetype)sharedTouchID
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        touchID = [[self alloc]init];
    });
    return touchID;
}

- (void)startTouchIDWithMessage:(NSString *)message
                          title:(NSString *)title
                       delegate:(id<XHTouchIDDelegate>)delegate
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = title == nil ? @"按钮标题" : title;
    NSError *error = nil;
    self.delegate = delegate;
    NSAssert(self.delegate != nil, @"XHTouchIDDelegate不能为空");
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message == nil ? @"自定义信息" : message reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationSuccess)]) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.delegate XHTouchIDAuthenticationSuccess];
                    }];
                }
            }
            else if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationFailure)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationFailure];
                            }];
                        }
                    }
                        break;
                    case LAErrorUserFallback: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorUserFallback];
                            }];
                        }
                    }
                        break;
                    case LAErrorUserCancel: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorUserCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorSystemCancel:{
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorSystemCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorAppCancel:  {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorAppCancel];
                            }];
                        }
                    }
                        break;
                    case LAErrorInvalidContext: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorInvalidContext];
                            }];
                        }
                    }
                        break;
                    case LAErrorPasscodeNotSet: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorPasscodeNotSet];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorTouchIDNotEnrolled];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDNotAvailable: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorTouchIDNotAvailable];
                            }];
                        }
                    }
                        break;
                    case LAErrorTouchIDLockout: {
                        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorTouchIDLockout];
                            }];
                        }
                    }
                        break;
                }
            }
        }];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(XHTouchIDAuthenticationError:)]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate XHTouchIDAuthenticationError:XHTouchIDErrorIsNotSupport];
            }];
        }
    }
}

- (BOOL)hasTouchID
{
    LAContext *context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
