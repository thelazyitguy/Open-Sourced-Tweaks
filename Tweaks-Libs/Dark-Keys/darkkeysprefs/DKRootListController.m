#include "DKRootListController.h"
#define darkKeysIconPath @"/Library/PreferenceBundles/darkkeysprefs.bundle/icon@3x.png"

@implementation DKRootListController
@synthesize respringButton;

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
        self.respringButton.tintColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
        //Cephei colour preferences
        //TODO: cleanup colour names with https://stackoverflow.com/questions/1956587/how-do-i-make-my-own-custom-uicolors-other-than-the-preset-ones
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor whiteColor]; //white
        appearanceSettings.tableViewBackgroundColor = [UIColor colorWithRed:0.06 green:0.09 blue:0.12 alpha:1]; //dark dark blue
        appearanceSettings.tableViewCellBackgroundColor = [UIColor colorWithRed:0.06 green:0.09 blue:0.12 alpha:1]; //dark dark blue
        appearanceSettings.tableViewCellTextColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1]; //white white
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithRed:0.06 green:0.09 blue:0.12 alpha:1]; //dark dark blue
        appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:0.12 green:0.15 blue:0.18 alpha:1.0]; //midnight blue
        appearanceSettings.navigationBarTitleColor = [UIColor whiteColor]; //white
        appearanceSettings.statusBarTintColor = [UIColor colorWithRed:0.93 green:0.94 blue:0.95 alpha:1.0]; //white
        appearanceSettings.navigationBarTintColor = [UIColor colorWithRed:0.93 green:0.94 blue:0.95 alpha:1.0]; //white
        appearanceSettings.translucentNavigationBar = NO;
        self.hb_appearanceSettings = appearanceSettings;
        
        // self.navigationItem.rightBarButtonItem = self.respringButton;
    }

    return self;
    
}

/*
//Sets icon in NavBar
- (void)setTitle:(id)title {
	UIImage *icon = [[UIImage alloc] initWithContentsOfFile:darkKeysIconPath];
	UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
	
	self.navigationItem.titleView = iconView;	
}
*/

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring:(id)sender {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];
}

@end
