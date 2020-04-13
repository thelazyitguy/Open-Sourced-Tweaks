#include "KgeRootListController.h"

@implementation KgeRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)openTwitter {
	NSURL *url;

	// check which of these apps are installed
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		url = [NSURL URLWithString:@"tweetbot:///user_profile/Ra1nPix"];
	}
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		url = [NSURL URLWithString:@"twitterrific:///profile?screen_name=Ra1nPix"];
	}
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		url = [NSURL URLWithString:@"tweetings:///user?screen_name=Ra1nPix"];
	}
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		url = [NSURL URLWithString:@"twitter://user?screen_name=Ra1nPix"];
	}
	else {
		url = [NSURL URLWithString:@"https://mobile.twitter.com/Ra1nPix"];
	}

	// open my profile in the app chosen above
	// if you're compiling with an iOS 10 or lower sdk you can leave out options:@{} and completionHandler:nil
	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

// send respring notification
-(void)saveTapped {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.yaypixxo.kage/respring"), NULL, NULL, YES);
}

@end
