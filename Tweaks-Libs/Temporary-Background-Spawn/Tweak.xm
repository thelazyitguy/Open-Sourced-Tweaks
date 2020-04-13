#import "Tweak.h"

#if DEBUG
#define NSLog(args...) NSLog(@"[TempSpawn] "args)
#else
#define NSLog(...)
#endif

#define IOS_VERSION_LESS_THAN(version) ([[[%c(UIDevice) currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

extern "C" void BKSTerminateApplicationForReasonAndReportWithDescription(NSString *bundleIdentifier, int reasonID, bool report, NSString *description);

NSString *prefsPlist = @"com.toggleable.tempspawn";
NSString *killOnExitPlist = @"com.toggleable.tempspawn~killOnExit";
NSString *trackerPlist = @"com.toggleable.tempspawn~tracker";
NSString *userBlacklistPlist = @"com.toggleable.tempspawn~blacklist";
NSString *systemBlacklistPlist = @"file:///Library/PreferenceBundles/TempSpawnPreferences.bundle/system-blacklist.plist";

NSString* shortcutsAppIdentifier = (IOS_VERSION_LESS_THAN(@"13.0")) ? @"is.workflow.my.app" : @"com.apple.shortcuts";

long terminateDelay = 30.0;

TempSpawn *tempSpawn;

static void blacklistChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[tempSpawn loadUserBlacklist];
}

static void killOnExitChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[tempSpawn loadKillOnExit];
}

static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[tempSpawn loadPrefs];
}

@implementation TempSpawnTracker

+(NSArray*)tracked {
	return @[@"backgroundLaunched", @"backgroundTerminated", @"terminationCancelled"];
}

-(TempSpawnTracker*)initWithApp:(SBApplication*)app {
	self.counts = [[NSMutableDictionary alloc] init];
	self.app = app;

	NSDictionary *data = [tempSpawn.trackerList dictionaryForKey:[app bundleIdentifier]];

	if ([data count] == 0) {
		[tempSpawn.trackerList setObject:[app displayName] forKey:[[app bundleIdentifier] stringByAppendingString:@"~displayName"]];
	}

	for (NSString *type in TempSpawnTracker.tracked)
		[self.counts setObject:[NSNumber numberWithInt:[data[type] integerValue]] ?: 0 forKey:type];

	return self;
}

-(void)launchedInBackground {
	self.counts[@"backgroundLaunched"] = [NSNumber numberWithInt:[self.counts[@"backgroundLaunched"] integerValue] + 1];

	[tempSpawn.trackerList setObject:self.counts forKey:[self.app bundleIdentifier]];
}

-(void)terminatedInBackground {
	self.counts[@"backgroundTerminated"] = [NSNumber numberWithInt:[self.counts[@"backgroundTerminated"] integerValue] + 1];

	[tempSpawn.trackerList setObject:self.counts forKey:[self.app bundleIdentifier]];
}

-(void)cancelledTermination {
	self.counts[@"cancelledTermination"] = [NSNumber numberWithInt:[self.counts[@"cancelledTermination"] integerValue] + 1];

	[tempSpawn.trackerList setObject:self.counts forKey:[self.app bundleIdentifier]];
}

@end

@implementation TempSpawnProcessState
-(TempSpawnProcessState*)initWithProcessState:(SBApplicationProcessState*)processState app:(SBApplication*)app {
	self = [super init];

	_launchedInBackground = NO;

	self.seen = NO;
	self.processState = processState;
	self.app = app;
	self.tracker = [[TempSpawnTracker alloc] initWithApp:app];

	return self;
}

-(void)setLaunchedInBackground:(BOOL)launchedInBackground {
	_launchedInBackground = launchedInBackground;
	
	self.seen = YES;
}
@end


