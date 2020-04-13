#import "CTDPrefs.h"

@implementation CTDListController
- (instancetype)init {
	self = [super init];

	return self;
}

- (void)setNavbarThemed:(BOOL)enabled {
	UINavigationBar *bar =
		self.navigationController.navigationController.navigationBar;
	if (enabled && self.preferenceSettings.customizeNavbar) {
		bar.barTintColor = self.preferenceSettings.barTintColor;
		bar.tintColor = [UIColor whiteColor];
		bar.barStyle = 2;
		bar.translucent = NO;
		bar.shadowImage = [UIImage new];

		if (self.preferenceSettings.forceLight) {
			bar.barStyle = UIBarStyleBlack;
			[bar setTitleTextAttributes:
					 @{NSForegroundColorAttributeName : [UIColor whiteColor]}];
		}
	} else {
		bar.barTintColor = [[UINavigationBar appearance] barTintColor];
		bar.tintColor = [[UINavigationBar appearance] tintColor];
		bar.barStyle = [[UINavigationBar appearance] barStyle];
		bar.translucent = YES;
		bar.shadowImage = [[UINavigationBar appearance] shadowImage];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setNavbarThemed:YES];
}

- (void)reloadSpecifiers {
	[super reloadSpecifiers];
	[self setNavbarThemed:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self setNavbarThemed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self setNavbarThemed:NO];
}

@end