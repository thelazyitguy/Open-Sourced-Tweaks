#import "PerfectHomeScreen13.h"

#import <Cephei/HBPreferences.h>
#import "SparkAppList.h"
#import "SparkColourPickerUtils.h"

#define IS_iPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

static HBPreferences *pref;
static BOOL progressBarWhenDownloading;
static BOOL enableCustomProgressBarColor;
static UIColor *customProgressBarColor;
static BOOL autoCloseFolders;
static BOOL hideAppIcons;
static BOOL hideAppLabels;
static BOOL hideBlueDot;
static BOOL customBgTextColorEnable;
static BOOL customTextColorEnable;
static UIColor *customBgTextColor;
static UIColor *customTextColor;
static BOOL hideWidgetsIn3DTouch;
static BOOL hideShareAppShortcut;
static BOOL enableHomeScreenRotation;
static BOOL customHomeScreenLayoutEnabled;
static BOOL customHomeScreenRowsEnabled;
static BOOL customHomeScreenColumnsEnabled;
static BOOL customFolderRowsEnabled;
static BOOL customFolderColumnsEnabled;
static BOOL customDockColumnsEnabled;
static NSUInteger customHomeScreenRows;
static NSUInteger customHomeScreenColumns;
static NSUInteger customFolderRows;
static NSUInteger customFolderColumns;
static NSUInteger customDockColumns;

// ------------------------------ DETAILED DOWNLOAD BAR WHILE DOWNLOADING APPS ------------------------------

// ORIGINAL TWEAK @shepgoba: https://github.com/shepgoba/DownloadBar13

%group progressBarWhenDownloadingGroup

	%hook SBIconProgressView

	%property (nonatomic, strong) UILabel *progressLabel;
	%property (nonatomic, strong) UIView *progressBar;

	- (void)setFrame: (CGRect)arg1
	{
		%orig;
		if (arg1.size.width != 0)
		{
			self.progressBar.frame = CGRectMake(0, self.frame.size.height * (1 - self.displayedFraction), self.frame.size.width, self.frame.size.height * self.displayedFraction);
			self.progressLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 18);
		}
	}

	- (id)initWithFrame: (CGRect)arg1
	{
		if ((self = %orig))
		{
			self.progressBar = [[UIView alloc] init];
			self.progressBar.backgroundColor = customProgressBarColor ? customProgressBarColor : [UIColor systemBlueColor];
			self.progressBar.layer.cornerRadius = 13;
			self.progressBar.alpha = 0.7;

			self.progressLabel = [[UILabel alloc] init];
			self.progressLabel.font = [UIFont boldSystemFontOfSize: 14];
			self.progressLabel.textAlignment = NSTextAlignmentCenter;
			self.progressLabel.textColor = [UIColor whiteColor];
			self.progressLabel.text = @"0%%";

			[self addSubview: self.progressBar];
			[self addSubview: self.progressLabel];
		}
		return self;
	}

	- (void)setDisplayedFraction: (double)arg1
	{
		%orig;

		self.progressLabel.text = [NSString stringWithFormat: @"%i%%", (int)(arg1 * 100)];
		[self.progressLabel sizeToFit];
	}

	- (void)_drawPieWithCenter: (CGPoint)arg1
	{
		self.progressBar.frame = CGRectMake(0, self.frame.size.height * (1 - self.displayedFraction), self.frame.size.width, self.frame.size.height * self.displayedFraction);
		self.progressLabel.center = CGPointMake(arg1.x, arg1.y + 18);
	}

	- (void)_drawOutgoingCircleWithCenter: (CGPoint)arg1
	{

	}

	- (void)_drawIncomingCircleWithCenter: (CGPoint)arg1
	{

	}

	%end

%end

// ------------------------------ AUTO CLOSE FOLDERS ------------------------------

%group autoCloseFoldersGroup

	%hook SBHIconManager

	- (void)iconTapped: (id)arg1
	{
		if([self openedFolderController] && [[self openedFolderController] isOpen]) [[self openedFolderController] _closeFolderTimerFired];
		
		%orig;
	}

	%end

