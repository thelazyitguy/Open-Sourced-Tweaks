#import "NSTask.h"
#include "MPPRootListController.h"
#include <UIKit/UIKit.h>

@implementation MPPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (id)init {
	self = [super init];
	UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
												style:UIBarButtonItemStylePlain
												target:self
												action:@selector(respringDevice:)];
	self.navigationItem.rightBarButtonItem = respringButton;
	return self;
}

- (void)respringDevice:(id)sender {
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = @"/usr/bin/killall";
	task.arguments = @[@"-9", @"MobileSMS"];
	[task launch];
}

@end
