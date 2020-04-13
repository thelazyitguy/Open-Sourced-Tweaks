#import <substrate.h>

%hook UIApplication

- (BOOL)_shouldBigify {
	return YES;
}

%end

%group SB

%hook SBApplicationInfo

- (bool)disableClassicMode {
	return true;
}

- (bool)wantsFullScreen {
	return false;
}

- (bool)_supportsApplicationType:(int)type {
	return %orig(type & 2 ? 1 : type);
}

%end

%hook SBApplication

- (bool)_supportsApplicationType:(int)type {
	return %orig(type & 2 ? 1 : type);
}

- (NSInteger)_defaultClassicMode {
	return 0;
}

%end

%end

%ctor {
	if (IN_SPRINGBOARD) {
		%init(SB);
	} else {
		%init;
	}
}