@interface SBRingerControl : NSObject
-(void)setRingerMuted:(BOOL)arg1;
-(instancetype)initWithHUDController:(id)arg1 soundController:(id)arg2;
@end

SBRingerControl *globalRingerControl;

%hook SBRingerControl
-(instancetype)initWithHUDController:(id)arg1 soundController:(id)arg2 {
	SBRingerControl *original = %orig;
	globalRingerControl = original;
	return original;
}
%end

void muteRinger(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if(globalRingerControl) {
		NSLog(@"[CCRinger13] Muting ringer...");
		[globalRingerControl setRingerMuted:YES];
	}
}

void unmuteRinger(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if(globalRingerControl) {
		NSLog(@"[CCRinger13] Unmuting ringer...");
		[globalRingerControl setRingerMuted:NO];
	}
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, muteRinger, CFSTR("me.conorthedev.ccringer13/muteringer"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, unmuteRinger, CFSTR("me.conorthedev.ccringer13/unmuteringer"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}