%end

// ------------------------------ HIDE APP ICONS ------------------------------

%group hideAppIconsGroup

// ORIGINAL TWEAK @menushka: https://github.com/menushka/HideYourApps

	%hook SBIconListModel

	- (id)insertIcon: (SBApplicationIcon*)icon atIndex: (unsigned long long*)arg2 options: (unsigned long long)arg3
	{
		if([SparkAppList doesIdentifier: @"com.johnzaro.perfecthomescreen13prefs.hiddenApps" andKey: @"hiddenApps" containBundleIdentifier: [icon applicationBundleID]])
			return nil;
		else return %orig;
	}

	- (BOOL)addIcon: (SBApplicationIcon*)icon asDirty: (BOOL)arg2
	{
		if([SparkAppList doesIdentifier: @"com.johnzaro.perfecthomescreen13prefs.hiddenApps" andKey: @"hiddenApps" containBundleIdentifier: [icon applicationBundleID]]) 
			return nil;
		else return %orig;
	}

	%end

%end

// ------------------------------ HIDE APP LABEL ------------------------------

%group hideAppLabelsGroup

	%hook SBIconLegibilityLabelView

	- (void)setHidden: (BOOL)arg1
	{
		%orig(YES);
	}

	%end

%end

// ------------------------------ HIDE UPDATED APP BLUE DOT ------------------------------

%group hideBlueDotGroup

	%hook SBIconView

	- (BOOL)allowsLabelAccessoryView
	{
		return NO;
	}

	%end

%end

// ------------------------------ HIDE WIDGETS IN 3D TOUCH ------------------------------

%group hideWidgetsIn3DTouchGroup

	%hook SBHIconViewContextMenuWrapperViewController

	- (void)viewWillAppear: (BOOL)arg1
	{
		[[self view] setHidden: YES];
	}

	%end

	%hook _UICutoutShadowView

	- (void)layoutSubviews
	{
		[self setHidden: YES];
	}

	%end

%end

// ------------------------------ HIDE SHARE OPTION IN 3D TOUCH MENU ------------------------------

%group hideShareAppShortcutGroup

	%hook SBIconView

	- (void)setApplicationShortcutItems: (NSArray*)arg1
	{
		NSMutableArray *newShortcuts = [[NSMutableArray alloc] init];
		for(SBSApplicationShortcutItem *shortcut in arg1)
		{
			if([shortcut.type isEqual: @"com.apple.springboardhome.application-shortcut-item.share"])
				continue;
			else [newShortcuts addObject: shortcut];
		}

		%orig(newShortcuts);
	}

	%end

%end

// ------------------------------ ENABLE / DISABLE HOME SCREEN ROTATION ------------------------------

%group homeScreenRotationGroup

	%hook SpringBoard

	-(BOOL)_statusBarOrientationFollowsWindow:(id)arg1
	{
		return NO;
	}
	
	-(long long)homeScreenRotationStyle
	{
		if(enableHomeScreenRotation) return 2;
		else return 0;
	}

	%end

%end

// ------------------------------ CUSTOM HOME SCREEN LAYOUT ------------------------------

%group customHomeScreenLayoutGroup

	%hook _SBIconGridWrapperView

	- (void)setBounds: (CGRect)arg1
	{
		int rowsOffset = 0, columnsOffset = 0;
		if(customFolderRowsEnabled)
		{
			if(customFolderRows == 4) rowsOffset = 5;
			else if(customFolderRows == 5) rowsOffset = 13;
		}
		if(customFolderColumnsEnabled)
		{
			if(customFolderColumns == 4) columnsOffset = 5;
			else if(customFolderColumns == 5) columnsOffset = 13;
		}

		if(rowsOffset != 0 || columnsOffset != 0)
		{
			CGRect newFrame = CGRectMake(arg1.origin.x + columnsOffset, arg1.origin.y + rowsOffset, arg1.size.width - 2 * columnsOffset, arg1.size.height - 2 * rowsOffset);
			%orig(newFrame);
		}
		else %orig;
	}

	%end

