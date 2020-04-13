//
//  UIViewController+SendMail.m
//  TestForSendMail
//
//  Created by Shane on 2019/11/29.
//  Copyright © 2019 Shane. All rights reserved.
//

#import "UIViewController+SendMail.h"
#import <objc/runtime.h>
#import <sys/utsname.h>

NSString const *mailSendResultKey = @"mailSendResultKey";

@implementation UIViewController (SendMail)

- (void)setMailSendResult:(SendMailResultBlock)mailSendResult
{
    objc_setAssociatedObject(self, &mailSendResultKey, mailSendResult, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SendMailResultBlock)mailSendResult
{
    return objc_getAssociatedObject(self, &mailSendResultKey);
}

- (void)sendMailWithDelegate:(id)delegate subject:(NSString *)subject toRecipients:(NSArray<NSString *> *)toRecipients ccRecipients:(NSArray<NSString *> *)ccRecipients bccRecipients:(NSArray<NSString *> *)bccRecipients result:(nonnull SendMailResultBlock)result {
    self.mailSendResult = result;
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        [mailVC setMailComposeDelegate:delegate];
        [mailVC setSubject:subject];
        [mailVC setToRecipients:toRecipients];
        [mailVC setCcRecipients:ccRecipients];
        [mailVC setBccRecipients:bccRecipients];
        [mailVC setMessageBody:[self messageBody] isHTML:NO];
    
        NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion;
        if (deviceSystemVersion.floatValue < 13.0) {
            mailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        }
        [self presentViewController:mailVC animated:YES completion:nil];
    } else {
        // alert
    }
}


#pragma mark - <MFMailComposeViewControllerDelegate>
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    self.mailSendResult(result);
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)messageBody
{
    
    
	struct utsname systemInfo;
	uname(&systemInfo);
	
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	NSString *appBuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	NSString *locale = [[NSBundle mainBundle] preferredLocalizations][0];
	NSString *deviceInfo = @"--------Device Information--------";
	NSString *seperator = @"-----------------------------------";

	NSString *message = [NSString stringWithFormat:
						 @"\n\n%@\nApp: %@\nVersion: %@ (build: %@)\nDevice Model: %@\niOS: %@\nLocale: %@\n%@\n",
						 deviceInfo, appName, appVersion, appBuildVersion, deviceModel, [[UIDevice currentDevice] systemVersion], locale, seperator];
	
	return message;
    
}
@end

