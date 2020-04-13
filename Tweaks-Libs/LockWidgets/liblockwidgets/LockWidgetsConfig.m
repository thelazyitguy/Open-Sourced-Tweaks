#import "LockWidgetsConfig.h"

@implementation LockWidgetsConfig

+ (instancetype)sharedInstance {
	static LockWidgetsConfig *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	  sharedInstance = [LockWidgetsConfig alloc];
	  [sharedInstance reloadPreferences];
	});

	return sharedInstance;
}

- (id)init {
	return [LockWidgetsConfig sharedInstance];
}

- (void)reloadPreferences {
	CFStringRef appID = CFSTR("me.conorthedev.lockwidgets.preferences");
	CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (!keyList) {
		LogError(@"There's been an error getting the key list! Restoring to default dictionary...");
		self.preferences = @{@"kEnabled" : @YES, @"kHideWhenLocked" : @NO, @"kReachabilityEnabled" : @NO, @"selectedWidgets" : @[ @"com.apple.BatteryCenter.BatteryWidget", @"com.apple.UpNextWidget.extension" ]};
		[self saveValues];
		return;
	}
	self.preferences = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
	if (!self.preferences) {
		LogError(@"There's been an error getting the preferences dictionary! Restoring to default dictionary...");
		self.preferences = @{@"kEnabled" : @YES, @"kHideWhenLocked" : @NO, @"kReachabilityEnabled" : @NO, @"selectedWidgets" : @[ @"com.apple.BatteryCenter.BatteryWidget", @"com.apple.UpNextWidget.extension" ]};
	}
	CFRelease(keyList);

	[self saveValues];
}

- (void)saveValues {
	self.enabled = [self.preferences objectForKey:@"kEnabled"] ? [[self.preferences objectForKey:@"kEnabled"] boolValue] : YES;
	self.reachabilityEnabled = [self.preferences objectForKey:@"kReachabilityEnabled"] ? [[self.preferences objectForKey:@"kReachabilityEnabled"] boolValue] : NO;
	self.selectedWidgets = [self.preferences objectForKey:@"selectedWidgets"] ? (NSArray *)[self.preferences objectForKey:@"selectedWidgets"] : @[ @"com.apple.BatteryCenter.BatteryWidget", @"com.apple.UpNextWidget.extension" ];
	self.hideWhenLocked = [self.preferences objectForKey:@"kHideWhenLocked"] ? [[self.preferences objectForKey:@"kHideWhenLocked"] boolValue] : NO;
}

- (BOOL)writeValue:(NSObject *)value forKey:(NSString *)key {
	CFPreferencesAppSynchronize((CFStringRef) @"me.conorthedev.lockwidgets.preferences");
	CFPreferencesSetValue((CFStringRef)key, (CFPropertyListRef)value, (CFStringRef) @"me.conorthedev.lockwidgets.preferences", CFSTR("mobile"), kCFPreferencesAnyHost);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.lockwidgets/ReloadPreferences"), NULL, NULL, YES);

	return YES;
}
@end