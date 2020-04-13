#include "ONPRootListController.h"
#import <MenushkaPrefs/MenushkaPrefs.h>
#import "NSTask.h"

@implementation ONPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		[self setSourceUrl:@"https://github.com/menushka/OneNotify"];
		[self showSource:YES];
		[self showDonate:YES];
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring:(PSSpecifier *)specifier {
    NSTask *t = [[[NSTask alloc] init] autorelease];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [t launch];
}

- (void)reset:(PSSpecifier *)specifier {
    [MenushkaPrefs resetPrefs:@"ca.menushka.onenotify.preferences"];
    [self respring:nil];
}

@end
