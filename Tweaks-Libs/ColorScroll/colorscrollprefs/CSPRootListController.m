#include "CSPRootListController.h"
#include <spawn.h>

@implementation CSPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respringDevice)];
    self.navigationItem.rightBarButtonItem = applyButton;
}

-(void)respringDevice {
	pid_t pid;
	const char *argv[] = {"sbreload", NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
}
@end