@implementation TempSpawn
-(TempSpawn*)init {
	self.terminationTimers = [NSMutableDictionary dictionary];
	self.processStates = [NSMutableDictionary dictionary];

	[self loadPrefs];
	[self loadKillOnExit];
	[self loadTracker];
	[self loadUserBlacklist];
	[self loadSystemBlacklist];

	return self;
}

-(void)addObservers {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationProcessStateDidChange:) name:@"SBApplicationProcessStateDidChange" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStatusChanged:) name:@"TUCallCenterCallStatusChangedNotification" object:nil];
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsChanged, CFSTR("com.toggleable.tempspawn~prefsChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)killOnExitChanged, CFSTR("com.toggleable.tempspawn~killOnExitChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)blacklistChanged, CFSTR("com.toggleable.tempspawn~blacklistChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)addRootObservers {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anyNotification:) name:nil object:nil];
}

-(void)anyNotification:(id)notification {
	NSLog("%@", notification);
}

-(void)loadPrefs {
	if ([self.prefs isKindOfClass:[NSUserDefaults class]]) {
		[self.prefs synchronize];

		NSLog(@"Preferences synchronized.");
	}	else {
		self.prefs = [[NSUserDefaults alloc] initWithSuiteName:prefsPlist];

		NSLog(@"Preferences loaded: %@", self.prefs);
	}
}

-(void)loadKillOnExit {
	if ([self.killOnExit isKindOfClass:[NSUserDefaults class]]) {
		[self.killOnExit synchronize];

		NSLog(@"Kill-on-exit list synchronized.");
	}	else {
		self.killOnExit = [[NSUserDefaults alloc] initWithSuiteName:killOnExitPlist];

		NSLog(@"Kill-on-exit list loaded: %@", self.killOnExit);
	}
}

-(void)loadTracker {
	if ([self.trackerList isKindOfClass:[NSUserDefaults class]]) {
		[self.trackerList synchronize];

		NSLog(@"Tracker list synchronized.");
	}	else {
		self.trackerList = [[NSUserDefaults alloc] initWithSuiteName:trackerPlist];

		NSLog(@"Tracker list loaded: %@", self.trackerList);
	}
}

-(void)loadUserBlacklist {
	if ([self.userBlacklist isKindOfClass:[NSUserDefaults class]]) {
		[self.userBlacklist synchronize];

		NSLog(@"User blacklist synchronized.");
	}	else {
		self.userBlacklist = [[NSUserDefaults alloc] initWithSuiteName:userBlacklistPlist];

		NSLog(@"User blacklist loaded: %@", self.userBlacklist);
	}
}

-(void)loadSystemBlacklist {
	NSError *error;

	self.systemBlacklist = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:systemBlacklistPlist] error:&error];

	if (error) {
		NSLog(@"System blacklist not found or corrupted.");

		self.systemBlacklist = @{};
	}

	NSLog(@"System blacklist loaded: %@", self.systemBlacklist);
}

-(BOOL)shouldKillOnExit:(NSString*)bundleIdentifier {
	return [self.killOnExit boolForKey:bundleIdentifier];
}

-(BOOL)isBlacklisted:(NSString*)bundleIdentifier {
	return [self.userBlacklist boolForKey:bundleIdentifier] || [self.systemBlacklist[bundleIdentifier] boolValue];
}

-(void)callStatusChanged:(id)notification {
	TUProxyCall *proxyCall = (TUProxyCall*)[notification object];

	NSString *callAppBundleIdentifier = [[proxyCall backingProvider] bundleIdentifier];

	if (callAppBundleIdentifier) {
		NSLog(@"Call status for %@: %i", callAppBundleIdentifier, [proxyCall callStatus]);

		TempSpawnProcessState *previousProcessState = self.processStates[callAppBundleIdentifier];

		if (previousProcessState) {
			if ([proxyCall callStatus] == 4) { // ringing
				[self showDebugNotificationWithTitle:[previousProcessState displayName] message:@"Incoming call from app, cancelled termination timer."];

				[self cancelTerminationTimer:callAppBundleIdentifier];

				[previousProcessState.tracker cancelledTermination];
			} else if ([proxyCall callStatus] == 6 && [previousProcessState launchedInBackground]) { // disconnected
				if (![self isBlacklisted:callAppBundleIdentifier])
					[self terminateAppNow:callAppBundleIdentifier withReason:@"Call ended, terminated app."];
			}
		}
	}
}

