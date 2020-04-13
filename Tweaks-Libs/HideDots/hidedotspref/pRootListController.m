#include "pRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSHeaderFooterView.h>




@implementation pRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
- (void)respring {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
-(void)twitter {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://twitter.com/1DI4R"]
	options:@{}
	completionHandler:nil];
		}
-(void)github {
		 	 			[[UIApplication sharedApplication]
		 	 			openURL:[NSURL URLWithString:@"https://github.com/1di4r/HideDots"]
		 	 			options:@{}
		 	 			completionHandler:nil];
		 	 				}


@end