// Idea For The "findLocation" Method @KritantaDev: https://github.com/KritantaDev/HomePlus

	%hook SBIconListGridLayoutConfiguration

	%property (nonatomic, assign) NSString *location;

	%new
	- (NSString*)findLocation
	{
		if(self.location) return self.location;
		else
		{
			NSUInteger rows = MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows");
			NSUInteger columns = MSHookIvar<NSUInteger>(self, "_numberOfPortraitColumns");
			
			if(rows == 1) self.location = @"Dock";
			else if(rows == 3 && columns == 3 || rows == 4 && columns == 4) self.location = @"Folder";
			else self.location = @"Home";
		}
		return self.location;
	}

	- (NSUInteger)numberOfPortraitRows
	{
		[self findLocation];
		
		if([self.location isEqualToString: @"Dock"] && customDockColumnsEnabled && !IS_iPAD)
			return 1;
		else if([self.location isEqualToString: @"Folder"] && customFolderRowsEnabled)
			return customFolderRows;
		else if([self.location isEqualToString: @"Home"] && customHomeScreenRowsEnabled)
			return customHomeScreenRows;

		return %orig;
	}

	- (NSUInteger)numberOfLandscapeRows
	{
		[self findLocation];
		
		if([self.location isEqualToString: @"Dock"] && customDockColumnsEnabled && !IS_iPAD)
			return customDockColumns;
		else if([self.location isEqualToString: @"Folder"] && customFolderRowsEnabled)
			return customFolderRows;
		else if([self.location isEqualToString: @"Home"] && customHomeScreenRowsEnabled)
		{
			if(IS_iPAD) return customHomeScreenRows;
			else return customHomeScreenColumns;
		}
		
		return %orig;
	}

	- (NSUInteger)numberOfPortraitColumns
	{
		[self findLocation];
		
		if([self.location isEqualToString: @"Dock"] && customDockColumnsEnabled && !IS_iPAD)
			return customDockColumns;
		else if([self.location isEqualToString: @"Folder"] && customFolderColumnsEnabled)
			return customFolderColumns;
		else if([self.location isEqualToString: @"Home"] && customHomeScreenColumnsEnabled)
			return customHomeScreenColumns;
		
		return %orig;
	}

	- (NSUInteger)numberOfLandscapeColumns
	{
		[self findLocation];
		
		if([self.location isEqualToString: @"Dock"] && customDockColumnsEnabled && !IS_iPAD)
			return 1;
		else if([self.location isEqualToString: @"Folder"] && customFolderColumnsEnabled)
			return customFolderColumns;
		else if([self.location isEqualToString: @"Home"] && customHomeScreenColumnsEnabled)
		{
			if(IS_iPAD) return customHomeScreenColumns;
			else return customHomeScreenRows;
		}
		
		return %orig;
	}

	-(UIEdgeInsets)portraitLayoutInsets
	{
		[self findLocation];
		UIEdgeInsets x = %orig;
		
		if([self.location isEqualToString: @"Folder"] && !IS_iPAD && (customFolderRowsEnabled || customFolderColumnsEnabled))
		{
			int rowsOffset = 0, columnsOffset = 0;
			if(customFolderRowsEnabled)
			{
				if(customFolderRows == 2) rowsOffset = 40;
				else if(customFolderRows > 3) rowsOffset = -15;
			}
			if(customFolderColumnsEnabled)
			{
				if(customFolderColumns == 2) columnsOffset = 40;
				else if(customFolderColumns > 3) columnsOffset = -15;
			}
			
			if(rowsOffset != 0 || columnsOffset != 0)
				return UIEdgeInsetsMake(x.top + rowsOffset, x.left + columnsOffset, x.bottom + rowsOffset, x.right + columnsOffset);
		}
		else if([self.location isEqualToString: @"Home"] && !IS_iPAD && (customHomeScreenRowsEnabled || customHomeScreenColumnsEnabled))
		{
			int rowsOffset = 0, columnsOffset = 0;
			if(customHomeScreenRowsEnabled)
			{
				if(customHomeScreenRows == 3) rowsOffset = 100;
				else if(customHomeScreenRows == 4) rowsOffset = 60;
				else if(customHomeScreenRows > 6) rowsOffset = -20;
			}
			if(customHomeScreenColumnsEnabled)
			{
				if(customHomeScreenColumns == 3) columnsOffset = 30;
				else if(customHomeScreenColumns > 4) columnsOffset = -15;
			}
			
			if(rowsOffset != 0 || columnsOffset != 0)
				return UIEdgeInsetsMake(x.top + rowsOffset, x.left + columnsOffset, x.bottom + rowsOffset, x.right + columnsOffset);
		}
		return x;
	}

	-(UIEdgeInsets)landscapeLayoutInsets
	{
		[self findLocation];
		UIEdgeInsets x = %orig;
		
		if([self.location isEqualToString: @"Folder"] && !IS_iPAD && (customFolderRowsEnabled || customFolderColumnsEnabled))
		{
			int rowsOffset = 0, columnsOffset = 0;
			if(customFolderRowsEnabled)
			{
				if(customFolderRows == 2) rowsOffset = 40;
				else if(customFolderRows > 3) rowsOffset = -15;
			}
			if(customFolderColumnsEnabled)
			{
				if(customFolderColumns == 2) columnsOffset = 40;
				else if(customFolderColumns > 3) columnsOffset = -15;
			}
			
			if(rowsOffset != 0 || columnsOffset != 0)
				return UIEdgeInsetsMake(x.top + rowsOffset, x.left + columnsOffset, x.bottom + rowsOffset, x.right + columnsOffset);
		}
		else if([self.location isEqualToString: @"Home"] && !IS_iPAD && (customHomeScreenRowsEnabled || customHomeScreenColumnsEnabled))
		{
			int rowsOffset = 0, columnsOffset = 0;
			if(customHomeScreenRowsEnabled)
			{
				if(customHomeScreenRows == 3) columnsOffset = 100;
				else if(customHomeScreenRows == 4 || customHomeScreenRows == 5 || customHomeScreenRows == 6) columnsOffset = 70;
				else if(customHomeScreenRows > 6) columnsOffset = 60;
			}
			if(customHomeScreenColumnsEnabled)
			{
				if(customHomeScreenColumns == 3) rowsOffset = -20;
				else if(customHomeScreenColumns == 4) rowsOffset = -40;
				else if(customHomeScreenColumns >= 5) rowsOffset = -60;
			}
			
			if(rowsOffset != 0 || columnsOffset != 0)
				return UIEdgeInsetsMake(x.top + rowsOffset, x.left + columnsOffset + 20, x.bottom + rowsOffset + 20, x.right + columnsOffset - 20);
		}
		return x;
	}

	%end

	%hook SBIconListView 

	- (NSUInteger)maximumIconCount
	{
		return customHomeScreenRows * customHomeScreenColumns;
	}

	%end

