#include "LWRootListController.h"

@implementation LWRootListController

- (instancetype)init {
	self = [super init];

	if (self) {
		CTDPreferenceSettings *preferenceSettings =
			[[CTDPreferenceSettings alloc] init];
		preferenceSettings.customizeNavbar = YES;
		preferenceSettings.tintColor = [UIColor colorWithRed:149.0f / 255.0f
													   green:172.0f / 255.0f
														blue:226.0f / 255.0f
													   alpha:1];
		preferenceSettings.barTintColor = preferenceSettings.tintColor;
		preferenceSettings.forceLight = YES;

		self.preferenceSettings = preferenceSettings;

		UIBarButtonItem *respringItem =
			[[UIBarButtonItem alloc] initWithTitle:@"Apply"
											 style:UIBarButtonItemStylePlain
											target:self
											action:@selector(respring:)];
		self.navigationItem.rightBarButtonItem = respringItem;
	}

	return self;
}

- (void)respring:(id)sender {
	pid_t pid;
	const char *args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)selectWidgets:(id)sender {
	LWSelectWidgetController *controller = [[LWSelectWidgetController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

@end
