@interface TLAlertConfiguration : NSObject
@end

@interface BBSound : NSObject
- (TLAlertConfiguration *)alertConfiguration;
@end

@interface BBBulletinRequest : NSObject
- (NSString *)sectionID;
- (BBSound *)sound;
@end

static NSUserDefaults *settings;
static BOOL enabled;

void loadPrefs() {
	settings = [[NSUserDefaults alloc] initWithSuiteName:@"com.gilesgc.vibe"];
	enabled = [settings objectForKey:@"isEnabled"] ? [settings boolForKey:@"isEnabled"] : YES;
}

%hook BBServer

- (void)publishBulletinRequest:(BBBulletinRequest *)request destinations:(unsigned long long)arg2 {
	[settings synchronize];
	NSString *identifier;

	if( (identifier = [settings stringForKey:[request sectionID]]) && enabled ) {
		MSHookIvar<NSString *>([[request sound] alertConfiguration], "_vibrationIdentifier") = identifier;
	}
	
	%orig;
}

%end

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.gilesgc.vibe/prefChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	%init;
}