%end

%group customBgTextColorGroup

	%hook SBMutableIconLabelImageParameters

	- (void)setFocusHighlightColor: (id)arg
	{
		%orig(customBgTextColor);
	}

	%end

%end

%group customTextColorGroup

	%hook SBMutableIconLabelImageParameters

	- (void)setTextColor: (id)arg
	{
		%orig(customTextColor);
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfecthomescreen13prefs"];
		[pref registerDefaults:
		@{
			@"hideAppLabels": @NO,
			@"hideBlueDot": @NO,
			@"customBgTextColorEnable": @NO,
			@"customTextColorEnable": @NO,
			@"progressBarWhenDownloading": @NO,
			@"enableCustomProgressBarColor": @NO,
			@"hideAppIcons": @NO,
			@"autoCloseFolders": @NO,
			@"hideWidgetsIn3DTouch": @NO,
			@"hideShareAppShortcut": @NO,
			@"enableHomeScreenRotation": @NO,
			@"customHomeScreenLayoutEnabled": @NO,
			@"customHomeScreenRowsEnabled": @NO,
			@"customHomeScreenColumnsEnabled": @NO,
			@"customFolderRowsEnabled": @NO,
			@"customFolderColumnsEnabled": @NO,
			@"customDockColumnsEnabled": @NO,
			@"customHomeScreenRows": @6,
			@"customHomeScreenColumns": @4,
			@"customFolderRows": @3,
			@"customFolderColumns": @3,
			@"customDockColumns": @4
    	}];

		hideAppLabels = [pref boolForKey: @"hideAppLabels"];
		hideBlueDot = [pref boolForKey: @"hideBlueDot"];
		customBgTextColorEnable = [pref boolForKey: @"customBgTextColorEnable"];
		customTextColorEnable = [pref boolForKey: @"customTextColorEnable"];
		progressBarWhenDownloading = [pref boolForKey: @"progressBarWhenDownloading"];
		enableCustomProgressBarColor = [pref boolForKey: @"enableCustomProgressBarColor"];

		hideAppIcons = [pref boolForKey: @"hideAppIcons"];
		autoCloseFolders = [pref boolForKey: @"autoCloseFolders"];
		hideWidgetsIn3DTouch = [pref boolForKey: @"hideWidgetsIn3DTouch"];
		hideShareAppShortcut = [pref boolForKey: @"hideShareAppShortcut"];
		enableHomeScreenRotation = [pref boolForKey: @"enableHomeScreenRotation"];

		if(customBgTextColorEnable || customTextColorEnable || progressBarWhenDownloading) 
		{
			NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.perfecthomescreen13prefs.colors.plist"];
			
			customBgTextColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customBgTextColor"] withFallback: @"#FFFFFF"];
			customTextColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customTextColor"] withFallback: @"#FF9400"];
			
			if(enableCustomProgressBarColor) 
				customProgressBarColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customProgressBarColor"] withFallback: @"#FF9400"];
		}

		if(hideAppLabels) %init(hideAppLabelsGroup);
		if(hideBlueDot) %init(hideBlueDotGroup);
		if(customBgTextColorEnable) %init(customBgTextColorGroup);
		if(customTextColorEnable) %init(customTextColorGroup);
		if(hideAppIcons) %init(hideAppIconsGroup);
		if(autoCloseFolders) %init(autoCloseFoldersGroup);
		if(hideWidgetsIn3DTouch) %init(hideWidgetsIn3DTouchGroup);
		if(hideShareAppShortcut) %init(hideShareAppShortcutGroup);
		if(progressBarWhenDownloading) %init(progressBarWhenDownloadingGroup);

		if(!IS_iPAD) %init(homeScreenRotationGroup);

		customHomeScreenLayoutEnabled = [pref boolForKey: @"customHomeScreenLayoutEnabled"];
		if(customHomeScreenLayoutEnabled)
		{
			customHomeScreenRowsEnabled = [pref boolForKey: @"customHomeScreenRowsEnabled"];
			customHomeScreenColumnsEnabled = [pref boolForKey: @"customHomeScreenColumnsEnabled"];
			customFolderRowsEnabled = [pref boolForKey: @"customFolderRowsEnabled"];
			customFolderColumnsEnabled = [pref boolForKey: @"customFolderColumnsEnabled"];
			customDockColumnsEnabled = [pref boolForKey: @"customDockColumnsEnabled"];

			customHomeScreenRows = [pref unsignedIntegerForKey: @"customHomeScreenRows"];
			customHomeScreenColumns = [pref unsignedIntegerForKey: @"customHomeScreenColumns"];
			customFolderRows = [pref unsignedIntegerForKey: @"customFolderRows"];
			customFolderColumns = [pref unsignedIntegerForKey: @"customFolderColumns"];
			customDockColumns = [pref unsignedIntegerForKey: @"customDockColumns"];

			%init(customHomeScreenLayoutGroup);
		}
		%init;
	}
}
