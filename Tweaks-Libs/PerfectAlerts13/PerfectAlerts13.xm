#include "PerfectAlerts13.h"
#import <Cephei/HBPreferences.h>
#include <dlfcn.h>

static BBServer *bbServer = nil;
static unsigned int batteryPercent;

static HBPreferences *pref;
static BOOL enabled;
static BOOL disableNotificationsFromShortcuts;
static BOOL hideDNDNotification;
static BOOL lowBatteryBanner;

static dispatch_queue_t getBBServerQueue()
{
	static dispatch_queue_t queue;
	static dispatch_once_t predicate;
	dispatch_once(&predicate,
	^{
		void *handle = dlopen(NULL, RTLD_GLOBAL);
		if(handle)
		{
			dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
			if(pointer) queue = *pointer;
			dlclose(handle);        
		}
	});
	return queue;
}

// ------------------------------ DISABLE SHORTCUTS NOTIFICATIONS ------------------------------

%group disableNotificationsFromShortcutsGroup

	%hook NCNotificationDispatcher

	- (void)postNotificationWithRequest: (NCNotificationRequest*)arg1
	{
		if(![[arg1 sectionIdentifier] isEqualToString: @"com.apple.shortcuts"]) %orig;
	}

	%end

%end

// ------------------------------ HIDE DND NOTIFICATION ------------------------------

%group hideDNDNotificationGroup

	%hook DNDNotificationsService

	- (void)_queue_postOrRemoveNotificationWithUpdatedBehavior: (bool)arg1 significantTimeChange: (bool)arg2
	{
		
	}

	%end

%end

// ------------------------------ LOW BATTERY BANNER NEEDED CODE ------------------------------

%group lowBatteryBannerGroup

	%hook BBServer

	- (id)initWithQueue: (id)arg1
	{
		bbServer = %orig;
		return bbServer;
	}

	- (id)initWithQueue: (id)arg1 dataProviderManager: (id)arg2 syncService: (id)arg3 dismissalSyncCache: (id)arg4 observerListener: (id)arg5 utilitiesListener: (id)arg6 conduitListener: (id)arg7 systemStateListener: (id)arg8 settingsListener: (id)arg9
	{
		bbServer = %orig;
		return bbServer;
	}

	- (void)dealloc
	{
		if (bbServer == self) bbServer = nil;
		%orig;
	}

	%end

	%hook SBLowPowerAlertItem

	+ (BOOL)_shouldIgnoreChangeToBatteryLevel: (unsigned)arg1
	{
		return NO;
	}

	+ (void)setBatteryLevel: (unsigned int)arg1
	{
		batteryPercent = arg1;
		%orig;
	}

	%end

	%hook SBAlertItemsController

	- (void)activateAlertItem: (id)item
	{
		if([item isKindOfClass: %c(SBLowPowerAlertItem)] && lowBatteryBanner)
		{
			BBBulletin *bulletin = [[%c(BBBulletin) alloc] init];
			bulletin.title = @"Low Battery";
			bulletin.message = [NSString stringWithFormat:@"%u%% of battery remaining", batteryPercent];
			bulletin.sectionID = @"com.apple.Preferences";
			bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
			bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
			bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
			bulletin.date = [NSDate date];
			bulletin.turnsOnDisplay = YES;
			bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID: bulletin.sectionID callblock: nil];

			if(bbServer && [bbServer respondsToSelector: @selector(publishBulletin:destinations:)])
			{
				dispatch_sync(getBBServerQueue(), 
				^{
					[bbServer publishBulletin: bulletin destinations: 14];
				});
			}
		}
		else %orig;
	}

	%end

%end

%ctor
{
    @autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectalerts13"];
		[pref registerDefaults:
		@{
			@"enabled": @NO,
			@"disableNotificationsFromShortcuts": @NO,
			@"hideDNDNotification": @NO,
			@"lowBatteryBanner": @NO
    	}];

		enabled = [pref boolForKey: @"enabled"];
		if(enabled)
		{
			disableNotificationsFromShortcuts = [pref boolForKey: @"disableNotificationsFromShortcuts"];
			hideDNDNotification = [pref boolForKey: @"hideDNDNotification"];
			lowBatteryBanner = [pref boolForKey: @"lowBatteryBanner"];

			if(disableNotificationsFromShortcuts) %init(disableNotificationsFromShortcutsGroup);
			if(hideDNDNotification) %init(hideDNDNotificationGroup);
			if(lowBatteryBanner) %init(lowBatteryBannerGroup);
		}
    }
}