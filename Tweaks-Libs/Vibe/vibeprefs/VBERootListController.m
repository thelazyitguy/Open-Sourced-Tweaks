#include "VBERootListController.h"

@implementation VBERootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)sourceLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/gilesgc/Vibe"] options:@{} completionHandler:nil];
}

@end
