#import "Preferences.h"

@implementation TSPreferencesListController

-(instancetype)init {
	return [super init];
}

-(id)specifiers {
	if(_specifiers == nil)
		_specifiers = [[self loadSpecifiersFromPlistName:@"Preferences" target:self] retain];

	return _specifiers;
}

-(void)openContactMe {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:travis@toggleable.com?subject=Temporary%20Background%20Spawn"] options:@{} completionHandler:nil];
}

-(void)openSourceCodeURL {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/infernoboy/Temporary-Background-Spawn"] options:@{} completionHandler:nil];
}

@end