-(void)showDebugNotificationWithTitle:(NSString*)title message:(NSString*)message {
	if ([self.prefs boolForKey:@"debugMode"]) {
		void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);

		if (handle != NULL) {
			[%c(CPNotification) showAlertWithTitle:title
				message:message
				userInfo:nil
				badgeCount:nil
				soundName:@"none"
				delay:1
				repeats:NO
				bundleId:shortcutsAppIdentifier
			];

			dlclose(handle);
		}
	}
}

-(void)applicationProcessStateDidChange:(id)notification {
	if ([notification object]) {
		SBApplication *app = (SBApplication*)[notification object];

		@try {
			if ([app isSystemApplication]) {}
		}
		@catch (NSException *exception) {
			return;
		}

		if ([[app processState] isRunning]) {
			TempSpawnProcessState *previousProcessState = self.processStates[[app bundleIdentifier]];

			if ([[app processState] taskState] == 3) { // suspended
				if (previousProcessState && [previousProcessState.processState taskState] != 3 && !previousProcessState.launchedInBackground && [self shouldKillOnExit:[app bundleIdentifier]]) {
					NSLog(@"Killing app on exit soon: %@", [app bundleIdentifier]);

					[self showDebugNotificationWithTitle:[app displayName] message:@"App is set to kill on close, will terminate soon."];

					[self terminateAppSoon:[app bundleIdentifier]];
				}
			} else if ([[app processState] taskState] != 3) { // suspended
				// NSLog(@"processState: %@ is %lld - taskState: %lld", [app bundleIdentifier], [[app processState] visibility], [[app processState] taskState]);

				if (previousProcessState) {
					// NSLog(@"previousProcessState for %@: %@", [app bundleIdentifier], previousProcessState);

					if (!previousProcessState.launchedInBackground && [previousProcessState seen] && ![self shouldKillOnExit:[app bundleIdentifier]]) {
						// NSLog(@"Ignoring already seen app: %@", [app bundleIdentifier]);
						return;
					}

					if (!previousProcessState.launchedInBackground && [[previousProcessState processState] visibility] == 0 && [[app processState] visibility] == 1) {
						NSLog(@"Launched in background from unknown: %@", [app bundleIdentifier]);

						previousProcessState.launchedInBackground = YES;

						[previousProcessState.tracker launchedInBackground];

						if (![self isBlacklisted:[app bundleIdentifier]]) {
							[self showDebugNotificationWithTitle:[app displayName]
								message:[NSString stringWithFormat:@"App launched in background, will terminate soon.\n\nBackground launches: %@, background terminations: %@, cancelled terminations: %@", previousProcessState.tracker.counts[@"backgroundLaunched"], previousProcessState.tracker.counts[@"backgroundTerminated"], previousProcessState.tracker.counts[@"terminationCancelled"]]
							];

							[self terminateAppSoon:[app bundleIdentifier]];
						}
					} else if ([[app processState] visibility] == 2) {
						if (previousProcessState.launchedInBackground || [self shouldKillOnExit:[app bundleIdentifier]]) {
							NSLog(@"Moved to foreground: %@", [app bundleIdentifier]);

							[previousProcessState.tracker cancelledTermination];

							[self showDebugNotificationWithTitle:[app displayName] message:@"App moved to foreground, cancelled termination timer."];

							[self cancelTerminationTimer:[app bundleIdentifier]];
						}

						previousProcessState.launchedInBackground = NO;
					}
				} else
					previousProcessState = [[TempSpawnProcessState alloc] initWithProcessState:[app processState] app:app];

				if ([[app processState] visibility] == 1 && !previousProcessState.launchedInBackground && ![self shouldKillOnExit:[app bundleIdentifier]]) {
					NSLog(@"Launched in background: %@", [app bundleIdentifier]);

					previousProcessState.launchedInBackground = YES;

					[previousProcessState.tracker launchedInBackground];

					if (![self isBlacklisted:[app bundleIdentifier]]) {
						[self showDebugNotificationWithTitle:[app displayName]
							message:[NSString stringWithFormat:@"App launched in background, will terminate soon.\n\nBackground launches: %@, background terminations: %@, cancelled terminations: %@", previousProcessState.tracker.counts[@"backgroundLaunched"], previousProcessState.tracker.counts[@"backgroundTerminated"], previousProcessState.tracker.counts[@"terminationCancelled"]]
						];
						
						[self terminateAppSoon:[app bundleIdentifier]];
					}
				}
			} else if (previousProcessState.launchedInBackground) {
				NSLog(@"App was launched in background, but now suspended: %@", [app bundleIdentifier]);

				if (![self isBlacklisted:[app bundleIdentifier]]) {
					[self showDebugNotificationWithTitle:[app displayName] message:@"Launched in background and now suspended, terminated app."];

					[self terminateAppNow:[app bundleIdentifier] withReason:@"background activity completed"];
				}
			}

			previousProcessState.processState = [app processState];
			previousProcessState.displayName = [app displayName];
			previousProcessState.app = app;

			self.processStates[[app bundleIdentifier]] = previousProcessState;
		} else {
			NSLog(@"Terminated: %@", [app bundleIdentifier]);

			[self.processStates removeObjectForKey:[app bundleIdentifier]];
		}
	}
}

