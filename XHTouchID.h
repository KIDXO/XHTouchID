//
//  XHTouchID.h
//  SocialBank
//
//  Created by NULL on 16/4/12.
//  Copyright © 2016年 NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XHTouchIDError)
{
    XHTouchIDErrorUserFallback,         // 点击输入密码按钮
    XHTouchIDErrorUserCancel,           // 取消授权，用户点击了取消
    XHTouchIDErrorSystemCancel,         // 取消授权，验证过程中被系统强制取消
    XHTouchIDErrorAppCancel,            // 取消授权，其他应用进入前台导致挂起
    XHTouchIDErrorInvalidContext,       // 取消授权，当前应用被挂起而取消授权 (授权过程中LAContext对象被释放)
    XHTouchIDErrorPasscodeNotSet,       // 无法启用，设备没有设置密码
    XHTouchIDErrorTouchIDNotEnrolled,   // 无法启用，设备没有录入指纹
    XHTouchIDErrorTouchIDNotAvailable,  // 无效指纹
    XHTouchIDErrorTouchIDLockout,       // 多次验证失败被锁，需要输入密码解锁
    XHTouchIDErrorIsNotSupport          // 启动失败，当前设备不支持指纹识别
};

@protocol XHTouchIDDelegate <NSObject>

@required
/**
 *  TouchID验证成功
 */
- (void)XHTouchIDAuthenticationSuccess;
/**
 *  TouchID验证失败
 */
- (void)XHTouchIDAuthenticationFailure;

@optional
/**
 *  TouchID验证错误
 */
- (void)XHTouchIDAuthenticationError:(XHTouchIDError)error;

@end

@interface XHTouchID : NSObject

@property (nonatomic, weak) id <XHTouchIDDelegate> delegate;

+ (instancetype)sharedTouchID;

/**
 *  发起TouchID验证
 *
 *  @param message  提示信息
 *  @param title    按钮标题
 *  @param delegate 回调代理
 */
- (void)startTouchIDWithMessage:(NSString *)message
                          title:(NSString *)title
                       delegate:(id<XHTouchIDDelegate>)delegate;

/**
 *  判断TouchID支持
 *
 *  @return 是否支持TouchID
 */
- (BOOL)hasTouchID;

@end
