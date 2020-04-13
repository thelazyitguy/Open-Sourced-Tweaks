#import "PerfectSettings13.h"

#import <Cephei/HBPreferences.h>

static HBPreferences *pref;
static BOOL disableEdgeToEdgeCells;
static BOOL circleIcons;
static BOOL hideArrow;

// ------------------------- BETTER SETTINGS UI -------------------------

%group disableEdgeToEdgeCellsGroup

	%hook PSListController

	- (void)setEdgeToEdgeCells: (BOOL)arg
	{
		%orig(NO);
	}

	- (BOOL)_isRegularWidth
	{
		return YES;
	}

	%end

%end

// ------------------------- CIRCLE ICONS -------------------------

%group editPSTableCellGroup

	%hook PSTableCell

	- (void)layoutSubviews
	{
		%orig;

		if(circleIcons && [self imageView])
		{
			[[[self imageView] layer] setCornerRadius: 14.5]; // full width = 29
			[[[self imageView] layer] setMasksToBounds: YES];
		}

		if(hideArrow) [self setForceHideDisclosureIndicator: YES];
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectsettings13prefs"];
		[pref registerDefaults:
		@{
			@"disableEdgeToEdgeCells": @NO,
			@"circleIcons": @NO,
			@"hideArrow": @NO
    	}];

		disableEdgeToEdgeCells = [pref boolForKey: @"disableEdgeToEdgeCells"];
		circleIcons = [pref boolForKey: @"circleIcons"];
		hideArrow = [pref boolForKey: @"hideArrow"];

		if(disableEdgeToEdgeCells) %init(disableEdgeToEdgeCellsGroup);
		if(circleIcons || hideArrow) %init(editPSTableCellGroup);
	}
}