-(void)terminateAppFromTimer:(NSTimer*)timer {
	[self terminateAppNow:timer.userInfo withReason:@"Background time expired, terminated app."];
}

-(void)cancelTerminationTimer:(NSString*)bundleIdentifier {
	NSTimer *timer = self.terminationTimers[bundleIdentifier];

	if (timer) {
		NSLog(@"Cancelling termination timer: %@", bundleIdentifier);

		[timer invalidate];
		[self.terminationTimers removeObjectForKey:bundleIdentifier];
	}
}

-(void)terminateAppSoon:(NSString*)bundleIdentifier {
	NSLog(@"Terminating soon: %@", bundleIdentifier);

	NSTimer *timer = self.terminationTimers[bundleIdentifier];

	if (timer)
		[timer invalidate];
	
	self.terminationTimers[bundleIdentifier] = [NSTimer scheduledTimerWithTimeInterval:terminateDelay target:self selector:@selector(terminateAppFromTimer:) userInfo:bundleIdentifier repeats:NO];
}

-(void)terminateAppNow:(NSString*)bundleIdentifier withReason:(NSString*)reason {
	TempSpawnProcessState *previousProcessState = self.processStates[bundleIdentifier];
	
	if (previousProcessState && ([previousProcessState.app isPlayingAudio] || [previousProcessState.app isNowRecordingApplication] || [previousProcessState.app isConnectedToExternalAccessory])) {
		NSLog(@"Refusing to terminate %@ because audio or accessory is active.", bundleIdentifier);
		return;
	}
	
	NSLog(@"Terminating %@ due to %@", bundleIdentifier, reason);

	[self showDebugNotificationWithTitle:[previousProcessState displayName] message:reason];

	[self cancelTerminationTimer:bundleIdentifier];

	[previousProcessState.tracker terminatedInBackground];

	BKSTerminateApplicationForReasonAndReportWithDescription(bundleIdentifier, 1, NO, [NSString stringWithFormat:@"[TempSpawn] %@", reason]);
}
@end

%ctor {
	tempSpawn = [[TempSpawn alloc] init];

	[tempSpawn addObservers];
}
