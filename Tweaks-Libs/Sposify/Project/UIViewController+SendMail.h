//
//  UIViewController+SendMail.h
//  TestForSendMail
//
//  Created by Shane on 2019/11/29.
//  Copyright © 2019 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SendMailResultBlock)(MFMailComposeResult result);

@interface UIViewController (SendMail)

@property (nonatomic, copy) SendMailResultBlock mailSendResult;

/**
 发送基础邮件（不需要单独处理MailViewController的Dismiss）
 @param delegate        MFMailComposeViewControllerDelegate
 @param subject         主题
 @param toRecipients    收件人
 @param ccRecipients    抄送人
 @param bccRecipients   密送人
 @param result          邮件发送结果（只做提示使用）
 */
- (void)sendMailWithDelegate:(id)delegate subject:(NSString *)subject toRecipients:(nullable NSArray<NSString *> *)toRecipients ccRecipients:(nullable NSArray<NSString *> *)ccRecipients bccRecipients:(nullable NSArray<NSString *> *)bccRecipients result:(SendMailResultBlock)result;

@end

NS_ASSUME_NONNULL_END
